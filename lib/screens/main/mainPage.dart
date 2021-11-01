import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:moedeiro/components/moedeiroWidgets.dart';
import 'package:moedeiro/components/showBottomSheet.dart';
import 'package:moedeiro/models/settings.dart';
import 'package:moedeiro/models/transaction.dart';
import 'package:moedeiro/models/transfer.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/screens/main/components/lastTransactionsList.dart';
import 'package:moedeiro/screens/movements/components/transactionBottomSheet.dart';
import 'package:moedeiro/screens/movements/components/transactionTransferBottomSheetWidget.dart';
import 'package:moedeiro/screens/movements/components/transferBottomSheetWidget.dart';
import 'package:moedeiro/util/utils.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:moedeiro/generated/l10n.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> with WidgetsBindingObserver {
  late bool lockScreen;
  bool? useBiometrics;
  String? pin;
  bool _visible = true;
  final QuickActions quickActions = QuickActions();
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    init();
    Provider.of<AccountModel>(context, listen: false).getAccounts();
    Provider.of<CategoryModel>(context, listen: false).getCategories();
    Provider.of<TransactionModel>(context, listen: false).getTransactions();
    Provider.of<TransfersModel>(context, listen: false).getTransfers();
    Provider.of<RecurrenceModel>(context, listen: false)
        .getRecurrences()
        .then((value) {
      var _recurrences =
          Provider.of<RecurrenceModel>(context, listen: false).recurrences;
      var _pendingRecurrences = _recurrences!.where((element) {
        return element.nextEvent! < DateTime.now().millisecondsSinceEpoch;
      }).toList();

      if (_pendingRecurrences.length > 0) {
        _pendingRecurrences.forEach((element) {
          Provider.of<TransactionModel>(context, listen: false)
              .insertTransactiontIntoDb(Transaction(
                  account: element.account,
                  accountName: element.accountName,
                  amount: element.amount,
                  category: element.category,
                  categoryName: element.category,
                  name: element.name,
                  timestamp: DateTime.now().millisecondsSinceEpoch));
          element.nextEvent =
              Provider.of<RecurrenceModel>(context, listen: false)
                  .computeNextEvent(element);
          Provider.of<RecurrenceModel>(context, listen: false)
              .insertRecurrenceIntoDb(element);
        });
      }
    });
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

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
    handleScroll();
  }

  void init() async {
    lockScreen = Provider.of<SettingsModel>(context, listen: false).lockScreen;

    useBiometrics =
        Provider.of<SettingsModel>(context, listen: false).useBiometrics;
    pin = Provider.of<SettingsModel>(context, listen: false).pin;

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
    _scrollController.removeListener(() {});
    super.dispose();
  }

  void showFloationButton() {
    setState(() {
      _visible = true;
    });
  }

  void hideFloationButton() {
    setState(() {
      _visible = false;
    });
  }

  void handleScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        hideFloationButton();
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        showFloationButton();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        statusBarIconBrightness:
            Provider.of<SettingsModel>(context, listen: false).themeMode ==
                    ThemeMode.dark
                ? Brightness.light
                : Brightness.dark,
        systemNavigationBarIconBrightness:
            Provider.of<SettingsModel>(context, listen: false).themeMode ==
                    ThemeMode.dark
                ? Brightness.light
                : Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 300),
          child: FloatingActionButton(
            onPressed: () {
              showCustomModalBottomSheet(
                context,
                TransactionTransferBottomSheet(),
              );
            },
            child: Icon(Icons.add_outlined),
          ),
        ),
        body: SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                actions: [
                  //   IconButton(
                  //     icon: const Icon(Icons.settings_outlined),
                  //     tooltip: S.of(context).settings,
                  //     padding: EdgeInsets.symmetric(vertical: 22, horizontal: 10),
                  //     iconSize: 30,
                  //     onPressed: () =>
                  //         Navigator.pushNamed(context, '/settingsPage'),
                  //   ),
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
                            '${formatCurrency(context, model.totalAmount)}',
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
                    Consumer<AccountModel>(builder: (BuildContext context,
                        AccountModel model, Widget? child) {
                      //formatCurrency(context, model.expenses)
                      return MainPageSectionStateless(
                        S.of(context).expensesMonth,
                        () {
                          Navigator.pushNamed(
                            context,
                            '/analyticsPage',
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
                      S.of(context).recurrences,
                      () {
                        Navigator.pushNamed(
                          context,
                          '/recurrencesPage',
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
                    LastTransactionsWidget(),
                    MainPageSectionStateless(
                      S.of(context).settings,
                      () {
                        Navigator.pushNamed(context, '/settingsPage',
                            arguments: true);
                      },
                      padding: EdgeInsets.only(
                          left: 20.0, right: 10.0, top: 20.0, bottom: 0.0),
                    ),
                    SizedBox(
                      height: 100,
                    )
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
