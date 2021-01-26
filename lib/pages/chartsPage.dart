import 'package:flutter/material.dart';
import 'package:moedeiro/ui/charts/transactionsCharts.dart';
import 'package:moedeiro/generated/l10n.dart';

class ChartsPage extends StatelessWidget {
  const ChartsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).movementsTitle),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Container(
              width: 600,
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
