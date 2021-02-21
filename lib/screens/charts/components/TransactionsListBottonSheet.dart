import 'package:flutter/material.dart';
import 'package:moedeiro/components/moedeiroWidgets.dart';
import 'package:moedeiro/models/transaction.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/screens/movements/components/transactionWidgets.dart';
import 'package:provider/provider.dart';

class TransactionsListBottomSheet extends StatelessWidget {
  final String categoryUuid;
  final String month;
  final String year;
  const TransactionsListBottomSheet(this.categoryUuid, this.month, this.year,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.9,
        initialChildSize: 0.6,
        builder: (BuildContext context, ScrollController scrollController) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5.0,
              vertical: 10.0,
            ),
            child: Consumer<TransactionModel>(
              builder:
                  (BuildContext context, TransactionModel model, Widget child) {
                var transactions =
                    model.transactions.where((Transaction value) {
                  return value.category == categoryUuid &&
                      DateTime.fromMillisecondsSinceEpoch(value.timestamp)
                              .month
                              .toString()
                              .padLeft(2, '0') ==
                          month &&
                      DateTime.fromMillisecondsSinceEpoch(value.timestamp)
                              .year
                              .toString() ==
                          year;
                }).toList();
                return CustomScrollView(
                    controller: scrollController,
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: NavigationPillWidget(),
                      ),
                      SliverFixedExtentList(
                        itemExtent: 80.0,
                        delegate: SliverChildListDelegate(transactions
                            .map((transaction) => TransactionTile(transaction))
                            .toList()),
                      )
                    ]);
              },
            ),
          );
        });
  }
}
