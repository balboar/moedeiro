import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Locale? locale;
  String theme;
  String pin;
  ThemeModel model;
  SharedPreferences prefs;
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();

  prefs = await SharedPreferences.getInstance();

  _lockApp = prefs.getBool('lockApp') ?? false;
  _useBiometrics = prefs.getBool('useBiometrics') ?? false;
  theme = prefs.getString('theme') ?? 'system';

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
  final Locale? locale;
  final bool lockScreen;
  final bool useBiometrics;
  final String? pin;
  final String theme = 'dark';

  MyApp({
    Key? key,
    this.locale,
    required this.lockScreen,
    required this.useBiometrics,
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
        theme: ThemeData(
          // primarySwatch: Colors.blueGrey,
          accentColor: Colors.black,
          buttonBarTheme: ButtonBarThemeData(
              alignment: MainAxisAlignment.spaceAround, buttonHeight: 40.0),
          textSelectionTheme:
              TextSelectionThemeData(selectionColor: Colors.black),
          cardColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          textTheme: TextTheme(
              button: TextStyle(color: Colors.white),
              bodyText1:
                  TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
          canvasColor: Colors.grey[50],
          primaryTextTheme: TextTheme(
            headline6: TextStyle(color: Colors.black),
            bodyText1: TextStyle(color: Colors.black),
          ),
          brightness: Brightness.light,
          inputDecorationTheme: InputDecorationTheme(
            isDense: true,
          ),
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.black),
            color: Colors.grey[50],
            actionsIconTheme: IconThemeData(color: Colors.black),
            elevation: 0.0,
            centerTitle: true,
          ),
        ), //Provider.of<ThemeModel>(context, listen: true).lightTheme,
        darkTheme: ThemeData(
          primaryColor: Color(0xFF232d3a),
          primaryColorDark: Color(0xFF1c242e),
          scaffoldBackgroundColor: Color(0xFF1f2732),

          //primarySwatch: Colors.blue,
          accentColor: Color(0xFFFAEBD7), //Colors.blue[300],
          cardColor: Color(
              0xFF334051), //293342), //Colors.grey[900].withOpacity(0.8), //Color(0xFF151515),
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Color(0xFF1f2732), // Color(0xFF293342),
          ),

          buttonBarTheme: ButtonBarThemeData(
              alignment: MainAxisAlignment.spaceAround, buttonHeight: 40.0),
          textTheme: TextTheme(
              button: TextStyle(color: Colors.black),
              bodyText1:
                  TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
          // canvasColor: Color(0xFF020203),
          brightness: Brightness.dark,
          dialogTheme: DialogTheme(
            backgroundColor: Color(0xFF293342),
          ),
          toggleableActiveColor: Color(0xFFFAEBD7), // Colors.blue[400],
          inputDecorationTheme: InputDecorationTheme(
            isDense: true,
          ),
          appBarTheme: AppBarTheme(
            color: Color(0xFF293342), // Color(0xFF151515),
            elevation: 0.0, centerTitle: true,
          ),
        ), //Provider.of<ThemeModel>(context, listen: true).darkTheme,
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
