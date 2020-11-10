import 'package:flutter/material.dart';
import 'package:moneym/dataModels/accounts.dart';
import 'package:moneym/database/database.dart';
import 'package:uuid/uuid.dart';

class AccountModel extends ChangeNotifier {
  List<Account> _accounts;
  bool isLoading = false;
  Uuid _uuid = Uuid();

  Account _activeAccount;

  List<Account> get accounts => _accounts;

  Future<bool> getAccounts() async {
    final List<Map<String, dynamic>> maps = await DB.query('accounts');

    _accounts = List.generate(maps.length, (i) {
      return Account.fromMap(maps[i]);
    });
    notifyListeners();
    return Future.value(true);
  }

  set setActiveAccount(String uuid) {
    _activeAccount =
        _accounts.firstWhere((Account element) => element.uuid == uuid);
  }

  Account get getActiveAccount => _activeAccount;

  insertAccountIntoDb(Map<String, dynamic> accountData) async {
    final Account _account = Account(
        uuid: _uuid.v4(),
        name: accountData['name'],
        initialAmount: accountData['initialAmount']);
    DB.insert(Account.table, _account.toMap());
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

  // Future<Map<String, dynamic>> deleteFichajeItem(Fichaje fichaje) async {
  //   DB.deleteItem(Fichaje.table, fichaje.uuid);
  //   getFichajes(fichaje.user);
  //   var resultado = await Api.borrarFichaje(fichaje.uuid);
  //   return resultado;
  // }
}
