import 'package:flutter/material.dart';
import 'package:moedeiro/pages/accountsPage.dart';
import 'package:moedeiro/pages/categoriesPage.dart';
import 'package:moedeiro/pages/chartsPage.dart';
import 'package:moedeiro/pages/mainPage.dart';
import 'package:moedeiro/pages/settingsPage.dart';
import 'package:moedeiro/pages/movementsPage.dart';
import 'package:moedeiro/ui/lockScreen/lockScreen.dart';

class RouteGenerator {
  static Route<Map<String, dynamic>> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MainPage());
      case '/lockScreen':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => LockScreen(
              correctString: args["pin"],
              canBiometric: args["useBiometrics"],
              showBiometricFirst: args["useBiometrics"],
            ),
          );
        }
        break;
      case '/accountTransactionsPage':
        if (args is bool) {
          return MaterialPageRoute(
            builder: (_) => AccountTransactionsPage(
              showAllTransactions: args,
            ),
          );
        } else
          return MaterialPageRoute(
            builder: (_) => AccountTransactionsPage(),
          );
        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        break;
      case '/categoriesPage':
        // return MaterialPageRoute(builder: (_) => CategoriesPage());
        // Validation of correct data type
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => CategoriesPage(
              data: args,
            ),
          );
        } else
          return MaterialPageRoute(
            builder: (_) => CategoriesPage(),
          );
        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        break;
      case '/accountsPage':
        return MaterialPageRoute(builder: (_) => AccountsPage());
      case '/settingsPage':
        return MaterialPageRoute(builder: (_) => SettingsPage());
      case '/chartsPage':
        return MaterialPageRoute(builder: (_) => ChartsPage());
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
