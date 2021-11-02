import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moedeiro/database/database.dart';
import 'package:moedeiro/models/accounts.dart';
import 'package:moedeiro/models/categories.dart';
import 'package:moedeiro/models/recurrences.dart';
import 'package:moedeiro/models/transaction.dart';
import 'package:moedeiro/models/transfer.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class AccountModel extends ChangeNotifier {
  List<Account> _accounts = [];
  bool isLoading = false;
  Uuid _uuid = Uuid();
  double expenses = 0;
  double incomes = 0;
  double _totalAmount = 0;

  Account? _activeAccount;

  List<Account> get accounts => _accounts;
  double get totalAmount => _totalAmount;

  Future<bool> getAccounts() async {
    final List<Map<String, dynamic>> maps = await DB.getAccounts();
    _accounts.clear();
    expenses = 0;
    _totalAmount = 0;
    maps.forEach((Map<String, dynamic> element) async {
      var account = Account.fromMap(element);

      final List<Map<String, dynamic>> expendesLastMonth =
          await DB.getExpensesLastMonth(element['uuid']);
      account.expensesMonth =
          double.tryParse(expendesLastMonth[0]['amount'].toString());
      expenses = expenses + account.expensesMonth!;
      _accounts.add(account);
      if (account.amount! > 0) _totalAmount = _totalAmount + account.amount!;
      notifyListeners();
    });

    return Future.value(true);
  }

  void saveAccountsPosition() {
    for (var i = 0; i < _accounts.length; i++) {
      _accounts[i].position = i;
      DB.update(Account.table, _accounts[i].toMap());
    }
  }

  void reorderAccounts(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final Account item = _accounts.removeAt(oldIndex);

    _accounts.insert(newIndex, item);
    notifyListeners();
    saveAccountsPosition();
  }

  Future<List<Map<String, dynamic>>> getChartDataByAccountAndDay(
      String uuid) async {
    return await DB.getTrasactionsLast6MonthByAccountAndDay(uuid);
  }

  set setActiveAccount(String uuid) {
    _activeAccount =
        _accounts.firstWhere((Account element) => element.uuid == uuid);
  }

  void setActiveAccountNull() {
    _activeAccount = null;
  }

  String getAccountName(String uuid) {
    return accounts.firstWhere((Account element) => element.uuid == uuid).name!;
  }

  Account? get getActiveAccount => _activeAccount;

  Future<bool> insertAccountIntoDb(Account accountData) async {
    if (accountData.uuid == null) {
      accountData.uuid = _uuid.v4();
      accountData.active = true;

      if (_accounts.length > 0) {
        accountData.position = _accounts.length + 1;
      } else
        _accounts.length = 0;

      await DB.insert(Account.table, accountData.toMap());
    } else
      await DB.update(Account.table, accountData.toMap());
    await getAccounts();
    return Future.value(true);
  }

  Future<bool> deleteAccount(String uuid) async {
    await DB.deleteItem(Account.table, uuid);
    await getAccounts();
    return Future.value(true);
  }
}

class CategoryModel extends ChangeNotifier {
  List<Categori>? _incomeCategories;
  List<Categori>? _expenseCategories;
  List<Map<String, dynamic>>? _top5Categories;
  bool isLoading = false;
  Uuid _uuid = Uuid();

  List<Categori>? get incomecategories => _incomeCategories;
  List<Categori>? get expenseCategories => _expenseCategories;
  List<Map<String, dynamic>>? get top5Categories => _top5Categories;

  Future<bool> getCategories() async {
    final List<Map<String, dynamic>> mapIncome =
        await DB.queryCategory(Categori.table, 'I');

    _incomeCategories = List.generate(mapIncome.length, (i) {
      return Categori.fromMap(mapIncome[i]);
    });

    final List<Map<String, dynamic>> mapExpenses =
        await DB.queryCategory(Categori.table, 'E');

    _expenseCategories = List.generate(mapExpenses.length, (i) {
      return Categori.fromMap(mapExpenses[i]);
    });

    final List<Map<String, dynamic>> maps = await DB.getCategoryAndMovements();

    _top5Categories = List.generate(maps.length, (i) {
      return {
        'uuid': maps[i]['uuid'],
        'name': maps[i]['name'],
        'amount': maps[i]['amount'] * -1
      };
    });

    notifyListeners();
    return Future.value(true);
  }

  bool isExpense(String categoryUuid) {
    try {
      incomecategories!.firstWhere((Categori cat) => cat.uuid == categoryUuid);
      return false;
    } catch (e) {
      return true;
    }
  }

  Categori getCategory(String categoryUuid) {
    try {
      return incomecategories!
          .firstWhere((Categori cat) => cat.uuid == categoryUuid);
    } catch (e) {
      return _expenseCategories!
          .firstWhere((Categori cat) => cat.uuid == categoryUuid);
    }
  }

  String? getCategoryName(String uuid) {
    String? name;
    try {
      name = _expenseCategories!
          .firstWhere((Categori element) => element.uuid == uuid)
          .name;
    } catch (e) {
      name = _incomeCategories!
          .firstWhere((Categori element) => element.uuid == uuid)
          .name;
    }

    return name;
  }

  insertCategoryIntoDb(Categori categoryData) async {
    if (categoryData.uuid == null) {
      categoryData.uuid = _uuid.v4();
      await DB.insert(Categori.table, categoryData.toMap());
    } else
      await DB.update(Categori.table, categoryData.toMap());
    getCategories();
  }

  Future<bool> delete(String uuid) async {
    await DB.deleteItem(Categori.table, uuid);
    await getCategories();
    return Future.value(true);
  }
}

class AnalyticsModel extends ChangeNotifier {
  List<Map<String, dynamic>> transactionsSummary = [];
  List<Map<String, dynamic>> transactionsGrouped = [];
  String? currentMonth;
  String currentYear = '';
  double totalExpenses = 0;
  double totalExpensesAbs = 0;
  int _selectedIndex = 0;

  String _transactionTypeFilter = 'E';
  Map<String, dynamic> _transactionsDateFilter = {
    'Filter': 'M',
    'Date1': null,
    'Date2': null
  };

  int get selectedIndex => _selectedIndex;
  set selectedIndex(int index) {
    _selectedIndex = index;
    var filter = _transactionsDateFilter['Filter'];
    if (filter == 'Y')
      _getTrasactionsByYearAndCategory().then((value) => notifyListeners());
    else //if (filter == 'M')
      _getTrasactionsByMonthAndCategory().then((value) => notifyListeners());
  }

  String get transactionTypeFilter => _transactionTypeFilter;
  set transactionTypeFilter(String type) {
    _transactionTypeFilter = type;
    var filter = _transactionsDateFilter['Filter'];
    if (filter == 'Y')
      _getTrasactionsGroupedByYear(_transactionTypeFilter);
    else if (filter == 'M')
      _getTrasactionsGroupedByMonth(_transactionTypeFilter);
    else if (filter == 'C') _getTrasactionsGroupedInCustomRange();
  }

  Map<String, dynamic> get transactionsDateFilter => _transactionsDateFilter;
  set transactionsDateFilter(Map<String, dynamic> data) {
    _transactionsDateFilter = data;
    var filter = _transactionsDateFilter['Filter'];
    if (filter == 'Y')
      _getTrasactionsGroupedByYear(_transactionTypeFilter);
    else if (filter == 'M')
      _getTrasactionsGroupedByMonth(_transactionTypeFilter);
    else if (filter == 'C') _getTrasactionsGroupedInCustomRange();
  }

  Future<bool> _getTrasactionsGroupedByMonth(String filter) async {
    var value = await DB.getTrasactionsGroupedByMonth(filter);
    transactionsSummary = value.reversed.toList();
    currentMonth = transactionsSummary[selectedIndex]['monthofyear'];
    currentYear = transactionsSummary[selectedIndex]['year'];
    await _getTrasactionsByMonthAndCategory();
    notifyListeners();
    return Future.value(true);
  }

  Future<bool> _getTrasactionsGroupedInCustomRange() async {
    var formatter = new DateFormat('yyyy-MM-dd');
    String date1 = formatter.format(_transactionsDateFilter['Date1']);
    String date2 = formatter.format(_transactionsDateFilter['Date2']);

    var value = await DB.getTrasactionsInDateRange(
        _transactionTypeFilter, date1, date2);
    transactionsSummary = value.reversed.toList();
    currentMonth = transactionsSummary[selectedIndex]['monthofyear'];
    currentYear = transactionsSummary[selectedIndex]['year'];
    await _getTrasactionsByMonthAndCategory();
    notifyListeners();
    return Future.value(true);
  }

  Future<bool> _getTrasactionsGroupedByYear(String filter) async {
    var value = await DB.getTrasactionsGroupedByYear(filter);
    transactionsSummary = value.reversed.toList();
    currentMonth = null;
    currentYear = transactionsSummary[selectedIndex]['year'];
    await _getTrasactionsByYearAndCategory();
    notifyListeners();
    return Future.value(true);
  }

  Future<bool> _getTrasactionsByMonthAndCategory() async {
    totalExpenses = transactionsSummary[selectedIndex]['amount'];
    totalExpensesAbs = transactionsSummary[selectedIndex]['amount_abs'];
    currentMonth = transactionsSummary[selectedIndex]['monthofyear'];
    currentYear = transactionsSummary[selectedIndex]['year'];
    await DB
        .getTrasactionsByMonthAndCategory(
            currentMonth!, currentYear, _transactionTypeFilter)
        .then((value) {
      transactionsGrouped = value;
    });
    return Future.value(true);
  }

  Future<bool> _getTrasactionsByYearAndCategory() async {
    totalExpenses = transactionsSummary[selectedIndex]['amount'];
    totalExpensesAbs = transactionsSummary[selectedIndex]['amount_abs'];
    currentMonth = null;
    currentYear = transactionsSummary[selectedIndex]['year'];
    await DB
        .getTrasactionsByYearAndCategory(currentYear, _transactionTypeFilter)
        .then((value) {
      transactionsGrouped = value;
    });
    return Future.value(true);
  }
}

class TransactionModel extends ChangeNotifier {
  List<Transaction>? _transactions;
  bool isLoading = false;
  Uuid _uuid = Uuid();

  List<Transaction>? get transactions => _transactions;

  Future<bool> getTransactions() async {
    final List<Map<String, dynamic>> maps = await DB.getTransactions();
    _transactions = List.generate(maps.length, (i) {
      return Transaction.fromMap(maps[i]);
    });
    notifyListeners();

    return Future.value(true);
  }

  Future<List<Transaction>> searchTransactions(String query) async {
    final List<Map<String, dynamic>> maps = await DB.searchTransactions(query);
    return List.generate(maps.length, (i) {
      return Transaction.fromMap(maps[i]);
    });
  }

  Future<List<Map<String, dynamic>>> getChartData() async {
    return await DB.getTrasactionsLast6Month();
  }

  Future<List<Map<String, dynamic>>> getPieChartData(
      String month, String year) async {
    return await DB.getTrasactionSummaryByMonthAndCategory(month, year);
  }

  Future<List<Map<String, dynamic>>> getChartDataByAccount(String? uuid) async {
    return await DB.getTrasactionsLast6MonthByAccount(uuid);
  }

  Future<List<Map<String, dynamic>>> getCategoryExpensesChartData() async {
    return await DB.getTrasactionsLastMonthByCategory();
  }

  Future<List<Map<String, dynamic>>> getTrasactionsByCategoryMonth(
      String month, String year, String uuid) async {
    return await DB.getTrasactionsByCategoryMonth(month, year, uuid);
  }

  List<Transaction> getAccountTransactions(String? accountUuid) {
    return _transactions!
        .where((element) => element.account == accountUuid)
        .toList();
  }

  List<Transaction> getCategoryTransactions(String? categoryUuid) {
    return _transactions!
        .where((element) => element.category == categoryUuid)
        .toList();
  }

  Future<bool> insertTransactiontIntoDb(Transaction data) async {
    if (data.uuid == null) {
      data.uuid = _uuid.v4();
      await DB.insert(Transaction.table, data.toDbMap());
    } else
      await DB.update(Transaction.table, data.toDbMap());
    await getTransactions();
    return Future.value(true);
  }

  Future<bool> delete(String uuid) async {
    await DB.deleteItem(Transaction.table, uuid);
    await getTransactions();
    return Future.value(true);
  }
}

class TransfersModel extends ChangeNotifier {
  List<Transfer>? _transfers;
  bool isLoading = false;
  Uuid _uuid = Uuid();

  List<Transfer>? get transfers => _transfers;

  Future<bool> getTransfers() async {
    final List<Map<String, dynamic>> maps = await DB.getTransfers();

    _transfers = List.generate(maps.length, (i) {
      return Transfer.fromMap(maps[i]);
    });
    notifyListeners();

    return Future.value(true);
  }

  Future<List<Map<String, dynamic>>> getChartData() async {
    return await DB.getTrasactionsLast6Month();
  }

  Future<List<Map<String, dynamic>>> getCategoryExpensesChartData() async {
    return await DB.getTrasactionsLastMonthByCategory();
  }

  List<Transfer> getAccountTransfers(String accountUuid) {
    return _transfers!.where((element) {
      if (element.accountFrom == accountUuid) {
        return true;
      } else if (element.accountTo == accountUuid) {
        return true;
      } else
        return false;
    }).toList();
  }

  Future<bool> delete(String uuid) async {
    await DB.deleteItem(Transfer.table, uuid);
    await getTransfers();
    return Future.value(true);
  }

  Future<bool> insertTransferIntoDb(Transfer data) async {
    if (data.uuid == null) {
      data.uuid = _uuid.v4();
      await DB.insert(Transfer.table, data.toDbMap());
    } else
      await DB.update(Transfer.table, data.toDbMap());
    await getTransfers();
    return Future.value(true);
  }
}

class RecurrenceModel extends ChangeNotifier {
  List<Recurrence> _recurrences = [];
  bool isLoading = false;
  Uuid _uuid = Uuid();

  List<Recurrence> get recurrences => _recurrences;

  Future<bool> getRecurrences() async {
    final List<Map<String, dynamic>> maps = await DB.getRecurrences();
    _recurrences = List.generate(maps.length, (i) {
      return Recurrence.fromMap(maps[i]);
    });
    notifyListeners();

    return Future.value(true);
  }

  int computeNextEvent(Recurrence data) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(data.timestamp!);
    if (data.nextEvent != null)
      date = DateTime.fromMillisecondsSinceEpoch(data.nextEvent!);

    var newDate = date;
    if (data.periodicity == 'D')
      newDate =
          DateTime(date.year, date.month, date.day + data.periodicityInterval!);
    else if (data.periodicity == 'W')
      newDate = DateTime(
          date.year, date.month, date.day + (data.periodicityInterval! * 7));
    else if (data.periodicity == 'M')
      newDate =
          DateTime(date.year, date.month + data.periodicityInterval!, date.day);
    else if (data.periodicity == 'Y')
      newDate =
          DateTime(date.year + data.periodicityInterval!, date.month, date.day);
    return newDate.millisecondsSinceEpoch;
  }

  Future<bool> insertRecurrenceIntoDb(Recurrence data) async {
    if (data.uuid == null) {
      data.uuid = _uuid.v4();
      if (data.nextEvent == null) {
        data.nextEvent = computeNextEvent(data);
      }
      await DB.insert(Recurrence.table, data.toDbMap());
    } else
      await DB.update(Recurrence.table, data.toDbMap());
    await getRecurrences();
    return Future.value(true);
  }

  Future<bool> delete(String uuid) async {
    await DB.deleteItem(Recurrence.table, uuid);
    await getRecurrences();
    return Future.value(true);
  }
}
