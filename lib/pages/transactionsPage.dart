import 'package:flutter/material.dart';
import 'package:moedeiro/dataModels/accounts.dart';
import 'package:moedeiro/models/mainModel.dart';
import 'package:moedeiro/ui/accounts/AccountsBottomSheetWidget.dart';
import 'package:moedeiro/ui/showBottomSheet.dart';
import 'package:moedeiro/ui/transactions/transactionsSliverList.dart';
import 'package:moedeiro/ui/MoneyMSliverAppBar.dart';
import 'package:moedeiro/ui/transactions/transfersSliverList.dart';
import 'package:provider/provider.dart';

class AccountTransactionsPage extends StatefulWidget {
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
          color: Colors.black,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _formKey,
      body: DefaultTabController(
        length: 2, // This is the number of tabs.
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              MoneyMSliverOverlapAbsorberAppBar(
                activeAccount != null ? activeAccount.name : 'Accounts',
                actions: buildActions(),
                tabs: buildTabs(),
              )
            ];
          },
          body: TabBarView(
              // These are the contents of the tab views, below the tabs.
              children: <Widget>[
                TransactionsSliverList(),
                TransfersSliverList(),
              ]),
        ),
      ),
    );
  }
}
