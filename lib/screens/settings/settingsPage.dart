import 'dart:async';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:moedeiro/components/dialogs/InfoDialog.dart';
import 'package:moedeiro/components/showBottomSheet.dart';
import 'package:moedeiro/database/database.dart';
import 'package:moedeiro/main.dart';
import 'package:moedeiro/models/accounts.dart';
import 'package:moedeiro/models/categories.dart';
import 'package:moedeiro/models/settings.dart';
import 'package:moedeiro/models/transaction.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/screens/lockScreen/components/passwordBottomSheet.dart';
import 'package:moedeiro/screens/settings/components/appThemeSelectionDialog.dart';
import 'package:moedeiro/screens/settings/components/languageSelectionDialog.dart';
import 'package:moedeiro/screens/settings/components/settingsWidgets.dart';
import 'package:moedeiro/util/utils.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart' as db;
import 'package:path/path.dart' as p;
import 'package:moedeiro/generated/l10n.dart';
import 'package:device_info/device_info.dart';

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
  String _localeString = '';
  String _localeLabel = '';
  String _activeTheme = '';
  String _activeThemeLabel = '';
  @override
  void initState() {
    initSettings();
    super.initState();
  }

  void initSettings() async {
    rootPath = Directory('/storage/emulated/0/Downloads');

    _localeString =
        Provider.of<SettingsModel>(context, listen: false).localeString;
    _activeTheme =
        Provider.of<SettingsModel>(context, listen: false).activeTheme;

    final PackageInfo info = await PackageInfo.fromPlatform();

    setState(() {
      _lockApp = Provider.of<SettingsModel>(context, listen: false).lockScreen;
      _useBiometrics =
          Provider.of<SettingsModel>(context, listen: false).useBiometrics;
      _packageInfo = info;
    });
  }

  Future<void> _openDB(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      // allowedExtensions: ['db'],
      allowMultiple: false,
    );
    if (result != null) {
      try {
        File file = File(result.files.single.path!);
        List<int> bytes = file.readAsBytesSync();
        Directory _destination = await getApplicationDocumentsDirectory();
        Archive archive = ZipDecoder().decodeBytes(bytes);

        for (ArchiveFile file in archive) {
          String filename = file.name;
          String decodePath = '';
          if (file.isFile) {
            if (p.extension(file.name) == '.db')
              decodePath = p.join(await (db.getDatabasesPath()), 'moedeiro.db');
            else
              decodePath = p.join(_destination.path, filename);
            List<int> data = file.content;
            File(decodePath)
              ..createSync(recursive: true)
              ..writeAsBytesSync(data);
          } else {
            Directory(decodePath)..create(recursive: true);
          }
          // String _databasePath =
          //     p.join(await (db.getDatabasesPath()), 'moedeiro.db');
          // file.copySync(_databasePath);

        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).restartMoedeiro),
          ),
        );
      } on FileSystemException catch (e) {
        showDialog<bool>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return InfoDialog(
              icon: Icons.error_outline,
              title: S.of(context).errorText,
              subtitle: e.message,
            );
          },
        );
      }
    }
  }

  Future<void> _exportDB(BuildContext context) async {
    PermissionStatus status;
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final androidInfo = await deviceInfoPlugin.androidInfo;
    if (androidInfo.version.sdkInt > 25) {
      status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        await Permission.manageExternalStorage.request();
      }
    } else {
      status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
    }

    String? _destination = await FilePicker.platform.getDirectoryPath();
    if (_destination == '/')
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid path')),
      );
    else if (_destination != null) {
      String _databasePath =
          p.join(await (db.getDatabasesPath()), 'moedeiro.db');
      var _database = File(_databasePath);

      try {
        var encoder = ZipFileEncoder();
        encoder.create('$_destination/moedeiro.zip');
        encoder.addFile(_database);
        var account =
            Provider.of<AccountModel>(context, listen: false).accounts;
        account.forEach((Account element) {
          try {
            if (element.icon != null) encoder.addFile(File(element.icon!));
          } catch (e) {}
        });
        encoder.close();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).Exported),
          ),
        );
      } on FileSystemException catch (e) {
        showDialog<bool>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return InfoDialog(
              icon: Icons.error_outline,
              title: S.of(context).errorText,
              subtitle: e.message,
            );
          },
        );
      }
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

  String _getActiveThemeLabel(String theme) {
    if (theme == 'system') {
      return S.of(context).systemDefaultTitle;
    } else {
      var activeAheme =
          themeOptions.firstWhere((element) => element.key == theme);
      return activeAheme.value;
    }
  }

  Widget _buildBody() {
    _localeLabel = getLocaleLabel(context, _localeString);
    _activeThemeLabel = _getActiveThemeLabel(_activeTheme);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings),
        centerTitle: true,
        shadowColor: Colors.transparent,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Consumer<SettingsModel>(builder:
            (BuildContext context, SettingsModel model, Widget? child) {
          return Column(
            children: [
              SectionName(S.of(context).common),
              ListTile(
                title: Text(S.of(context).language),
                subtitle: Text(_localeLabel),
                // leading: Icon(Icons.language),
                onTap: () async {
                  await _showLanguageDialog();
                  _localeString =
                      Provider.of<SettingsModel>(context, listen: false)
                          .localeString;
                  if (_localeString == 'system')
                    MyApp.setLocale(context, Localizations.localeOf(context));
                  else
                    MyApp.setLocale(context,
                        Locale.fromSubtags(languageCode: _localeString));
                  setState(() {
                    _localeLabel = getLocaleLabel(context, _localeString);
                  });
                },
              ),
              ListTile(
                title: Text(S.of(context).theme),
                subtitle: Text(_activeThemeLabel),
                //   leading: Icon(Icons.lightbulb_outline),
                onTap: () async {
                  await _showThemeDialog();

                  _activeTheme =
                      Provider.of<SettingsModel>(context, listen: false)
                          .activeTheme;

                  setState(() {
                    _activeThemeLabel = _getActiveThemeLabel(_activeTheme);
                  });
                },
              ),
              SectionName(S.of(context).security),
              SwitchListTile(
                title: Text(S.of(context).lockAppInBackGround),
                //   secondary: Icon(Icons.phonelink_lock),
                value: _lockApp,
                onChanged: (bool value) async {
                  setState(() {
                    _lockApp = !_lockApp;
                  });

                  Provider.of<SettingsModel>(context, listen: false)
                      .lockScreen = value;
                  if (value) {
                    showCustomModalBottomSheet(
                      context,
                      PasswordBottomSheet(),
                      isScrollControlled: false,
                      enableDrag: false,
                    ).then((value) {
                      var pin =
                          Provider.of<SettingsModel>(context, listen: false)
                              .pin;
                      if (pin == '')
                        setState(() {
                          _lockApp = false;
                        });
                      Provider.of<SettingsModel>(context, listen: false)
                          .lockScreen = _lockApp;
                    });
                  } else {
                    Provider.of<SettingsModel>(context, listen: false)
                        .removePin();
                  }
                },
              ),
              SwitchListTile(
                  title: Text(S.of(context).useFingerprint),
                  //   secondary: Icon(Icons.fingerprint),
                  onChanged: (bool value) async {
                    setState(() {
                      _useBiometrics = !_useBiometrics;
                    });

                    Provider.of<SettingsModel>(context, listen: false)
                        .useBiometrics = value;
                  },
                  value: _useBiometrics),
              ListTile(
                title: Text(S.of(context).changePassword),
                //   leading: Icon(Icons.lock),
                onTap: () {
                  showCustomModalBottomSheet(
                    context,
                    PasswordBottomSheet(),
                    isScrollControlled: false,
                    enableDrag: false,
                  );
                },
              ),
              SwitchListTile(
                  title: Text(S.of(context).discreetMode),
                  subtitle: Text(S.of(context).discreetModeExplanation),
                  //    secondary: Icon(Icons.visibility_outlined),
                  onChanged: (bool value) async {
                    setState(() {
                      model.discreetMode = !model.discreetMode;
                    });
                  },
                  value: model.discreetMode),
              SectionName(S.of(context).data),
              // ListTile(
              //   title: Text(S.of(context).importCSV),
              //   //   leading: Icon(Icons.import_export_outlined),
              //   onTap: () async {
              //     _openFile(context);
              //   },
              // ),
              ListTile(
                title: Text(S.of(context).importDb),
                //   leading: Icon(Icons.arrow_downward_outlined),
                onTap: () async {
                  _openDB(context);
                },
              ),
              ListTile(
                title: Text(S.of(context).exportDb),
                //    leading: Icon(Icons.arrow_upward_outlined),
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
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}
