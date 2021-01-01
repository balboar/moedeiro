import 'package:flutter/material.dart';
import 'package:moedeiro/dataModels/transaction.dart';
import 'package:moedeiro/models/mainModel.dart';
import 'package:moedeiro/ui/moedeiro_widgets.dart';
import 'package:moedeiro/ui/showBottomSheet.dart';
import 'package:moedeiro/ui/transactions/TransactionBottomSheetWidget.dart';
import 'package:provider/provider.dart';

class TransactionsSliverList extends StatefulWidget {
  TransactionsSliverList({Key key}) : super(key: key);

  @override
  _TransactionsSliverListState createState() => _TransactionsSliverListState();
}

class _TransactionsSliverListState extends State<TransactionsSliverList> {
  Widget _buildList() {
    return Consumer<TransactionModel>(
      builder: (BuildContext context, TransactionModel model, Widget child) {
        if (model.transactions == null) {
          return CircularProgressIndicator();
        } else if (model.transactions.length == 0) {
          return SliverToBoxAdapter(
            child: NoDataWidgetVertical(),
          );
        } else {
          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                Transaction _transaction = model.transactions[index];
                return ListTile(
                  onTap: () {
                    showCustomModalBottomSheet(
                        context, TransactionBottomSheet(_transaction));
                  },
                  title: Text(
                    _transaction.name,
                  ),
                  trailing: Text(
                    _transaction.amount.toString(),
                  ),
                );
              },
              childCount: model.transactions.length,
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
