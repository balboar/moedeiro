import 'package:flutter/material.dart';
import 'package:moedeiro/models/transaction.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/screens/movements/components/transactionWidgets.dart';
import 'package:provider/provider.dart';

class LastTransactionsWidget extends StatefulWidget {
  LastTransactionsWidget({Key? key}) : super(key: key);

  @override
  _LastTransactionsWidgetState createState() => _LastTransactionsWidgetState();
}

class _LastTransactionsWidgetState extends State<LastTransactionsWidget>
    with TickerProviderStateMixin {
  late AnimationController _staggeredController;
  static const _initialDelayTime = Duration(milliseconds: 50);
  static const _itemSlideTime = Duration(milliseconds: 550);
  static const _staggerTime = Duration(milliseconds: 50);
  Duration _animationDuration = Duration(seconds: 0);

  final List<Interval> _itemSlideIntervals = [];

  @override
  void initState() {
    super.initState();

    _staggeredController = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    _staggeredController.dispose();
    super.dispose();
  }

  void _createAnimationIntervals(int itemsLength) {
    for (var i = 0; i < itemsLength; ++i) {
      final startTime = _initialDelayTime + (_staggerTime * i);
      final endTime = startTime + _itemSlideTime;
      _itemSlideIntervals.add(
        Interval(
          startTime.inMilliseconds / _animationDuration.inMilliseconds,
          endTime.inMilliseconds / _animationDuration.inMilliseconds,
        ),
      );
    }
  }

  List<Widget> _buildListItems(List<Transaction> _transactionsList) {
    final listItems = <Widget>[];
    for (var i = 0; i < _transactionsList.length; ++i) {
      listItems.add(
        Container(
          height: 75,
          child: TransactionTile(_transactionsList[i]),
        ),
        // AnimatedBuilder(
        //   animation: _staggeredController,
        //   builder: (context, child) {
        //     final animationPercent = Curves.easeOut.transform(
        //       _itemSlideIntervals[i].transform(_staggeredController.value),
        //     );
        //     final opacity = animationPercent;
        //     final slideDistance = (1.0 - animationPercent) * 150;

        //     return Opacity(
        //       opacity: opacity,
        //       child: Transform.translate(
        //         offset: Offset(slideDistance, 0),
        //         child: child,
        //       ),
        //     );
        //   },
        //   child: Container(
        //     height: 75,
        //     child: TransactionTile(_transactionsList[i]),
        //   ),
        // ),
      );
    }
    return listItems;
  }

  @override
  Widget build(BuildContext context) {
    _animationDuration = Duration(seconds: 0);
    return Consumer<TransactionModel>(
      builder: (BuildContext context, TransactionModel model, Widget? child) {
        if (model.transactions == null)
          return Container(
            height: 100,
            margin:
                EdgeInsets.only(left: 10.0, right: 10, top: 0, bottom: 10.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        else if (model.transactions!.length == 0)
          return Container(
            height: 100,
            margin:
                EdgeInsets.only(left: 10.0, right: 10, top: 0.0, bottom: 10.0),
          );
        else {
          var _transactionsList = model.transactions!.length > 5
              ? model.transactions!.sublist(0, 5)
              : model.transactions!;
          // _animationDuration =
          //     _initialDelayTime + (_staggerTime * _transactionsList.length);
          // _createAnimationIntervals(_transactionsList.length);
          // _staggeredController = AnimationController(
          //   vsync: this,
          //   duration: _animationDuration,
          // )..forward();
          return Container(
            margin:
                EdgeInsets.only(left: 10.0, right: 10, top: 0.0, bottom: 10.0),
            child: Column(
              children: _buildListItems(_transactionsList),
            ),
          );
        }
      },
    );
  }
}
