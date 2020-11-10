import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moneym/dataModels/accounts.dart';
import 'package:moneym/models/mainModel.dart';
import 'package:moneym/ui/AccountsBottomSheetWidget.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  void initState() {
    Provider.of<AccountModel>(context, listen: false).getAccounts();
    super.initState();
  }

  void _showAccountCard() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (BuildContext context) {
          return AccountBottomSheet();
        });
  }

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
                    '1.000€',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ],
              ),
              padding: EdgeInsets.all(5.0),
            ),
          ),
          onTap: () {
            Provider.of<AccountModel>(context, listen: false).setActiveAccount =
                account.uuid;
            Navigator.pushNamed(
              context,
              '/accountDetailsPage',
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

  Widget _buildAccountsList(AccountModel model) {
    if (model.accounts == null) {
      return SliverList(
        delegate: SliverChildListDelegate(
          [
            Container(
              margin: EdgeInsets.symmetric(vertical: 100.0),
              alignment: Alignment.center,
              child: Text(
                'Sin datos',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            )
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
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountModel>(
        builder: (BuildContext context, AccountModel model, Widget child) {
      return Scaffold(
        body: CustomScrollView(
          primary: false,
          slivers: <Widget>[
            SliverAppBar(
                floating: false,
                pinned: true,
                snap: false,
                //  backgroundColor: Colors.teal,
                expandedHeight: 200.0,
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
                  title: Text('Cuentas'),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.black),
                    tooltip: 'Add',
                    onPressed: () {
                      _showAccountCard();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.black),
                    tooltip: 'Ajustes',
                    onPressed: () {},
                  ),
                ]),
            _buildAccountsList(model),
          ],
        ),
      );
    });
  }
}
