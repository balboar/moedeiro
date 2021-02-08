import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moedeiro/components/showBottomSheet.dart';
import 'package:moedeiro/models/transaction.dart';
import 'package:moedeiro/screens/movements/components/transactionBottomSheet.dart';
import 'package:moedeiro/util/utils.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final double accountBalance;
  const TransactionTile(this.transaction, {Key key, this.accountBalance})
      : super(key: key);

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
        margin: EdgeInsets.zero,
        color: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(transaction.categoryName ?? '',
                            style: Theme.of(context).textTheme.bodyText1),
                        Visibility(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            width: 1,
                            height: 15,
                            color: Colors.grey[500],
                          ),
                          visible: transaction.name.isNotEmpty,
                        ),
                        Text(transaction.name ?? '',
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.subtitle2),
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
                        // Text(transaction.accountName ?? '',
                        //     style: Theme.of(context).textTheme.subtitle1),
                        //     Text(
                        Text(
                            DateFormat.yMd().format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  transaction.timestamp),
                            ),
                            style: Theme.of(context).textTheme.subtitle2),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        formatCurrency(context, transaction.amount),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        accountBalance != null
                            ? formatCurrency(context, accountBalance)
                            : '',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              width: 5,
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
    );
  }
}
