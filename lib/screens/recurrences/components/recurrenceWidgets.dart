import 'package:flutter/material.dart';
import 'package:moedeiro/components/dialogs/confirmDeleteDialog.dart';
import 'package:moedeiro/components/showBottomSheet.dart';
import 'package:moedeiro/generated/l10n.dart';
import 'package:moedeiro/models/recurrences.dart';
import 'package:moedeiro/models/transaction.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/screens/recurrences/components/recurrenceBottomSheet.dart';
import 'package:moedeiro/util/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RecurrenceCard extends StatelessWidget {
  final Recurrence recurrence;
  const RecurrenceCard(
    this.recurrence, {
    Key? key,
  }) : super(key: key);

  Future<bool?> _showMyDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ComfirmDeleteDialog('🧐',
            title: S.of(context).executeTransaction,
            subtitle: S.of(context).executeTransactionDescription,
            confirmationLabel: S.of(context).execute);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCustomModalBottomSheet(
          context,
          RecurrenceBottomSheet(recurrence),
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
                color: recurrence.amount! > 0 ? Colors.green : Colors.red,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        children: [
                          Text(recurrence.categoryName ?? '',
                              style: Theme.of(context).textTheme.bodyText1),
                          Visibility(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              width: 1,
                              height: 15,
                              color: Colors.grey[500],
                            ),
                            visible: recurrence.name!.isNotEmpty,
                          ),
                          Flexible(
                            child: Text(
                              recurrence.name ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(recurrence.accountName ?? '',
                        style: Theme.of(context).textTheme.bodyText2),
                    TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          _showMyDialog(context).then((value) {
                            if (value! && value) {
                              Provider.of<TransactionModel>(context,
                                      listen: false)
                                  .insertTransactiontIntoDb(Transaction(
                                      account: recurrence.account,
                                      accountName: recurrence.accountName,
                                      amount: recurrence.amount,
                                      category: recurrence.category,
                                      categoryName: recurrence.category,
                                      name: recurrence.name,
                                      timestamp: DateTime.now()
                                          .millisecondsSinceEpoch));
                              recurrence.nextEvent =
                                  DateTime.now().millisecondsSinceEpoch;
                              recurrence.nextEvent =
                                  Provider.of<RecurrenceModel>(context,
                                          listen: false)
                                      .computeNextEvent(recurrence);
                              Provider.of<RecurrenceModel>(context,
                                      listen: false)
                                  .insertRecurrenceIntoDb(recurrence);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(S.of(context).transferCreated),
                                ),
                              );
                            }
                          });
                        },
                        child: Text(S.of(context).executeNow)),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                          formatCurrency(context, recurrence.amount!),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(S.of(context).nextEvent,
                            style: Theme.of(context).textTheme.bodyText2),
                      ),
                      Text(
                          DateFormat.yMMMEd().format(
                            DateTime.fromMillisecondsSinceEpoch(
                                recurrence.nextEvent!),
                          ),
                          style: Theme.of(context).textTheme.subtitle1),
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
