import 'package:flutter/material.dart';
import 'package:moedeiro/components/showBottomSheet.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/screens/accounts/components/AccountsBottomSheetWidget.dart';
import 'package:moedeiro/screens/accounts/components/accountWidgets.dart';
import 'package:provider/provider.dart';
import 'package:moedeiro/generated/l10n.dart';

class AccountsPage extends StatefulWidget {
  AccountsPage({Key? key}) : super(key: key);

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controller = PageController(viewportFraction: 1);

  Widget _buildAccountsList() {
    return Consumer<AccountModel>(
      builder: (BuildContext context, AccountModel model, Widget? child) {
        if (model.accounts.length == 0) {
          return SliverToBoxAdapter(
            child: Column(
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
            ),
          );
        } else {
          return SliverReorderableList(
              itemBuilder: (BuildContext context, int index) {
                return AccountCard(
                  account: model.accounts[index],
                  key: Key(model.accounts[index].uuid!),
                );
              },
              itemCount: model.accounts.length,
              onReorder: model.reorderAccounts);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(S.of(context).accountsTitle),
            ),
            floating: false,
            snap: false,
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.30,
          ),
          _buildAccountsList(),
        ],
      ),
      key: _formKey,
      floatingActionButton: FloatingActionButton.extended(
        label: Text(S.of(context).account),
        onPressed: () {
          showCustomModalBottomSheet(context, AccountBottomSheet(null),
              enableDrag: false);
        },
        icon: Icon(Icons.add_outlined),
      ),
    );
  }
}
