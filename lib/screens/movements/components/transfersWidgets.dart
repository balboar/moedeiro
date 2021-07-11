import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moedeiro/components/showBottomSheet.dart';
import 'package:moedeiro/models/transfer.dart';
import 'package:moedeiro/screens/movements/components/transferBottomSheetWidget.dart';
import 'package:moedeiro/util/utils.dart';

class TransferTile extends StatelessWidget {
  final Transfer transfer;
  final String? activeAccount;
  const TransferTile(this.transfer, {Key? key, this.activeAccount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCustomModalBottomSheet(
          context,
          TransferBottomSheet(transfer),
        );
      },
      child: Card(
        margin: EdgeInsets.zero,
        color: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(children: [
                      Icon(
                        Icons.account_balance_wallet,
                        color: Colors.red,
                        size: 16,
                      ),
                      Container(
                        width: 5,
                      ),
                      Text(transfer.accountFromName ?? '',
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.subtitle1),
                    ]),
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          color: Colors.green,
                          size: 16,
                        ),
                        Container(
                          width: 5,
                        ),
                        Text(transfer.accountToName ?? '',
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.subtitle1),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        formatCurrency(
                            context,
                            (activeAccount != null) &&
                                    (activeAccount == transfer.accountFrom)
                                ? transfer.amount! * -1
                                : transfer.amount!),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                          DateFormat.yMd().format(
                            DateTime.fromMillisecondsSinceEpoch(
                                transfer.timestamp!),
                          ),
                          style: Theme.of(context).textTheme.subtitle2),
                    ],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    width: 2.5,
                    decoration: BoxDecoration(
                      color: (activeAccount != null) &&
                              (activeAccount == transfer.accountFrom)
                          ? Colors.red
                          : Colors.green,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(2),
                        topRight: Radius.circular(2),
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
