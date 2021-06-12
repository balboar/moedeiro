import 'package:flutter/material.dart';
import 'package:moedeiro/util/utils.dart';
import 'package:intl/intl.dart';

class MonthDetail extends StatelessWidget {
  final double amount;
  final String month;
  final String year;
  Color activeColor = Colors.white;
  Color disabledColor = Colors.grey;
  MonthDetail(this.amount, this.month, this.year);

  String returnMonth(month, year) {
    DateTime _date = DateTime(year, month, 1);
    return new DateFormat.MMMM().format(_date);
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
          returnMonth(int.parse(month), int.parse(year)),
          style: Theme.of(context).textTheme.subtitle2,
        )
      ],
    );
  }
}
