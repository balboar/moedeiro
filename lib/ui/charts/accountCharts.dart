import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:moedeiro/dataModels/accounts.dart';
import 'package:moedeiro/models/mainModel.dart';
import 'package:provider/provider.dart';

class AccountBalanceChart extends StatefulWidget {
  Account account;
  AccountBalanceChart({this.account});
  @override
  _AccountBalanceChartState createState() => _AccountBalanceChartState();
}

class _AccountBalanceChartState extends State<AccountBalanceChart> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  double maxY = 2000;
  double minY = -2000;
  double maxX = 50;
  List<FlSpot> spots = [FlSpot(0.0, 1.0)];
  List<Map<String, dynamic>> chartData;

  @override
  void initState() {
    super.initState();
    loadChartData();
  }

  void loadChartData() async {
    chartData = await Provider.of<AccountModel>(context, listen: false)
        .getChartDataByAccountAndDay(widget.account.uuid);

    List<Map<String, dynamic>> chartDataParsed = [];
    Map<String, dynamic> el = {};
    double _total = 0.0;

    for (var i = 1; i <= chartData.length; i++) {
      spots.clear();
      el['id'] = i;
      if (i == 1) _total = widget.account.initialAmount;
      _total = _total + chartData[i - 1]['amount'];
      el['amount'] = _total;
      chartDataParsed.add(Map.from(el));
      maxX = double.parse(i.toString());
    }

    if (chartDataParsed.length > 0)
      chartDataParsed.forEach((element) {
        spots.add(
          FlSpot(
            double.parse(element['id'].toString()),
            double.parse(
              double.parse(
                element['amount'].toString(),
              ).toStringAsFixed(2),
            ),
          ),
        );
      });

    setState(() {
      if (chartDataParsed.length > 0) {
        maxY = chartDataParsed.reduce((currentMap, nextMap) =>
            currentMap['amount'] > nextMap['amount']
                ? currentMap
                : nextMap)['amount'];
        minY = chartDataParsed.reduce((currentMap, nextMap) =>
            currentMap['amount'] < nextMap['amount']
                ? currentMap
                : nextMap)['amount'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 12),
        child: LineChart(
          mainData(),
        ),
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        show: false,
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          colors: gradientColors,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
