import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moneym/dataModels/accounts.dart';
import 'package:moneym/models/mainModel.dart';
import 'package:moneym/ui/AccountsBottomSheetWidget.dart';
import 'package:moneym/ui/TransactionBottomSheetWidget.dart';
import 'package:moneym/ui/TransferBottomSheetWidget.dart';
import 'package:provider/provider.dart';

class AccountDetailsPage extends StatefulWidget {
  @override
  AccountDetailsPageState createState() => AccountDetailsPageState();
}

class AccountDetailsPageState extends State<AccountDetailsPage> {
  Account activeAccount;
  @override
  void initState() {
    super.initState();
  }

  void _showTransactionCard() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (BuildContext context) {
          return TransactionBottomSheet();
        });
  }

  void _showAccountCard() {
    showModalBottomSheet(
        enableDrag: true,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (BuildContext context) {
          return AccountBottomSheet();
        });
  }

  void _showTranseferCard() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (BuildContext context) {
          return TransferBottomSheet();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, AccountModel model, Widget child) {
      return Scaffold(
        body: DefaultTabController(
          length: 2,
          child: CustomScrollView(slivers: <Widget>[
            SliverAppBar(
              title: Text(model.getActiveAccount.name),
              bottom: TabBar(tabs: [
                Tab(
                  text: 'Transacciones',
                ),
                Tab(
                  text: 'Transferencias',
                ),
              ]),
              floating: false,
              snap: false,
              pinned: true,
              actions: <Widget>[
                IconButton(
                  color: Colors.black,
                  icon: const Icon(Icons.edit),
                  tooltip: 'Cuenta',
                  onPressed: () {
                    _showAccountCard();
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        stops: [
                          0.1,
                          0.4,
                          0.7,
                          0.9
                        ],
                        colors: [
                          Colors.yellow,
                          Colors.red,
                          Colors.indigo,
                          Colors.teal
                        ]),
                  ),
                ),
              ),
              expandedHeight: 200,
            ),
            SliverFillRemaining(
              hasScrollBody: true,
              child: TabBarView(
                children: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if (index.isEven) {
                          return Text('...');
                        }
                        return Spacer();
                      },
                      semanticIndexCallback: (Widget widget, int localIndex) {
                        if (localIndex.isEven) {
                          return localIndex ~/ 2;
                        }
                        return null;
                      },
                      childCount: 10,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if (index.isEven) {
                          return Text('...');
                        }
                        return Spacer();
                      },
                      semanticIndexCallback: (Widget widget, int localIndex) {
                        if (localIndex.isEven) {
                          return localIndex ~/ 2;
                        }
                        return null;
                      },
                      childCount: 10,
                    ),
                  ),
                  // Scaffold(
                  //   body: ListView.builder(
                  //     itemCount: 1000,
                  //     itemBuilder: (BuildContext context, int index) {
                  //       return ListTile(
                  //         leading: Text('04/5/2020'),
                  //         title: Text('Item #$index'),
                  //         subtitle: Text('pel'),
                  //         trailing: Text('50.04€'),
                  //         onTap: () => {_showTransactionCard()},
                  //       );
                  //     },
                  //   ),
                  //   floatingActionButton: FloatingActionButton(
                  //     onPressed: () => {_showTransactionCard()},
                  //     child: Icon(Icons.add),
                  //   ),
                  // ),
                ],
              ),
            ),
          ]),
        ),
      );
    });
  }
}
