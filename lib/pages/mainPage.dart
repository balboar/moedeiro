import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:moedeiro/dataModels/transaction.dart';
import 'package:moedeiro/models/mainModel.dart';
import 'package:moedeiro/ui/accounts/accountWidgets.dart';
import 'package:moedeiro/ui/moedeiro_widgets.dart';
import 'package:moedeiro/ui/showBottomSheet.dart';
import 'package:moedeiro/ui/transactions/TransactionBottomSheetWidget.dart';
import 'package:moedeiro/ui/transactions/transactionWidgets.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  String _floatingButtonLabel = 'Transaction';
  @override
  void initState() {
    Provider.of<AccountModel>(context, listen: false).getAccounts();
    Provider.of<CategoryModel>(context, listen: false).getCategories();
    Provider.of<TransactionModel>(context, listen: false).getTransactions();
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
      // NOTE: This second action icon will only work on Android.
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showCustomModalBottomSheet(
                  context,
                  TransactionBottomSheet(Transaction(
                      timestamp: DateTime.now().millisecondsSinceEpoch)))
              .then((value) {
            Provider.of<AccountModel>(context, listen: false).getAccounts();
            Provider.of<CategoryModel>(context, listen: false).getCategories();
          });
        },
        label: Text(_floatingButtonLabel),
        icon: Icon(Icons.add_outlined),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.settings),
                    tooltip: 'Ajustes',
                    onPressed: () =>
                        Navigator.pushNamed(context, '/settingsPage'),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/accountsPage');
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.account_balance_wallet_outlined),
                        Divider(
                          indent: 10.0,
                        ),
                        Text(
                          'Accounts',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.arrow_forward),
                          ),
                        )
                      ],
                    ),
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  ),
                ),
              ),
              Consumer<AccountModel>(
                builder:
                    (BuildContext context, AccountModel model, Widget child) {
                  if (model.accounts == null)
                    return Container(
                      height: 100,
                      margin:
                          EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  else if (model.accounts.length == 0)
                    return Container(
                      height: 100,
                      margin:
                          EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
                      child: NoDataWidgetHorizontal(),
                    );
                  else
                    return Container(
                      height: 100,
                      margin:
                          EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
                      child: ListView.builder(
                        itemCount: model.accounts.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return AccountCard(account: model.accounts[index]);
                        },
                      ),
                    );
                },
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/categoriesPage');
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.category_outlined),
                        Divider(
                          indent: 10.0,
                        ),
                        Text(
                          'Expenses by category',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.arrow_forward),
                          ),
                        )
                      ],
                    ),
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  ),
                ),
              ),
              Consumer<CategoryModel>(
                builder:
                    (BuildContext context, CategoryModel model, Widget child) {
                  if (model.top5Categories == null)
                    return Container(
                      height: 100,
                      margin:
                          EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  else if (model.top5Categories.length == 0)
                    return Container(
                      height: 100,
                      margin:
                          EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
                      child: NoDataWidgetHorizontal(),
                    );
                  else
                    return Container(
                      margin: EdgeInsets.only(left: 20.0),
                      child: Column(
                        children: model.top5Categories
                            .map((Map<String, dynamic> cat) {
                          return ListTile(
                            dense: true,
                            leading: Icon(Icons.ac_unit),
                            title: Text(
                              cat['name'],
                              style: TextStyle(fontSize: 17),
                            ),
                            trailing: Text(cat['amount'].toString() + '€'),
                          );
                        }).toList(),
                      ),
                    );
                },
              ),
              GestureDetector(
                onTap: () {
                  Provider.of<AccountModel>(context, listen: false)
                      .setActiveAccountNull();
                  Navigator.pushNamed(context, '/accountTransactionsPage');
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.receipt_long_outlined),
                        Divider(
                          indent: 10.0,
                        ),
                        Text(
                          'Recent transactions',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.arrow_forward),
                          ),
                        )
                      ],
                    ),
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  ),
                ),
              ),
              Consumer<TransactionModel>(
                builder: (BuildContext context, TransactionModel model,
                    Widget child) {
                  if (model.transactions == null)
                    return Container(
                      height: 100,
                      margin:
                          EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  else if (model.transactions.length == 0)
                    return Container(
                      height: 100,
                      margin:
                          EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
                      child: NoDataWidgetHorizontal(),
                    );
                  else
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        children: model.transactions.length > 3
                            ? model.transactions
                                .sublist(0, 3)
                                .map((Transaction transaction) {
                                return Container(
                                  height: 80,
                                  child: TransactionTile(transaction),
                                );
                              }).toList()
                            : model.transactions.map((Transaction transaction) {
                                return Container(
                                  height: 80,
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
    );
  }
}
