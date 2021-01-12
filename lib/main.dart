import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:moedeiro/database/database.dart';
import 'package:moedeiro/generated/l10n.dart';
import 'package:moedeiro/models/mainModel.dart';
import 'package:moedeiro/ui/lockScreen/lockScreen.dart';
import 'package:moedeiro/util/routeGenerator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
//   debugPaintPointersEnabled = true;
//   debugPaintBaselinesEnabled = true;
//   debugPaintLayerBordersEnabled = true;
  bool _lockApp = false;
  SharedPreferences prefs;
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();

  prefs = await SharedPreferences.getInstance();

  _lockApp = prefs.getBool('lockApp') ?? false;

  if (_lockApp) {
    runApp(
      AppLock(
        builder: (args) => MyApp(),
        lockScreen: LockScreen(
          correctString: '0000',
          canBiometric: true,
          showBiometricFirst: true,
        ),
      ),
    );
  } else
    runApp(
      MyApp(),
    );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AccountModel>(
          create: (BuildContext context) => AccountModel(),
        ),
        ChangeNotifierProvider<CategoryModel>(
          create: (BuildContext context) => CategoryModel(),
        ),
        ChangeNotifierProvider<TransactionModel>(
          create: (BuildContext context) => TransactionModel(),
        ),
        ChangeNotifierProvider<TransfersModel>(
          create: (BuildContext context) => TransfersModel(),
        ),
      ],
      child: MaterialApp(
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: '/',
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          cardTheme: CardTheme(color: Colors.grey[700]),
        ),
      ),
    );
  }
}
