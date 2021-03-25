
import 'package:flutter/material.dart';
import 'package:moedeiro/util/utils.dart';

class MonthDetail extends StatefulWidget {
  final double amount;
  final String month;
  MonthDetail(
    this.amount,
    this.month, {
    Key? key,
  }) : super(key: key);

  @override
  _MonthDetailState createState() => _MonthDetailState();
}

class _MonthDetailState extends State<MonthDetail> {
  Color activeColor = Colors.white;
  Color disabledColor = Colors.grey;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          formatCurrency(context, widget.amount),
          style: Theme.of(context).textTheme.headline5,
        ),
        Text(
          widget.month,
          style: Theme.of(context).textTheme.subtitle2,
        )
      ],
    );
  }
}
