import 'package:flutter/material.dart';
import 'package:moedeiro/models/mainModel.dart';
import 'package:moedeiro/ui/moedeiro_widgets.dart';
import 'package:provider/provider.dart';

class AccountListBottomSheet extends StatelessWidget {
  const AccountListBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountModel>(
        builder: (BuildContext context, AccountModel model, Widget child) {
      return DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.9,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: ListView(children: <Widget>[
              NavigationPillWidget(),
              SizedBox(
                height: 10,
              ),
              model.accounts.length == 0
                  ? Center(
                      child: NoDataWidgetVertical(),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      controller: scrollController,
                      itemCount: model.accounts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          onTap: () {
                            Navigator.pop(context, model.accounts[index].uuid);
                          },
                          title: Text(
                            model.accounts[index].name,
                          ),
                        );
                      },
                    ),
            ]),
          );
        },
      );
    });
  }
}
