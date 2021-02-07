import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moedeiro/models/theme.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moedeiro/database/database.dart';
import 'package:moedeiro/generated/l10n.dart';
import 'package:moedeiro/util/routeGenerator.dart';
import 'package:moedeiro/util/utils.dart';

Future<void> main() async {
//   debugPaintPointersEnabled = true;
//   debugPaintBaselinesEnabled = true;
//   debugPaintLayerBordersEnabled = true;
  bool _lockApp = false;
  bool _useBiometrics = false;
  Locale locale;
  String theme;
  String pin;
  ThemeModel model;
  SharedPreferences prefs;
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  await DB.init();

  prefs = await SharedPreferences.getInstance();

  _lockApp = prefs.getBool('lockApp') ?? false;
  _useBiometrics = prefs.getBool('useBiometrics') ?? false;
  theme = prefs.getString('theme') ?? 'system';
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  var _locale = prefs.getString('locale') ?? 'default';
  pin = prefs.getString('PIN') ?? '0000';

  if (_locale == 'default') {
    locale = null;
  } else {
    var activeLocale =
        languageOptions.firstWhere((element) => element.key == _locale);
    locale = Locale.fromSubtags(languageCode: activeLocale.key);
  }
  model = ThemeModel();
  if (theme == 'system')
    model.setSystemDefault();
  else if (theme == 'dark')
    model.setDark();
  else
    model.setLight();

  runApp(
    ChangeNotifierProvider<ThemeModel>(
      create: (BuildContext context) => model,
      child: MyApp(
        locale: locale,
        lockScreen: _lockApp,
        useBiometrics: _useBiometrics,
        pin: pin,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Locale locale;
  final bool lockScreen;
  final bool useBiometrics;
  final String pin;
  final String theme = 'dark';

  MyApp({
    Key key,
    this.locale,
    this.lockScreen,
    this.useBiometrics,
    this.pin,
  }) : super(key: key);

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
        initialRoute: lockScreen ? '/lockScreen' : '/',
        onGenerateInitialRoutes: (String initialRouteName) {
          return [
            RouteGenerator.generateRoute(RouteSettings(
                name: initialRouteName,
                arguments: {"pin": pin, "useBiometrics": useBiometrics})),
          ];
        },
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
