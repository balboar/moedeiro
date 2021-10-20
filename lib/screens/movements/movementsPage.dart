import 'package:flutter/material.dart';
import 'package:moedeiro/components/moedeiroSliverAppBar.dart';
import 'package:moedeiro/components/moedeiroSliverList.dart';
import 'package:moedeiro/components/showBottomSheet.dart';
import 'package:moedeiro/models/accounts.dart';
import 'package:moedeiro/models/transaction.dart';
import 'package:moedeiro/models/transfer.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/screens/accounts/components/AccountsBottomSheetWidget.dart';
import 'package:moedeiro/screens/accounts/components/accountWidgets.dart';
import 'package:moedeiro/screens/movements/components/transactionWidgets.dart';
import 'package:moedeiro/screens/movements/components/transfersWidgets.dart';
import 'package:provider/provider.dart';
import 'package:moedeiro/generated/l10n.dart';
import 'package:moedeiro/screens/movements/components/searchDelegate.dart';

import 'components/pieChart.dart';

class AccountTransactionsPage extends StatefulWidget {
  final bool? showAllTransactions;
  AccountTransactionsPage({this.showAllTransactions});
  @override
  AccountTransactionsPageState createState() => AccountTransactionsPageState();
}

class AccountTransactionsPageState extends State<AccountTransactionsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controller = PageController(viewportFraction: 1);

  Account? activeAccount;
  @override
  void initState() {
    activeAccount =
        Provider.of<AccountModel>(context, listen: false).getActiveAccount;
    super.initState();
  }

  List<Widget>? buildActions() {
    if (activeAccount == null)
      return <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: MovementsSearchDelegate(),
            );
          },
        ),
      ];
    else
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.edit),
          tooltip: S.of(context).account,
          onPressed: () {
            showCustomModalBottomSheet(
                context, AccountBottomSheet(activeAccount));
          },
        ),
      ].toList();
  }

  Widget buildTabs() {
    return TabBar(
      tabs: [
        Tab(
          child: Text(
            S.of(context).transactions,
            overflow: TextOverflow.clip,
            maxLines: 1,
          ),
        ),
        Tab(
          child: Text(
            S.of(context).transfers,
            overflow: TextOverflow.clip,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget buildTransactionsList() {
    return Consumer<TransactionModel>(
        builder: (BuildContext context, TransactionModel model, Widget? child) {
      if (widget.showAllTransactions ?? true) {
        return model.transactions!.length == 0
            ? SliverToBoxAdapter(
                child: Container(),
              )
            : SliverFixedExtentList(
                itemExtent: 80.0,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    Transaction _transaction = model.transactions![index];
                    return TransactionTile(_transaction);
                  },
                  childCount: model.transactions!.length,
                ),
              );
      } else {
        List<Transaction> accountTransactions =
            model.getAccountTransactions(activeAccount!.uuid);
        return accountTransactions.length == 0
            ? SliverToBoxAdapter(
                child: Container(),
              )
            : SliverFixedExtentList(
                itemExtent: 80.0,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    Transaction _transaction = accountTransactions[index];
                    return TransactionTile(
                      _transaction,
                      accountBalance: 0,
                    );
                  },
                  childCount: accountTransactions.length,
                ),
              );
      }
    });
  }

  Widget buildTransfersList() {
    return Consumer<TransfersModel>(
        builder: (BuildContext context, TransfersModel model, Widget? child) {
      if (widget.showAllTransactions ?? true) {
        return model.transfers!.length == 0
            ? SliverToBoxAdapter(
                child: Container(),
              )
            : SliverFixedExtentList(
                itemExtent: 80.0,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    Transfer transfer = model.transfers![index];
                    return TransferTile(transfer);
                  },
                  childCount: model.transfers!.length,
                ),
              );
      } else {
        List<Transfer> accountTransfers =
            model.getAccountTransfers(activeAccount!.uuid!);
        return accountTransfers.length == 0
            ? SliverToBoxAdapter(
                child: Container(),
              )
            : SliverFixedExtentList(
                itemExtent: 80.0,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    Transfer transfer = accountTransfers[index];
                    return TransferTile(
                      transfer,
                      activeAccount: activeAccount!.uuid,
                    );
                  },
                  childCount: accountTransfers.length,
                ),
              );
      }
    });
  }

  Widget flexibleSpace() {
    return FlexibleSpaceBar(
      stretchModes: [StretchMode.blurBackground],
      collapseMode: CollapseMode.pin,
      background: Column(
        children: [
          Container(
            height: kToolbarHeight,
          ),
          Container(
            child: MPieChart(),
            margin:
                EdgeInsets.only(left: 0.0, right: 0, top: 10.0, bottom: 0.0),
          ),
        ],
      ),
    );
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
                      S.of(context).movementsTitle,
                      actions: buildActions(),
                      flexibleSpace: flexibleSpace(),
                      tabs: buildTabs(),
                    )
            ];
          },
          body: TabBarView(
              // These are the contents of the tab views, below the tabs.
              children: <Widget>[
                MoedeiroSliverList(
                    S.of(context).transactions, buildTransactionsList()),
                MoedeiroSliverList(
                    S.of(context).transfers, buildTransfersList()),
              ]),
        ),
      ),
    );
  }
}
