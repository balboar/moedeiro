import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
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
    prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      child: Column(
        children: <Widget>[
          SettingsTitleWidget(
            title: 'Settings',
            icon: Icons.app_settings_alt_outlined,
            color: Colors.lightGreen,
          ),
          MyDivider(),
          // SwitchListTile(
          //     secondary: Icon(Icons.notifications_active_outlined),
          //     title: Text('Recibir notificaciones'),
          //     subtitle: Text(
          //         'Recibir notificación cuando se inicie o finalice una actividad'),
          //     value: notificar ?? false,
          //     onChanged: (bool value) {
          //       setState(() {
          //         notificar = value;
          //       });
          //       prefs.setBool('notificar', notificar);

          //       messaging.getToken().then((String token) {
          //         if (notificar)
          //           firestore.collection('clientes').add({
          //             'token': token,
          //             'fecha': DateTime.now(),
          //             'version': _packageInfo.version,
          //           });
          //         else
          //           firestore
          //               .collection('clientes')
          //               .where('token', isEqualTo: token)
          //               .get()
          //               .then((QuerySnapshot document) {
          //             firestore
          //                 .collection('clientes')
          //                 .doc(document.docs.first.id)
          //                 .delete();
          //           });
          //       });
          //     }),
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
