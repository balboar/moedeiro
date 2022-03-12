import 'package:flutter/material.dart';
import 'package:moedeiro/util/utils.dart';
import 'package:intl/intl.dart';

class MonthDetail extends StatelessWidget {
  final double amount;
  final String? month;
  final String year;

  MonthDetail(this.amount, this.month, this.year);

  String returnDate() {
    if (month != null) {
      DateTime _date = DateTime(int.parse(year), int.parse(month!), 1);
      return toBeginningOfSentenceCase(DateFormat.MMMM().format(_date))!;
    } else
      return toBeginningOfSentenceCase(year)!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          formatCurrency(context, amount),
          style: Theme.of(context).textTheme.headline5,
        ),
        Text(
          returnDate(),
          style: Theme.of(context).textTheme.bodyText2,
        )
      ],
    );
  }
}
