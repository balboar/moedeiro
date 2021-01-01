import 'package:flutter/material.dart';
import 'package:moedeiro/dataModels/accounts.dart';
import 'package:moedeiro/models/mainModel.dart';
import 'package:moedeiro/ui/MoneyMSliverAppBar.dart';
import 'package:moedeiro/ui/accounts/AccountsBottomSheetWidget.dart';
import 'package:moedeiro/ui/showBottomSheet.dart';
import 'package:provider/provider.dart';

class AccountsPage extends StatefulWidget {
  AccountsPage({Key key}) : super(key: key);

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget buildCard(
      BuildContext context, Account account, Color color, IconData icon) {
    return Container(
      child: GestureDetector(
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            color: Theme.of(context).backgroundColor,
            child: Padding(
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(account.name,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).textSelectionColor,
                                  fontSize: 14.0)),
                        ),
                        Align(
                          child: Icon(icon),
                          alignment: Alignment.topRight,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${account.initialAmount}€',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ],
              ),
              padding: EdgeInsets.all(5.0),
            ),
          ),
          onLongPress: () {
            showCustomModalBottomSheet(context, AccountBottomSheet(account));
          },
          onTap: () {
            Provider.of<AccountModel>(context, listen: false).setActiveAccount =
                account.uuid;
            Navigator.pushNamed(
              context,
              '/accountTransactionsPage',
            );
          }),
      width: 120.0,
      height: 200.0,
    );
  }

  Widget buildCardNewAccount(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 2.0,
              color: Colors.lightBlue.shade50,
            ),
            borderRadius: BorderRadius.circular(10.0)),
        color: Theme.of(context).backgroundColor,
        child: Align(
          child: Icon(
            Icons.add,
            size: 60.0,
          ),
          alignment: Alignment.center,
        ),
      ),
    );
  }

  Widget _buildAccountsList() {
    return Consumer<AccountModel>(
      builder: (BuildContext context, AccountModel model, Widget child) {
        if (model.accounts == null) {
          return CircularProgressIndicator();
        } else if (model.accounts.length == 0) {
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
                  'No data',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        } else {
          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                Account _account = model.accounts[index];
                return buildCard(
                    context, _account, Colors.red, Icons.monetization_on);
              },
              childCount: model.accounts.length,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _formKey,
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Account'),
        onPressed: () {
          showCustomModalBottomSheet(context, AccountBottomSheet(null));
        },
        icon: Icon(Icons.add_outlined),
      ),
      body: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          MoneyMSliverAppBar(
            'Accounts',
          ),
          _buildAccountsList(),
        ],
      ),
    );
  }
}
