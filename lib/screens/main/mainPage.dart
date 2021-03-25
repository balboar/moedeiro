import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moedeiro/components/moedeiroWidgets.dart';
import 'package:moedeiro/components/showBottomSheet.dart';
import 'package:moedeiro/models/theme.dart';
import 'package:moedeiro/models/transaction.dart';
import 'package:moedeiro/models/transfer.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/screens/movements/components/transactionBottomSheet.dart';
import 'package:moedeiro/screens/movements/components/transactionTransferBottomSheetWidget.dart';
import 'package:moedeiro/screens/movements/components/transactionWidgets.dart';
import 'package:moedeiro/screens/movements/components/transferBottomSheetWidget.dart';
import 'package:moedeiro/util/utils.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:moedeiro/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> with WidgetsBindingObserver {
  late bool lockScreen;
  bool? useBiometrics;
  bool ammountVisible = true;
  String? pin;
  @override
  void initState() {
    loadSettings();
    Provider.of<AccountModel>(context, listen: false).getAccounts();
    Provider.of<CategoryModel>(context, listen: false).getCategories();
    Provider.of<TransactionModel>(context, listen: false).getTransactions();
    Provider.of<TransfersModel>(context, listen: false).getTransfers();
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    final QuickActions quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      // AppLock.of(context).showLockScreen();
      if (shortcutType == 'transaction') {
        showCustomModalBottomSheet(
            context,
            TransactionBottomSheet(
                Transaction(timestamp: DateTime.now().millisecondsSinceEpoch)));
      } else if (shortcutType == 'transfer') {
        showCustomModalBottomSheet(
            context,
            TransferBottomSheet(
                Transfer(timestamp: DateTime.now().millisecondsSinceEpoch)));
      }
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      // NOTE: This first action icon will only work on iOS.
      // In a real world project keep the same file name for both platforms.
      const ShortcutItem(
        type: 'transaction',
        localizedTitle: 'Transaction',
        icon: 'add',
      ),
      const ShortcutItem(
        type: 'transfer',
        localizedTitle: 'Transfer',
        icon: 'transfer',
      ),
      // NOTE: This second action icon will only work on Android.
    ]);
  }

  void loadSettings() async {
    var prefs = await SharedPreferences.getInstance();

    lockScreen = prefs.getBool('lockApp') ?? false;
    useBiometrics = prefs.getBool('useBiometrics') ?? false;
    pin = prefs.getString('PIN') ?? '0000';
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // went to Background
    }
    if (state == AppLifecycleState.resumed) {
      if (lockScreen)
        Navigator.pushReplacementNamed(context, '/lockScreen',
            arguments: {"pin": pin, "useBiometrics": useBiometrics});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        statusBarIconBrightness:
            Provider.of<ThemeModel>(context, listen: false).getThemeMode() ==
                    ThemeMode.dark
                ? Brightness.light
                : Brightness.dark,
        systemNavigationBarIconBrightness:
            Provider.of<ThemeModel>(context, listen: false).getThemeMode() ==
                    ThemeMode.dark
                ? Brightness.light
                : Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showCustomModalBottomSheet(
              context,
              TransactionTransferBottomSheet(),
            );
          },
          child: Icon(Icons.add_outlined),
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                actions: [
                  IconButton(
                    icon: Icon(ammountVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    tooltip: S.of(context).settings,
                    padding: EdgeInsets.symmetric(vertical: 22, horizontal: 10),
                    iconSize: 30,
                    onPressed: () {
                      setState(() {
                        ammountVisible = !ammountVisible;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.settings_outlined,
                    ),
                    tooltip: S.of(context).settings,
                    padding: EdgeInsets.symmetric(vertical: 22, horizontal: 10),
                    iconSize: 30,
                    onPressed: () =>
                        Navigator.pushNamed(context, '/settingsPage'),
                  ),
                ],
                pinned: false,
                expandedHeight: 200,
                collapsedHeight: 80,
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(
                    left: 20.0,
                    right: 10.0,
                    top: 0.0,
                    bottom: 10.0,
                  ),
                  centerTitle: false,
                  title: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/accountsPage',
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          S.of(context).balance,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        Consumer<AccountModel>(builder: (BuildContext context,
                            AccountModel model, Widget? child) {
                          return Text(
                            ammountVisible == true
                                ? '${formatCurrency(context, model.totalAmount)}'
                                : '${formatHiddenCurrency(context)}',
                            style: Theme.of(context).textTheme.headline4,
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    // Padding(
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       Navigator.pushNamed(
                    //         context,
                    //         '/accountsPage',
                    //       );
                    //     },
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           S.of(context).balance,
                    //           style: Theme.of(context).textTheme.bodyText2,
                    //         ),
                    //         Consumer<AccountModel>(builder:
                    //             (BuildContext context, AccountModel model,
                    //                 Widget child) {
                    //           return Text(
                    //             '${formatCurrency(context, model.totalAmount)}',
                    //             style: Theme.of(context).textTheme.headline4,
                    //           );
                    //         }),
                    //       ],
                    //     ),
                    //   ),
                    //   padding: EdgeInsets.only(
                    //     left: 20.0,
                    //     right: 10.0,
                    //     top: 15.0,
                    //     bottom: 10.0,
                    //   ),
                    // ),
                    // Consumer<AccountModel>(
                    //   builder: (BuildContext context, AccountModel model,
                    //       Widget child) {
                    //     if (model.accounts == null)
                    //       return Container(
                    //         height: 100,
                    //         margin: EdgeInsets.only(
                    //             left: 10.0, top: 2.0, bottom: 10.0),
                    //         child: Center(
                    //           child: CircularProgressIndicator(),
                    //         ),
                    //       );
                    //     else if (model.accounts.length == 0)
                    //       return Container(
                    //         height: 100,
                    //         margin: EdgeInsets.only(
                    //             left: 10.0, top: 2.0, bottom: 10.0),
                    //         child: NoDataWidgetHorizontal(),
                    //       );
                    //     else
                    //       return Container(
                    //         height: 100,
                    //         margin: EdgeInsets.only(
                    //             left: 10.0, top: 2.0, bottom: 10.0),
                    //         child: ListView.builder(
                    //           itemCount: model.accounts.length,
                    //           scrollDirection: Axis.horizontal,
                    //           itemBuilder: (BuildContext context, int index) {
                    //             return AccountMiniCard(
                    //                 account: model.accounts[index]);
                    //           },
                    //         ),
                    //       );
                    //   },
                    // ),

                    Consumer<AccountModel>(builder: (BuildContext context,
                        AccountModel model, Widget? child) {
                      //formatCurrency(context, model.expenses)
                      return MainPageSectionStateless(
                        S.of(context).expensesMonth,
                        () {
                          Navigator.pushNamed(
                            context,
                            '/chartsPage',
                          );
                        },
                        subtitle: formatCurrency(context, model.expenses),
                      );
                    }),
                    MainPageSectionStateless(
                      S.of(context).categories,
                      () {
                        Navigator.pushNamed(
                          context,
                          '/categoriesPage',
                        );
                      },
                    ),

                    MainPageSectionStateless(
                      S.of(context).transactionsTitle,
                      () {
                        Provider.of<AccountModel>(context, listen: false)
                            .setActiveAccountNull();
                        Navigator.pushNamed(context, '/accountTransactionsPage',
                            arguments: true);
                      },
                      padding: EdgeInsets.only(
                          left: 20.0, right: 10.0, top: 20.0, bottom: 0.0),
                    ),
                    Consumer<TransactionModel>(
                      builder: (BuildContext context, TransactionModel model,
                          Widget? child) {
                        if (model.transactions == null)
                          return Container(
                            height: 100,
                            margin: EdgeInsets.only(
                                left: 10.0, right: 10, top: 0, bottom: 10.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        else if (model.transactions!.length == 0)
                          return Container(
                            height: 100,
                            margin: EdgeInsets.only(
                                left: 10.0, right: 10, top: 0.0, bottom: 10.0),
                            child: NoDataWidgetHorizontal(),
                          );
                        else
                          return Container(
                            margin: EdgeInsets.only(
                                left: 10.0, right: 10, top: 0.0, bottom: 10.0),
                            child: Column(
                              children: model.transactions!.length > 5
                                  ? model.transactions!
                                      .sublist(0, 5)
                                      .map((Transaction transaction) {
                                      return Container(
                                        height: 75,
                                        child: TransactionTile(transaction),
                                      );
                                    }).toList()
                                  : model.transactions!
                                      .map((Transaction transaction) {
                                      return Container(
                                        height: 75,
                                        child: TransactionTile(transaction),
                                      );
                                    }).toList(),
                            ),
                          );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
