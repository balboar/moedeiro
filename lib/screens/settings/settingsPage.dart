import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:moedeiro/components/showBottomSheet.dart';
import 'package:moedeiro/database/database.dart';
import 'package:moedeiro/models/accounts.dart';
import 'package:moedeiro/models/categories.dart';
import 'package:moedeiro/models/theme.dart';
import 'package:moedeiro/models/transaction.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/screens/lockScreen/components/passwordBottomSheet.dart';
import 'package:moedeiro/screens/settings/components/appThemeSelectionDialog.dart';
import 'package:moedeiro/screens/settings/components/languageSelectionDialog.dart';
import 'package:moedeiro/screens/settings/components/settingsWidgets.dart';
import 'package:moedeiro/util/utils.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as db;
import 'package:path/path.dart' as p;
import 'package:moedeiro/generated/l10n.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );
  Directory? rootPath;
  String? filePath;
  bool _lockApp = false;
  bool _useBiometrics = false;
  String locale = 'default';
  String theme = 'default';
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    getSettings();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  void getSettings() async {
    rootPath = Directory('/storage/emulated/0/Downloads');

    prefs = await SharedPreferences.getInstance();

    var _locale = prefs.getString('locale');
    if (_locale == 'default') {
      locale = S.of(context).systemDefaultTitle;
    } else {
      var activeLocale =
          languageOptions.firstWhere((element) => element.key == _locale);
      locale = activeLocale.value;
    }

    var _theme = prefs.getString('theme');
    if (_theme == 'default') {
      theme = S.of(context).systemDefaultTitle;
    } else {
      var activeAheme =
          themeOptions.firstWhere((element) => element.key == _theme);
      theme = activeAheme.value;
    }
    setState(() {
      _lockApp = prefs.getBool('lockApp') ?? false;
      _useBiometrics = prefs.getBool('useBiometrics') ?? false;
    });
  }

  Future<void> _openDB(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      // allowedExtensions: ['db'],
      allowMultiple: false,
    );
    if (result != null) {
      File file = File(result.files.single.path!);

      String _databasePath =
          p.join(await (db.getDatabasesPath()), 'moedeiro.db');
      file.copySync(_databasePath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exported!'),
        ),
      );
    }
  }

  Future<void> _exportDB(BuildContext context) async {
    // var status = await Permission.storage.status;
    // if (!status.isGranted) {
    //   await Permission.storage.request();
    // }
    String? _destination = await FilePicker.platform.getDirectoryPath();
    if (_destination != null && _destination != '/') {
      String _databasePath =
          p.join(await (db.getDatabasesPath()), 'moedeiro.db');
      var _database = File(_databasePath);
      _database.copySync(_destination + '/moedeiro.db');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exported!'),
        ),
      );
    }
  }

  Future<void> _openFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );
// I/flutter (13953): ["wallet", "currency", "category", "datetime", "money", "description"]
// I/flutter (13953): ["Efectivo", "EUR", "Comida trabajo", "2020-12-31 17:06:50", "-7, 00", ""]
//var moonLanding = DateTime.parse("1969-07-20 20:18:04Z");  // 8:18pm
    var accounts = Set();
    var income = Set();
    var expense = Set();
    if (result != null) {
      File file = File(result.files.single.path!);
      List<String> contents = await file.readAsLines();
      contents.removeAt(0);

      contents.forEach((element) async {
        List<String> row = element.split(',');
        accounts.add(row[0]);
        if (double.tryParse(row[4].toString().replaceAll('"', ''))! >= 0)
          income.add(row[2].toString().replaceAll('"', ''));
        else
          expense.add(row[2].toString().replaceAll('"', ''));

        print(row);
      });

      accounts.forEach((element) async {
        if (element != null) {
          element = element.toString().replaceAll('"', '');
          List<Map<String, dynamic>> data = await DB.query('accounts',
              where: 'name=?', whereArgs: [element.toString()]);
          if (data.isEmpty) {
            await Provider.of<AccountModel>(context, listen: false)
                .insertAccountIntoDb(
              Account(name: element.toString(), initialAmount: 0),
            );
          } else if (data[0]['name'].isEmpty)
            await Provider.of<AccountModel>(context, listen: false)
                .insertAccountIntoDb(
              Account(name: element.toString(), initialAmount: 0),
            );
        }
      });

      income.forEach((element) async {
        if (element != null) {
          element = element.toString().replaceAll('"', '');
          List<Map<String, dynamic>> data = await DB.query('category',
              where: 'name=?', whereArgs: [element.toString()]);
          if (data == null || data.isEmpty) {
            await Provider.of<CategoryModel>(context, listen: false)
                .insertCategoryIntoDb(
              Categori(name: element.toString(), type: 'I'),
            );
          } else if (data[0]['name'].isEmpty)
            await Provider.of<CategoryModel>(context, listen: false)
                .insertCategoryIntoDb(
              Categori(name: element.toString(), type: 'I'),
            );
        }
      });

      expense.forEach((element) async {
        if (element != null) {
          element = element.toString().replaceAll('"', '');
          List<Map<String, dynamic>> data = await DB.query('category',
              where: 'name=?', whereArgs: [element.toString()]);
          if (data == null || data.isEmpty) {
            await Provider.of<CategoryModel>(context, listen: false)
                .insertCategoryIntoDb(
              Categori(name: element.toString(), type: 'E'),
            );
          } else if (data[0]['name'].isEmpty)
            await Provider.of<CategoryModel>(context, listen: false)
                .insertCategoryIntoDb(
              Categori(name: element.toString(), type: 'E'),
            );
        }
      });
      Provider.of<AccountModel>(context, listen: false).getAccounts();
      Provider.of<CategoryModel>(context, listen: false).getCategories();

      sleep(Duration(seconds: 5));

      contents.forEach((element) async {
        List<String> row = element.split(',');
        row[4] = row[4] + '.' + row[5];
        row[4] = row[4].toString().replaceAll('"', '');
        var account = Provider.of<AccountModel>(context, listen: false)
            .accounts
            .firstWhere((element) =>
                element.name == row[0].toString().replaceAll('"', ''))
            .uuid;
        String? cat;
        if (double.tryParse(row[4].toString().replaceAll('"', ''))! >= 0)
          cat = Provider.of<CategoryModel>(context, listen: false)
              .incomecategories!
              .firstWhere((element) =>
                  element.name == row[2].toString().replaceAll('"', ''))
              .uuid;
        else
          cat = Provider.of<CategoryModel>(context, listen: false)
              .expenseCategories!
              .firstWhere((element) =>
                  element.name == row[2].toString().replaceAll('"', ''))
              .uuid;
        await Provider.of<TransactionModel>(context, listen: false)
            .insertTransactiontIntoDb(
          Transaction(
              amount: double.tryParse(row[4].toString().replaceAll('"', '')),
              name: row[6].toString().replaceAll('"', ''),
              timestamp: DateTime.parse(row[3].toString().replaceAll('"', ''))
                  .millisecondsSinceEpoch,
              account: account,
              category: cat),
        );

        print(row);
      });
    } else {
      // User canceled the picker
    }
  }

  Future<bool?> _showLanguageDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return LanguageSelectionDialog();
      },
    );
  }

  Future<bool?> _showThemeDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AppThemeSelectionDialog();
      },
    );
  }

  Widget _buildBody() {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings),
        centerTitle: true,
        shadowColor: Colors.transparent,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SectionName(S.of(context).common),
            ListTile(
              title: Text(S.of(context).language),
              subtitle: Text(locale),
              leading: Icon(Icons.language),
              onTap: () async {
                await _showLanguageDialog();
                var prefs = await SharedPreferences.getInstance();
                var _locale = prefs.getString('locale');
                if (_locale != null) {
                  if (_locale == 'default') {
                    setState(() {
                      locale = S.of(context).systemDefaultTitle;
                    });
                  } else {
                    var activeLocale = languageOptions
                        .firstWhere((element) => element.key == _locale);
                    setState(() {
                      locale = activeLocale.value;
                    });
                  }
                }
              },
            ),
            ListTile(
              title: Text(S.of(context).theme),
              subtitle: Text(theme),
              leading: Icon(Icons.lightbulb_outline),
              onTap: () async {
                await _showThemeDialog();
                var prefs = await SharedPreferences.getInstance();
                var _theme = prefs.getString('theme');
                if (_theme != null) {
                  if (_theme == 'default') {
                    setState(() {
                      theme = S.of(context).systemDefaultTitle;
                      Provider.of<ThemeModel>(context, listen: false)
                          .setSystemDefault();
                    });
                  } else {
                    var activeTheme = themeOptions
                        .firstWhere((element) => element.key == _theme);
                    setState(() {
                      theme = activeTheme.value;
                    });

                    if (_theme == 'dark')
                      Provider.of<ThemeModel>(context, listen: false).setDark();
                    else
                      Provider.of<ThemeModel>(context, listen: false)
                          .setLight();
                  }
                }
              },
            ),
            SectionName(S.of(context).security),
            SwitchListTile(
              title: Text(S.of(context).lockAppInBackGround),
              secondary: Icon(Icons.phonelink_lock),
              value: _lockApp,
              onChanged: (bool value) async {
                setState(() {
                  _lockApp = !_lockApp;
                });

                var prefs = await SharedPreferences.getInstance();
                prefs.setBool('lockApp', _lockApp);
                if (value) {
                  showCustomModalBottomSheet(
                    context,
                    PasswordBottomSheet(),
                    isScrollControlled: false,
                    enableDrag: false,
                  ).then((value) {
                    var pin = prefs.getString('PIN');
                    if (pin == null)
                      setState(() {
                        _lockApp = false;
                      });
                    prefs.setBool('lockApp', _lockApp);
                  });
                } else {
                  prefs.remove('PIN');
                }
              },
            ),
            SwitchListTile(
                title: Text(S.of(context).useFingerprint),
                secondary: Icon(Icons.fingerprint),
                onChanged: (bool value) async {
                  setState(() {
                    _useBiometrics = !_useBiometrics;
                  });
                  var prefs = await SharedPreferences.getInstance();
                  prefs.setBool('useBiometrics', _useBiometrics);
                },
                value: _useBiometrics),
            ListTile(
              title: Text(S.of(context).changePassword),
              leading: Icon(Icons.lock),
              onTap: () {
                showCustomModalBottomSheet(
                  context,
                  PasswordBottomSheet(),
                  isScrollControlled: false,
                  enableDrag: false,
                );
              },
            ),
            SectionName(S.of(context).data),
            ListTile(
              title: Text(S.of(context).importCSV),
              leading: Icon(Icons.import_export_outlined),
              onTap: () async {
                _openFile(context);
              },
            ),
            ListTile(
              title: Text(S.of(context).importDb),
              leading: Icon(Icons.arrow_downward_outlined),
              onTap: () async {
                _openDB(context);
              },
            ),
            ListTile(
              title: Text(S.of(context).exportDb),
              leading: Icon(Icons.arrow_upward_outlined),
              onTap: () async {
                _exportDB(context);
              },
            ),
            AboutListTile(
              applicationVersion:
                  '${S.of(context).version} ${_packageInfo.version}',
              applicationName: 'Moedeiro',
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}
