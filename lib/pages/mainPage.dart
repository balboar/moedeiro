import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moedeiro/dataModels/theme.dart';
import 'package:moedeiro/dataModels/transaction.dart';
import 'package:moedeiro/dataModels/transfer.dart';
import 'package:moedeiro/models/mainModel.dart';
import 'package:moedeiro/ui/accounts/accountWidgets.dart';
import 'package:moedeiro/ui/moedeiroWidgets.dart';
import 'package:moedeiro/ui/showBottomSheet.dart';
import 'package:moedeiro/ui/transactionTransferBottomSheetWidget.dart';
import 'package:moedeiro/ui/transactions/transactionBottomSheetWidget.dart';
import 'package:moedeiro/ui/transactions/transactionWidgets.dart';
import 'package:moedeiro/ui/transfers/transferBottomSheetWidget.dart';
import 'package:moedeiro/ui/widgets/moedeiroWidgets.dart';
import 'package:moedeiro/util/utils.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:moedeiro/generated/l10n.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  void initState() {
    Provider.of<AccountModel>(context, listen: false).getAccounts();
    Provider.of<CategoryModel>(context, listen: false).getCategories();
    Provider.of<TransactionModel>(context, listen: false).getTransactions();
    Provider.of<TransfersModel>(context, listen: false).getTransfers();
    super.initState();

    final QuickActions quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      // AppLock.of(context).showLockScreen();
      if (shortcutType == 'transaction') {
        showCustomModalBottomSheet(
                context,
                TransactionBottomSheet(Transaction(
                    timestamp: DateTime.now().millisecondsSinceEpoch)))
            .then((value) {
          Provider.of<AccountModel>(context, listen: false).getAccounts();
          Provider.of<CategoryModel>(context, listen: false).getCategories();
        });
      } else if (shortcutType == 'transfer') {
        showCustomModalBottomSheet(
                context,
                TransferBottomSheet(
                    Transfer(timestamp: DateTime.now().millisecondsSinceEpoch)))
            .then((value) {
          Provider.of<AccountModel>(context, listen: false).getAccounts();
          Provider.of<CategoryModel>(context, listen: false).getCategories();
        });
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

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor:
            WidgetsBinding.instance.window.platformBrightness == Brightness.dark
                ? Colors.white
                : Colors.black,
        statusBarIconBrightness:
            WidgetsBinding.instance.window.platformBrightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
        systemNavigationBarIconBrightness:
            WidgetsBinding.instance.window.platformBrightness == Brightness.dark
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
            ).then((value) {
              Provider.of<AccountModel>(context, listen: false).getAccounts();
              Provider.of<CategoryModel>(context, listen: false)
                  .getCategories();
            });
          },
          child: Icon(Icons.add_outlined),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/accountsPage',
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).balance,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              Consumer<AccountModel>(builder:
                                  (BuildContext context, AccountModel model,
                                      Widget child) {
                                return Text(
                                  '${formatCurrency(context, model.totalAmount)}',
                                  style: Theme.of(context).textTheme.headline4,
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings),
                        tooltip: S.of(context).settings,
                        onPressed: () =>
                            Navigator.pushNamed(context, '/settingsPage'),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.only(
                    left: 20.0,
                    right: 10.0,
                    top: 15.0,
                    bottom: 10.0,
                  ),
                ),
                Consumer<AccountModel>(
                  builder:
                      (BuildContext context, AccountModel model, Widget child) {
                    if (model.accounts == null)
                      return Container(
                        height: 100,
                        margin:
                            EdgeInsets.only(left: 10.0, top: 2.0, bottom: 10.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    else if (model.accounts.length == 0)
                      return Container(
                        height: 100,
                        margin:
                            EdgeInsets.only(left: 10.0, top: 2.0, bottom: 10.0),
                        child: NoDataWidgetHorizontal(),
                      );
                    else
                      return Container(
                        height: 100,
                        margin:
                            EdgeInsets.only(left: 10.0, top: 2.0, bottom: 10.0),
                        child: ListView.builder(
                          itemCount: model.accounts.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return AccountMiniCard(
                                account: model.accounts[index]);
                          },
                        ),
                      );
                  },
                ),
                Padding(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/chartsPage',
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).expensesMonth,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              Consumer<AccountModel>(builder:
                                  (BuildContext context, AccountModel model,
                                      Widget child) {
                                return Text(
                                  '${formatCurrency(context, model.totalAmount)}',
                                  style: Theme.of(context).textTheme.bodyText1,
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.only(
                    left: 20.0,
                    right: 10.0,
                    top: 15.0,
                    bottom: 15.0,
                  ),
                ),
                Container(
                  height: 85,
                  margin: EdgeInsets.only(left: 10.0, top: 10.0),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      OptionsCard(
                        Icons.dashboard_outlined,
                        Colors.green,
                        () {
                          Navigator.pushNamed(context, '/categoriesPage');
                        },
                        S.of(context).categoryTitle,
                      ),
                      OptionsCard(
                        Icons.receipt_outlined,
                        Colors.blue,
                        () {},
                        S.of(context).budgetsTitle,
                      ),
                    ],
                  ),
                ),
                MainPageSectionStateless(
                  S.of(context).transactionsTitle,
                  () {
                    Provider.of<AccountModel>(context, listen: false)
                        .setActiveAccountNull();
                    Navigator.pushNamed(context, '/accountTransactionsPage',
                        arguments: true);
                  },
                  Icons.receipt_long_outlined,
                ),
                Consumer<TransactionModel>(
                  builder: (BuildContext context, TransactionModel model,
                      Widget child) {
                    if (model.transactions == null)
                      return Container(
                        height: 100,
                        margin: EdgeInsets.only(
                            left: 10.0, right: 10, top: 2.0, bottom: 10.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    else if (model.transactions.length == 0)
                      return Container(
                        height: 100,
                        margin: EdgeInsets.only(
                            left: 10.0, right: 10, top: 2.0, bottom: 10.0),
                        child: NoDataWidgetHorizontal(),
                      );
                    else
                      return Container(
                        margin: EdgeInsets.only(
                            left: 10.0, right: 10, top: 2.0, bottom: 10.0),
                        child: Column(
                          children: model.transactions.length > 5
                              ? model.transactions
                                  .sublist(0, 5)
                                  .map((Transaction transaction) {
                                  return Container(
                                    height: 75,
                                    child: TransactionTile(transaction),
                                  );
                                }).toList()
                              : model.transactions
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
        ),
      ),
    );
  }
}
