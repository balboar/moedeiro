import 'package:flutter/material.dart';
import 'package:moedeiro/util/utils.dart';

class MonthDetail extends StatefulWidget {
  final double amount;
  final int index;
  final String month;
  PageController controller;
  MonthDetail({Key key, this.amount, this.index, this.month, this.controller})
      : super(key: key);

  @override
  _MonthDetailState createState() => _MonthDetailState();
}

class _MonthDetailState extends State<MonthDetail> {
  Color activeColor = Colors.white;
  Color disabledColor = Colors.grey;
  @override
  Widget build(BuildContext context) {
    // print('index' + widget.index.toString());
    // print('controller' + widget.controller.page.toString());
    // print(widget.controller.offset.toString());
    // print(widget.controller..toString());
    return Column(
      children: [
        Text(
          formatCurrency(context, widget.amount),
          style: Theme.of(context).textTheme.headline5,
          // style: Theme.of(context).textTheme.headline5.copyWith(
          //     color: widget.index == widget.controller.page.toInt()
          //         ? activeColor
          //         : disabledColor),
        ),
        Text(
          widget.month,
          style: Theme.of(context).textTheme.subtitle2,
        )
      ],
    );
  }
}
