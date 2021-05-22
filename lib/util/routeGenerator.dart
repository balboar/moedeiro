import 'package:flutter/material.dart';
import 'package:moedeiro/screens/accounts/accountsPage.dart';
import 'package:moedeiro/screens/categories/categoriesPage.dart';
import 'package:moedeiro/screens/categoryDetail/categoryPage.dart';
import 'package:moedeiro/screens/lockScreen/lockScreen.dart';
import 'package:moedeiro/screens/main/mainPage.dart';
import 'package:moedeiro/screens/movements/movementsPage.dart';
import 'package:moedeiro/screens/settings/settingsPage.dart';
import 'package:moedeiro/screens/summary/summaryPage.dart';

class RouteGenerator {
  // ignore: missing_return
  static Route<Map<String, dynamic>> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    late Route<Map<String, dynamic>> route;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MainPage(),);
      case '/lockScreen':
        if (args is Map<String, dynamic>) {
          route = MaterialPageRoute(
            builder: (_) => LockScreen(
              correctString: args["pin"],
              canBiometric: args["useBiometrics"],
              showBiometricFirst: args["useBiometrics"],
            ),
          );
        } else
          route = _errorRoute() as Route<Map<String, dynamic>>;
        return route;

      case '/accountTransactionsPage':
        if (args is bool) {
          route = MaterialPageRoute(
            builder: (_) => AccountTransactionsPage(
              showAllTransactions: args,
            ),
          );
        } else
          route = MaterialPageRoute(
            builder: (_) => AccountTransactionsPage(),
          );

        return route;
      case '/categoriesPage':
        if (args is String) {
          route = MaterialPageRoute(
            builder: (_) => CategoriesPage(
              data: args,
            ),
          );
        } else
          route = MaterialPageRoute(
            builder: (_) => CategoriesPage(),
          );
        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return route;

      case '/categoryPage':
        // return MaterialPageRoute(builder: (_) => CategoriesPage());
        // Validation of correct data type
        if (args is String) {
          route = MaterialPageRoute(
            builder: (_) => CategoryPage(
              categoryUuid: args,
            ),
          );
        } else
          route = _errorRoute() as Route<Map<String, dynamic>>;
        return route;

      case '/accountsPage':
        return MaterialPageRoute(builder: (_) => AccountsPage());
      case '/settingsPage':
        return MaterialPageRoute(builder: (_) => SettingsPage());
      case '/chartsPage':
        return MaterialPageRoute(builder: (_) => SummaryPage());
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute() as Route<Map<String, dynamic>>;
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
