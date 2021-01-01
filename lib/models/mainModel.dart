import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moedeiro/dataModels/accounts.dart';
import 'package:moedeiro/dataModels/categories.dart';
import 'package:moedeiro/dataModels/transaction.dart';
import 'package:moedeiro/database/database.dart';
import 'package:uuid/uuid.dart';

class AccountModel extends ChangeNotifier {
  List<Account> _accounts = [];
  bool isLoading = false;
  Uuid _uuid = Uuid();
  double expenses = 0;
  double incomes = 0;

  Account _activeAccount;

  List<Account> get accounts => _accounts;

  Future<bool> getAccounts() async {
    final List<Map<String, dynamic>> maps = await DB.query('accounts');
    _accounts.clear();
    maps.forEach((Map<String, dynamic> element) async {
      final List<Map<String, dynamic>> expenses =
          await DB.getAllExpenses(element['uuid']);
      final List<Map<String, dynamic>> income =
          await DB.getAllIncomes(element['uuid']);
      var account = Account.fromMap(element);
      account.amount = double.parse(
          (account.initialAmount - expenses[0]['amount'] + income[0]['amount'])
              .toStringAsFixed(2));

      _accounts.add(account);
      notifyListeners();
    });

    return Future.value(true);
  }

  set setActiveAccount(String uuid) {
    _activeAccount =
        _accounts.firstWhere((Account element) => element.uuid == uuid);
  }

  void setActiveAccountNull() {
    _activeAccount = null;
  }

  String getAccountName(String uuid) {
    return accounts.firstWhere((Account element) => element.uuid == uuid).name;
  }

  Account get getActiveAccount => _activeAccount;

  insertAccountIntoDb(Account accountData) async {
    if (accountData.uuid == null) {
      accountData.uuid = _uuid.v4();
      await DB.insert(Account.table, accountData.toMap());
    } else
      await DB.update(Account.table, accountData.toMap());
    getAccounts();
  }

  // void updateFichaje(Map<String, dynamic> _fichaje) async {
  //   if (_fichaje['user'] == null) {
  //     throw ('El usuario no puede ser nulo');
  //   }
  //   DB.update(Fichaje.table, _fichaje);
  //   getFichajes(_fichaje['user']);
  //   syncFichajeWithServer(Fichaje.fromMap(_fichaje));
  // }

  Future<Map<String, dynamic>> deleteAccount(String uuid) async {
    DB.deleteItem(Account.table, uuid);
    _accounts.removeWhere((element) => element.uuid == uuid);
    notifyListeners();
  }
}

class CategoryModel extends ChangeNotifier {
  List<Categori> _incomeCategories;
  List<Categori> _expenseCategories;
  List<Map<String, dynamic>> _top5Categories;
  bool isLoading = false;
  Uuid _uuid = Uuid();

  List<Categori> get incomecategories => _incomeCategories;
  List<Categori> get expenseCategories => _expenseCategories;
  List<Map<String, dynamic>> get top5Categories => _top5Categories;

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
        'amount': maps[i]['amount']
      };
    });

    notifyListeners();
    return Future.value(true);
  }

  String getCategoryName(String uuid) {
    String name;
    try {
      name = _expenseCategories
          .firstWhere((Categori element) => element.uuid == uuid)
          .name;
    } catch (e) {
      name = _incomeCategories
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
}

class TransactionModel extends ChangeNotifier {
  List<Transaction> _transactions;
  bool isLoading = false;
  Uuid _uuid = Uuid();

  List<Transaction> get transactions => _transactions;

  Future<bool> getTransactions() async {
    final List<Map<String, dynamic>> maps = await DB.getTransactions();

    _transactions = List.generate(maps.length, (i) {
      return Transaction.fromMap(maps[i]);
    });
    notifyListeners();
    return Future.value(true);
  }

  insertTransactiontIntoDb(Transaction data) async {
    if (data.uuid == null) {
      data.uuid = _uuid.v4();
      await DB.insert(Transaction.table, data.toMap());
    } else
      await DB.update(Transaction.table, data.toMap());
    getTransactions();
  }
}
