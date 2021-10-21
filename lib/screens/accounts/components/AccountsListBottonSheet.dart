import 'dart:io';

import 'package:flutter/material.dart';
import 'package:moedeiro/components/moedeiroWidgets.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/util/utils.dart';
import 'package:provider/provider.dart';

class AccountListBottomSheet extends StatelessWidget {
  const AccountListBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountModel>(
        builder: (BuildContext context, AccountModel model, Widget? child) {
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
                      itemExtent: 60,
                      shrinkWrap: true,
                      controller: scrollController,
                      itemCount: model.accounts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: model.accounts[index].icon != null
                                ? FileImage(File(model.accounts[index].icon!),
                                    scale: 0.9)
                                : null,
                            backgroundColor: Colors.transparent,
                            radius: 15,
                          ),
                          onTap: () {
                            Navigator.pop(context, model.accounts[index].uuid);
                          },
                          subtitle: Text(
                            formatCurrency(
                                context, model.accounts[index].amount!),
                          ),
                          title: Text(
                            model.accounts[index].name!,
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
