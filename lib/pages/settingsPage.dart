import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:moedeiro/dataModels/accounts.dart';
import 'package:moedeiro/dataModels/categories.dart';
import 'package:moedeiro/dataModels/theme.dart';
import 'package:moedeiro/dataModels/transaction.dart';
import 'package:moedeiro/database/database.dart';
import 'package:moedeiro/models/mainModel.dart';
import 'package:moedeiro/ui/dialogs/appThemeSelectionDialog.dart';
import 'package:moedeiro/ui/dialogs/languageSelectionDialog.dart';
import 'package:moedeiro/util/utils.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as db;
import 'package:path/path.dart' as p;
import 'package:moedeiro/generated/l10n.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

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
  Directory rootPath;
  String filePath;
  bool _lockApp = false;
  String locale;
  String theme;
  SharedPreferences prefs;
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

    var _locale = prefs.getString('locale') ?? 'default';
    if (_locale == 'default') {
      locale = S.of(context).systemDefaultTitle;
    } else {
      var activeLocale =
          languageOptions.firstWhere((element) => element.key == _locale);
      locale = activeLocale.value;
    }

    var _theme = prefs.getString('theme') ?? 'default';
    if (_theme == 'default') {
      theme = S.of(context).systemDefaultTitle;
    } else {
      var activeAheme =
          themeOptions.firstWhere((element) => element.key == _theme);
      theme = activeAheme.value;
    }
    setState(() {
      _lockApp = prefs.getBool('lockApp') ?? false;
    });
  }

  Future<void> _openDB(BuildContext context) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      // allowedExtensions: ['db'],
      allowMultiple: false,
    );
    if (result != null) {
      File file = File(result.files.single.path);
      if (file != null) {
        String _databasePath =
            p.join(await db.getDatabasesPath(), 'moedeiro.db');
        file.copySync(_databasePath);
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Exported!'),
          ),
        );
      }
    }
  }

  Future<void> _selectFolder(BuildContext context) async {
    String _destination = await FilePicker.platform.getDirectoryPath();
    if (_destination != null && _destination != '/') {
      String _databasePath = p.join(await db.getDatabasesPath(), 'moedeiro.db');
      var _database = File(_databasePath);
      _database.copySync(_destination + '/moedeiro.db');
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Exported!'),
        ),
      );
    }
  }

  Future<void> _openFile(BuildContext context) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
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
      File file = File(result.files.single.path);
      List<String> contents = await file.readAsLines();
      contents.removeAt(0);

      contents.forEach((element) async {
        List<String> row = element.split(',');
        accounts.add(row[0]);
        if (double.tryParse(row[4].toString().replaceAll('"', '')) >= 0)
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
          if (data != null || data.isEmpty) {
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
        String cat;
        if (double.tryParse(row[4].toString().replaceAll('"', '')) >= 0)
          cat = Provider.of<CategoryModel>(context, listen: false)
              .incomecategories
              .firstWhere((element) =>
                  element.name == row[2].toString().replaceAll('"', ''))
              .uuid;
        else
          cat = Provider.of<CategoryModel>(context, listen: false)
              .expenseCategories
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

  Future<bool> _showLanguageDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return LanguageSelectionDialog();
      },
    );
  }

  Future<bool> _showThemeDialog() async {
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
      ),
      body: SettingsList(
        // backgroundColor: Colors.orange,
        sections: [
          SettingsSection(
            titlePadding: EdgeInsets.only(
                left: 15.0, right: 15.0, bottom: 6.0, top: 10.0),
            title: S.of(context).common,
            // titleTextStyle: TextStyle(fontSize: 30),
            tiles: [
              SettingsTile(
                title: S.of(context).language,
                subtitle: locale,
                leading: Icon(Icons.language),
                onPressed: (BuildContext context) async {
                  await _showLanguageDialog();
                  var prefs = await SharedPreferences.getInstance();
                  var _locale = prefs.getString('locale');
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
                },
              ),
              SettingsTile(
                title: 'App theme',
                subtitle: theme,
                leading: Icon(Icons.lightbulb_outline),
                onPressed: (BuildContext context) async {
                  await _showThemeDialog();
                  var prefs = await SharedPreferences.getInstance();
                  var _theme = prefs.getString('theme');
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
                },
              ),
            ],
          ),
          SettingsSection(
            title: S.of(context).security,
            tiles: [
              SettingsTile.switchTile(
                title: S.of(context).lockAppInBackGround,
                leading: Icon(Icons.phonelink_lock),
                switchValue: false,
                onToggle: (bool value) {},
              ),
              SettingsTile.switchTile(
                  title: S.of(context).useFingerprint,
                  leading: Icon(Icons.fingerprint),
                  onToggle: (bool value) {},
                  switchValue: false),
              SettingsTile.switchTile(
                title: S.of(context).changePassword,
                leading: Icon(Icons.lock),
                switchValue: true,
                onToggle: (bool value) {},
              ),
            ],
          ),
          SettingsSection(
            title: S.of(context).data,
            tiles: [
              SettingsTile(
                title: S.of(context).importCSV,
                leading: Icon(Icons.import_export_outlined),
                onPressed: (BuildContext context) async {
                  _openFile(context);
                },
              ),
              SettingsTile(
                title: S.of(context).importDb,
                leading: Icon(Icons.arrow_downward_outlined),
                onPressed: (BuildContext context) async {
                  _openDB(context);
                },
              ),
              SettingsTile(
                title: S.of(context).exportDb,
                leading: Icon(Icons.arrow_upward_outlined),
                onPressed: (BuildContext context) async {
                  _selectFolder(context);
                },
              ),
            ],
          ),
          CustomSection(
            child: Column(
              children: [
                Text(
                  '${S.of(context).version} ${_packageInfo.version}',
                  style: TextStyle(color: Color(0xFF777777)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}
