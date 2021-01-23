import 'package:flutter/material.dart';
import 'package:moedeiro/dataModels/accounts.dart';
import 'package:moedeiro/dataModels/transaction.dart';
import 'package:moedeiro/dataModels/transfer.dart';
import 'package:moedeiro/models/mainModel.dart';
import 'package:moedeiro/ui/accounts/accountWidgets.dart';
import 'package:moedeiro/ui/moedeiroSliverList.dart';
import 'package:moedeiro/ui/accounts/AccountsBottomSheetWidget.dart';
import 'package:moedeiro/ui/moedeiroWidgets.dart';
import 'package:moedeiro/ui/showBottomSheet.dart';
import 'package:moedeiro/ui/transactions/transactionWidgets.dart';
import 'package:moedeiro/ui/moedeiroSliverAppBar.dart';
import 'package:moedeiro/ui/transfers/transfersWidgets.dart';
import 'package:provider/provider.dart';

class AccountTransactionsPage extends StatefulWidget {
  bool showAllTransactions = true;
  AccountTransactionsPage({this.showAllTransactions});
  @override
  AccountTransactionsPageState createState() => AccountTransactionsPageState();
}

class AccountTransactionsPageState extends State<AccountTransactionsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Account activeAccount;
  @override
  void initState() {
    activeAccount =
        Provider.of<AccountModel>(context, listen: false).getActiveAccount;
    super.initState();
  }

  List<Widget> buildActions() {
    if (activeAccount == null)
      return null;
    else
      return <Widget>[
        IconButton(
          color: Colors.white,
          icon: const Icon(Icons.edit),
          tooltip: 'Cuenta',
          onPressed: () {
            showCustomModalBottomSheet(
                context, AccountBottomSheet(activeAccount));
          },
        ),
      ].toList();
  }

  PreferredSizeWidget buildTabs() {
    return TabBar(tabs: [
      Tab(
        text: 'Transactions',
      ),
      Tab(
        text: 'Transfers',
      ),
    ]);
  }

  Widget buildTransactionsList() {
    return Consumer<TransactionModel>(
        builder: (BuildContext context, TransactionModel model, Widget child) {
      if (widget.showAllTransactions) {
        return model.transactions.length == 0
            ? SliverToBoxAdapter(
                child: NoDataWidgetVertical(),
              )
            : SliverFixedExtentList(
                itemExtent: 80.0,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    Transaction _transaction = model.transactions[index];
                    return TransactionTile(_transaction);
                  },
                  childCount: model.transactions.length,
                ),
              );
      } else {
        List<Transaction> accountTransactions =
            model.getAccountTransactions(activeAccount.uuid);
        return accountTransactions.length == 0
            ? SliverToBoxAdapter(
                child: NoDataWidgetVertical(),
              )
            : SliverFixedExtentList(
                itemExtent: 80.0,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    Transaction _transaction = accountTransactions[index];
                    return TransactionTile(_transaction);
                  },
                  childCount: accountTransactions.length,
                ),
              );
      }
    });
  }

  Widget buildTransfersList() {
    return Consumer<TransfersModel>(
        builder: (BuildContext context, TransfersModel model, Widget child) {
      if (widget.showAllTransactions) {
        return model.transfers.length == 0
            ? SliverToBoxAdapter(
                child: NoDataWidgetVertical(),
              )
            : SliverFixedExtentList(
                itemExtent: 80.0,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    Transfer transfer = model.transfers[index];
                    return TransferTile(transfer);
                  },
                  childCount: model.transfers.length,
                ),
              );
      } else {
        List<Transfer> accountTransfers =
            model.getAccountTransfers(activeAccount.uuid);
        return accountTransfers.length == 0
            ? SliverToBoxAdapter(
                child: NoDataWidgetVertical(),
              )
            : SliverFixedExtentList(
                itemExtent: 80.0,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    Transfer transfer = accountTransfers[index];
                    return TransferTile(
                      transfer,
                      activeAccount: activeAccount.uuid,
                    );
                  },
                  childCount: accountTransfers.length,
                ),
              );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _formKey,
      body: DefaultTabController(
        length: 2, // This is the number of tabs.
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              activeAccount != null
                  ? AccountPageAppBar(
                      activeAccount,
                      actions: buildActions(),
                      tabs: buildTabs(),
                    )
                  : MoedeiroSliverOverlapAbsorberAppBar(
                      'Movements',
                      actions: buildActions(),
                      tabs: buildTabs(),
                    )
            ];
          },
          body: TabBarView(
              // These are the contents of the tab views, below the tabs.
              children: <Widget>[
                MoedeiroSliverList('Transactions', buildTransactionsList()),
                MoedeiroSliverList('Transfers', buildTransfersList()),
              ]),
        ),
      ),
    );
  }
}
