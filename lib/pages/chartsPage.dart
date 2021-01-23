import 'package:flutter/material.dart';
import 'package:moedeiro/ui/charts/transactionsCharts.dart';

class ChartsPage extends StatelessWidget {
  const ChartsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movements'),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Container(
              width: 800,
              child: ExpensesByCategoryChart(),
              height: 200,
            ),
            scrollDirection: Axis.horizontal,
          ),
        ],
      ),
    );
  }
}
