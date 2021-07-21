import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moedeiro/components/showBottomSheet.dart';
import 'package:moedeiro/models/transaction.dart';
import 'package:moedeiro/screens/movements/components/transactionBottomSheet.dart';
import 'package:moedeiro/util/utils.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final double? accountBalance;
  const TransactionTile(this.transaction, {Key? key, this.accountBalance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCustomModalBottomSheet(
          context,
          TransactionBottomSheet(transaction),
          isScrollControlled: true,
        );
      },
      child: Card(
        margin: EdgeInsets.zero,
        color: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              width: 2.5,
              decoration: BoxDecoration(
                color: transaction.amount! > 0 ? Colors.green : Colors.red,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(2),
                  topLeft: Radius.circular(2),
                ),
              ),
            ),
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
                          visible: transaction.name!.isNotEmpty,
                        ),
                        Flexible(
                          child: Text(
                            transaction.name ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
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
                        Text(transaction.accountName ?? '',
                            style: Theme.of(context).textTheme.subtitle1),
                        //     Text(
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
                        formatCurrency(context, transaction.amount!),
                        style:
                            // Theme.of(context).textTheme.bodyText1.copyWith(

                            //       color: transaction.amount > 0
                            //           ? Colors.green.withOpacity(0.9)
                            //           : Colors.red.withOpacity(0.9),
                            //     ),
                            Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                          DateFormat.yMd().format(
                            DateTime.fromMillisecondsSinceEpoch(
                                transaction.timestamp!),
                          ),
                          style: Theme.of(context).textTheme.subtitle2),
                      // Text(
                      //   accountBalance != null
                      //       ? formatCurrency(context, accountBalance)
                      //       : '',
                      //   style: Theme.of(context).textTheme.subtitle2,
                      // ),
                    ],
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
