

import 'package:flutter/material.dart';
import 'package:moedeiro/components/moedeiroWidgets.dart';
import 'package:moedeiro/models/transaction.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/screens/movements/components/transactionWidgets.dart';
import 'package:provider/provider.dart';

class TransactionsSliverList extends StatefulWidget {
  TransactionsSliverList({Key? key}) : super(key: key);

  @override
  _TransactionsSliverListState createState() => _TransactionsSliverListState();
}

class _TransactionsSliverListState extends State<TransactionsSliverList> {
  Widget _buildList() {
    return Consumer<TransactionModel>(
      builder: (BuildContext context, TransactionModel model, Widget? child) {
        if (model.transactions == null) {
          return CircularProgressIndicator();
        } else if (model.transactions!.length == 0) {
          return SliverToBoxAdapter(
            child: NoDataWidgetVertical(),
          );
        } else {
          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 2,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                Transaction _transaction = model.transactions![index];
                return TransactionTile(_transaction);
              },
              childCount: model.transactions!.length,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return CustomScrollView(
          key: PageStorageKey<String>('Transactions'),
          slivers: <Widget>[
            SliverOverlapInjector(
              // This is the flip side of the SliverOverlapAbsorber above.
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverPadding(
              padding: EdgeInsets.all(8.0),
              sliver: _buildList(),
            ),
          ],
        );
      },
    );
  }
}
