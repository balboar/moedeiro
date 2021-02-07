import 'package:flutter/material.dart';
import 'package:moedeiro/components/showBottomSheet.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/screens/accounts/components/AccountsBottomSheetWidget.dart';
import 'package:moedeiro/screens/accounts/components/accountWidgets.dart';
import 'package:provider/provider.dart';
import 'package:moedeiro/generated/l10n.dart';

class AccountsPage extends StatefulWidget {
  AccountsPage({Key key}) : super(key: key);

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildAccountsList() {
    return Consumer<AccountModel>(
      builder: (BuildContext context, AccountModel model, Widget child) {
        if (model.accounts == null) {
          return CircularProgressIndicator();
        } else if (model.accounts.length == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50.0,
              ),
              Image(
                image: AssetImage('lib/assets/icons/not-found.png'),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                S.of(context).noDataLabel,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ],
          );
        } else {
          return ReorderableListView(
              children: model.accounts.map(
                (account) {
                  return AccountCard(
                    account: account,
                    key: Key(account.uuid),
                  );
                },
              ).toList(),
              onReorder: model.reorderAccounts);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).accountsTitle),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.reorder),
        //     onPressed: null,
        //   ),
        // ],
      ),
      key: _formKey,
      floatingActionButton: FloatingActionButton.extended(
        label: Text(S.of(context).account),
        onPressed: () {
          showCustomModalBottomSheet(context, AccountBottomSheet(null));
        },
        icon: Icon(Icons.add_outlined),
      ),
      body: _buildAccountsList(),
    );
  }
}