import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moneym/database/database.dart';
import 'package:moneym/generated/l10n.dart';
import 'package:moneym/models/mainModel.dart';
import 'package:moneym/util/routeGenerator.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();
  runApp(MyApp());
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
        ),
      ),
    );
  }
}
