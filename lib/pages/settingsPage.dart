import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:moedeiro/dataModels/accounts.dart';
import 'package:moedeiro/dataModels/categories.dart';
import 'package:moedeiro/dataModels/transaction.dart';
import 'package:moedeiro/database/database.dart';
import 'package:moedeiro/models/mainModel.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    setState(() {
      _lockApp = prefs.getBool('lockApp') ?? false;
    });
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

  Widget _buildContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      child: Column(
        children: <Widget>[
          Text(
            'Settings',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SettingsTitleWidget(
            title: 'Security',
            icon: Icons.security_outlined,
            color: Colors.redAccent,
          ),
          MyDivider(),
          SwitchListTile(
              secondary: Icon(Icons.lock_open_outlined),
              title: Text('Access protection'),
              value: _lockApp,
              onChanged: (bool value) {
                setState(() {
                  _lockApp = value;
                });
                prefs.setBool('lockApp', _lockApp);
              }),
          SizedBox(
            height: 15.0,
          ),
          SettingsTitleWidget(
            title: 'Data',
            icon: Icons.archive_outlined,
            color: Colors.blueAccent,
          ),
          MyDivider(),
          ListTile(
            leading: Icon(Icons.import_export_outlined),
            title: Text('Import from CSV'),
            onTap: () async {
              _openFile(context);
            },
          ),
          SizedBox(
            height: 15.0,
          ),
          SettingsTitleWidget(
            title: 'Acerca de',
            icon: Icons.info_outline,
            color: Colors.orange,
          ),
          MyDivider(),
          ListTile(
            leading: Icon(Icons.app_registration),
            title: Text('Versión'),
            subtitle: Text(_packageInfo.version),
          )
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: _buildContent(context),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}

class SettingsTitleWidget extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  const SettingsTitleWidget({Key key, this.title, this.color, this.icon})
      : assert(title != null),
        assert(color != null),
        assert(icon != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17.0),
          child: Icon(
            icon,
            color: color,
            size: 25.0,
          ),
        ),
        Text(
          title,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 18.0),
        ),
      ],
    );
  }
}

class MyDivider extends StatelessWidget {
  const MyDivider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      // color: Theme.of(context).accentColor,
      thickness: 2.0,
    );
  }
}
