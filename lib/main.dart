import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moedeiro/models/settings.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/theme/appTheme.dart';
import 'package:provider/provider.dart';
import 'package:moedeiro/database/database.dart';
import 'package:moedeiro/generated/l10n.dart';
import 'package:moedeiro/util/routeGenerator.dart';

Future<void> main() async {
//   debugPaintPointersEnabled = true;
//   debugPaintBaselinesEnabled = true;
//   debugPaintLayerBordersEnabled = true;

  SettingsModel model;
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();
  model = SettingsModel();
  await model.initPrefs();

  runApp(
    ChangeNotifierProvider<SettingsModel>(
      create: (BuildContext context) => model,
      child: MyApp(
        locale: model.locale,
        lockScreen: model.lockScreen,
        useBiometrics: model.useBiometrics,
        pin: model.pin,
        firstTime: model.firstTime,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Locale? locale;
  final bool lockScreen;
  final bool useBiometrics;
  final String? pin;
  final bool firstTime;
  final String theme = 'dark';

  MyApp({
    Key? key,
    this.locale,
    required this.lockScreen,
    required this.useBiometrics,
    required this.firstTime,
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
        ChangeNotifierProvider<AnalyticsModel>(
          create: (BuildContext context) => AnalyticsModel(),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: Provider.of<SettingsModel>(context, listen: true).themeMode,
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: lockScreen
            ? '/lockScreen'
            : firstTime
                ? '/welcomePage'
                : '/',
        onGenerateInitialRoutes: (String initialRouteName) {
          return [
            RouteGenerator.generateRoute(
                RouteSettings(name: initialRouteName, arguments: {
              "pin": pin,
              "useBiometrics": useBiometrics,
            })),
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
