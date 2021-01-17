import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moedeiro/dataModels/transaction.dart';
import 'package:moedeiro/ui/showBottomSheet.dart';
import 'package:moedeiro/ui/transactions/transactionBottomSheetWidget.dart';
import 'package:moedeiro/util/utils.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  const TransactionTile(this.transaction, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCustomModalBottomSheet(
          context,
          TransactionBottomSheet(transaction),
        );
      },
      child: Card(
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          transaction.categoryName ?? '',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .fontSize,
                              color:
                                  Theme.of(context).textTheme.subtitle1.color),
                        ),
                        Visibility(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            width: 1,
                            height: 15,
                            color: Colors.grey[500],
                          ),
                          visible: transaction.name.isNotEmpty,
                        ),
                        Text(
                          transaction.name ?? '',
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .fontSize,
                              color:
                                  Theme.of(context).textTheme.subtitle2.color),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 16,
                        ),
                        Container(
                          width: 10,
                        ),
                        Text(
                          transaction.accountName ?? '',
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .fontSize,
                              color:
                                  Theme.of(context).textTheme.subtitle1.color),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 110,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(formatCurrency(context, transaction.amount),
                          style: TextStyle(
                              fontSize: 18.0,
                              color: transaction.amount > 0
                                  ? Colors.green
                                  : Colors.red)),
                      Text(
                        DateFormat.yMd().format(
                          DateTime.fromMillisecondsSinceEpoch(
                              transaction.timestamp),
                        ),
                        style: TextStyle(
                            fontSize:
                                Theme.of(context).textTheme.subtitle2.fontSize,
                            color: Theme.of(context).textTheme.subtitle2.color),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    width: 7,
                    decoration: BoxDecoration(
                      color: transaction.amount > 0 ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
