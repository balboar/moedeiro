import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:moedeiro/dataModels/theme.dart';
import 'package:moedeiro/database/database.dart';
import 'package:moedeiro/generated/l10n.dart';
import 'package:moedeiro/models/mainModel.dart';
import 'package:moedeiro/ui/lockScreen/lockScreen.dart';
import 'package:moedeiro/util/routeGenerator.dart';
import 'package:moedeiro/util/utils.dart';

Future<void> main() async {
//   debugPaintPointersEnabled = true;
//   debugPaintBaselinesEnabled = true;
//   debugPaintLayerBordersEnabled = true;
  bool _lockApp = false;
  Locale locale;
  SharedPreferences prefs;
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  await DB.init();

  prefs = await SharedPreferences.getInstance();

  _lockApp = prefs.getBool('lockApp') ?? false;
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  var _locale = prefs.getString('locale') ?? 'default';
  if (_locale == 'default') {
    locale = null;
  } else {
    var activeLocale =
        languageOptions.firstWhere((element) => element.key == _locale);
    locale = Locale.fromSubtags(languageCode: activeLocale.key);
  }

  if (_lockApp) {
    runApp(
      AppLock(
        builder: (args) => MyApp(
          locale: locale,
        ),
        lockScreen: LockScreen(
          correctString: '0000',
          canBiometric: true,
          showBiometricFirst: true,
        ),
      ),
    );
  } else
    runApp(
      ChangeNotifierProvider<ThemeModel>(
        create: (BuildContext context) => ThemeModel(),
        child: MyApp(
          locale: locale,
        ),
      ),
    );
}

class MyApp extends StatelessWidget {
  final Locale locale;

  MyApp({
    Key key,
    this.locale,
  }) : super(key: key);

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
        theme: Provider.of<ThemeModel>(context, listen: true).lightTheme,
        darkTheme: Provider.of<ThemeModel>(context, listen: true).darkTheme,
        themeMode: Provider.of<ThemeModel>(context, listen: true).themeMode,
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: '/',
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        locale: locale,
      ),
    );
  }
}
