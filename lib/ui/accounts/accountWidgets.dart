import 'package:flutter/material.dart';
import 'package:moedeiro/dataModels/accounts.dart';
import 'package:moedeiro/models/mainModel.dart';
import 'package:moedeiro/ui/accounts/AccountsBottomSheetWidget.dart';
import 'package:moedeiro/ui/showBottomSheet.dart';
import 'package:provider/provider.dart';

class AccountCard extends StatefulWidget {
  Account account;
  AccountCard({Key key, this.account}) : super(key: key);

  @override
  _AccountCardState createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                          child: Text(widget.account.name,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).accentColor,
                                  fontSize: 14.0)),
                        ),
                        Align(
                          child: Icon(Icons.sanitizer),
                          alignment: Alignment.topRight,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${widget.account.amount}€',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ],
              ),
              padding: EdgeInsets.all(5.0),
            ),
          ),
          onLongPress: () {
            showCustomModalBottomSheet(
                context, AccountBottomSheet(widget.account));
          },
          onTap: () {
            Provider.of<AccountModel>(context, listen: false).setActiveAccount =
                widget.account.uuid;
            Navigator.pushNamed(
              context,
              '/accountTransactionsPage',
            );
          }),
      width: 120.0,
      height: 200.0,
    );
  }
}
