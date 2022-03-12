import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/util/utils.dart';
import 'package:provider/provider.dart';

class TransactionChart extends StatefulWidget {
  final String? accountUuid;

  const TransactionChart({Key? key, this.accountUuid}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TransactionChartState();
}

class TransactionChartState extends State<TransactionChart> {
  final Color leftBarColor = Colors.green;
  final Color rightBarColor = Colors.red;
  final double width = 7;
  double maxY = 2000;

  List<BarChartGroupData> rawBarGroups = [];
  List<BarChartGroupData> showingBarGroups = [];

  int? touchedGroupIndex;

  @override
  void initState() {
    loadChartData();
    super.initState();
  }

  void loadChartData() async {
    List<Map<String, dynamic>> chartData;

    if (widget.accountUuid != null)
      chartData = await Provider.of<TransactionModel>(context, listen: false)
          .getChartDataByAccount(widget.accountUuid);
    else
      chartData = await Provider.of<TransactionModel>(context, listen: false)
          .getChartData();
//{amount: 7.0, monthofyear: 01, year: 2021, type: E},
    List<Map<String, dynamic>> chartDataParsed = [];

    Map<String, dynamic> el = {};
    chartData.forEach((element) {
      if (el.isNotEmpty) {
        if (element['monthofyear'] != el['month']) {
          chartDataParsed.add(Map.from(el));
          el.clear();
          el = {'month': '', 'income': 0.0, 'expense': 0.0};
        }
      }
      el['month'] = element['monthofyear'];
      if (element['type'] == 'E') {
        el['expense'] = element['amount'];
      } else {
        el['income'] = element['amount'];
      }
    });
    if (el.length > 0) chartDataParsed.add(Map.from(el));
    if (chartDataParsed.length > 0)
      chartDataParsed.forEach((element) {
        rawBarGroups.add(makeGroupData(int.parse(element['month']),
            element['income'], element['expense']));
      });
    setState(() {
      rawBarGroups = rawBarGroups;
      showingBarGroups = rawBarGroups;
      if (chartData.length > 0)
        maxY = chartData.reduce((currentMap, nextMap) =>
            currentMap['amount'] > nextMap['amount']
                ? currentMap
                : nextMap)['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //  padding: EdgeInsets.symmetric(vertical: 30),
      width: showingBarGroups.length * 60,
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: BarChart(
                BarChartData(
                    maxY: maxY,
                    minY: 0,
                    barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Colors.grey,
                          getTooltipItem: (_a, _b, _c, _d) => null,
                        ),
                        touchCallback: (event, response) {}),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (context, value) => const TextStyle(
                            color: Color(0xff7589a2),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                        margin: 10,
                        getTitles: (double value) {
                          switch (value.toInt()) {
                            case 1:
                              return 'Jan';
                            case 2:
                              return 'Feb';
                            case 3:
                              return 'Mar';
                            case 4:
                              return 'Apr';
                            case 5:
                              return 'May';
                            case 6:
                              return 'Jun';
                            case 7:
                              return 'Jul';
                            case 8:
                              return 'Aug';
                            case 9:
                              return 'Sep';
                            case 10:
                              return 'Oct';
                            case 11:
                              return 'Nov';
                            case 12:
                              return 'Dec';
                            default:
                              return '';
                          }
                        },
                      ),
                      leftTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (context, value) => const TextStyle(
                            color: Color(0xff7589a2),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                        margin: 20,
                        reservedSize: 20,
                        getTitles: (value) {
                          var result = (value ~/ 1000);
                          var remainder = value % 1000;
                          if (remainder == 0 && result > 0)
                            return '${result.toStringAsFixed(0)}K';
                          else
                            return '';
                        },
                      ),
                      topTitles: SideTitles(showTitles: false),
                      rightTitles: SideTitles(showTitles: false),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    barGroups: showingBarGroups,
                    gridData: FlGridData(show: false)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double? y1, double? y2) {
    if (y1 == null) y1 = 0;
    if (y2 == null) y2 = 0;
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        toY: y1,
        colors: [leftBarColor],
        width: width,
      ),
      BarChartRodData(
        toY: y2,
        colors: [rightBarColor],
        width: width,
      ),
    ]);
  }
}

class ExpensesByMonthChart extends StatefulWidget {
  final String? accountUuid;

  ExpensesByMonthChart({this.accountUuid});
  @override
  State<StatefulWidget> createState() => ExpensesByMonthChartState();
}

class ExpensesByMonthChartState extends State<ExpensesByMonthChart> {
  double maxY = 2000;

  List<BarChartGroupData> rawBarGroups = [];
  List<BarChartGroupData> showingBarGroups = [];
  List<Map<String, dynamic>> chartData = [];
  @override
  void initState() {
    super.initState();
    loadChartData();
  }

  void loadChartData() async {
    if (widget.accountUuid != null)
      chartData = await Provider.of<TransactionModel>(context, listen: false)
          .getChartDataByAccount(widget.accountUuid);
    else
      chartData = await Provider.of<TransactionModel>(context, listen: false)
          .getChartData();

    List<Map<String, dynamic>> chartDataParsed = [];
    Map<String, dynamic> el = {};
    chartData.forEach((element) {
      if (element['type'] == 'E') {
        el['month'] = element['monthofyear'];
        el['expense'] = element['amount'];

        chartDataParsed.add(Map.from(el));
      }
    });

    if (chartDataParsed.length > 0)
      chartDataParsed.forEach((element) {
        rawBarGroups.add(
            makeGroupData(int.parse(element['month']), element['expense']));
        showingBarGroups = rawBarGroups;
      });

    setState(() {
      if (chartDataParsed.length > 0)
        maxY = chartDataParsed.reduce((currentMap, nextMap) =>
            currentMap['expense'] > nextMap['expense']
                ? currentMap
                : nextMap)['expense'];
    });
  }

  BarChartGroupData makeGroupData(int x, double y1) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          colors: [
            Colors.red,
          ],
          width: 7,
        ),
      ],
      showingTooltipIndicators: [0],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: showingBarGroups.length * 70,
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 40, left: 5, right: 5),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  barTouchData: BarTouchData(
                    enabled: false,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.transparent,
                      tooltipPadding: const EdgeInsets.all(0),
                      tooltipMargin: 8,
                      getTooltipItem: (
                        BarChartGroupData group,
                        int groupIndex,
                        BarChartRodData rod,
                        int rodIndex,
                      ) {
                        return BarTooltipItem(
                          formatCurrency(context, rod.toY),
                          TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) => const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                      margin: 20,
                      getTitles: (double value) {
                        switch (value.toInt()) {
                          case 1:
                            return 'Jan';
                          case 2:
                            return 'Feb';
                          case 3:
                            return 'Mar';
                          case 4:
                            return 'Apr';
                          case 5:
                            return 'May';
                          case 6:
                            return 'Jun';
                          case 7:
                            return 'Jul';
                          case 8:
                            return 'Aug';
                          case 9:
                            return 'Sep';
                          case 10:
                            return 'Oct';
                          case 11:
                            return 'Nov';
                          case 12:
                            return 'Dec';
                          default:
                            return '';
                        }
                      },
                    ),
                    leftTitles: SideTitles(showTitles: false),
                    topTitles: SideTitles(showTitles: false),
                    rightTitles: SideTitles(showTitles: false),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingBarGroups,
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class ExpensesByCategoryChart extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => ExpensesByCategoryChartState();
// }

// class ExpensesByCategoryChartState extends State<ExpensesByCategoryChart> {
//   double maxY = 0;
//   int index = 1;
//   int? touchedIndex;

//   List<BarChartGroupData> rawBarGroups = [];
//   List<BarChartGroupData> showingBarGroups = [];
//   @override
//   void initState() {
//     super.initState();
//   }

//   BarChartGroupData makeGroupData(int x, double y1, bool isTouched) {
//     return BarChartGroupData(
//       barsSpace: 4,
//       x: x,
//       barRods: [
//         BarChartRodData(
//           y: isTouched ? y1 + 1 : y1,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(7.0),
//             topRight: Radius.circular(7.0),
//           ),
//           colors: [Colors.red, Colors.redAccent],
//           width: 7,
//         ),
//       ],
//       showingTooltipIndicators: [],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<TransactionModel>(
//         builder: (BuildContext context, TransactionModel model, Widget? child) {
//       showingBarGroups.clear();
//       index = 1;
//       rawBarGroups.clear();
//       model.transactionsOfTheMonth.forEach((Map<String, dynamic> value) {
//         if (index < 7)
//           rawBarGroups.add(
//               makeGroupData(index, value['amount'], index == touchedIndex));
//         index = index + 1;
//       });
//       showingBarGroups = rawBarGroups;

//       if (model.transactionsOfTheMonth.length > 0)
//         maxY = model.transactionsOfTheMonth.reduce((currentMap, nextMap) =>
//             currentMap['amount'] > nextMap['amount']
//                 ? currentMap
//                 : nextMap)['amount'];

//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         mainAxisAlignment: MainAxisAlignment.start,
//         mainAxisSize: MainAxisSize.max,
//         children: <Widget>[
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(
//                   top: 40, left: 10, right: 10, bottom: 20),
//               child: BarChart(
//                 BarChartData(
//                   alignment: BarChartAlignment.spaceAround,
//                   maxY: maxY,
//                   barTouchData: BarTouchData(
//                     touchCallback: (barTouchResponse) {
//                       setState(() {
//                         if (barTouchResponse.spot != null &&
//                             barTouchResponse.touchInput is! PointerUpEvent &&
//                             barTouchResponse.touchInput is! PointerExitEvent) {
//                           touchedIndex =
//                               barTouchResponse.spot!.touchedBarGroupIndex;
//                         } else {
//                           touchedIndex = -1;
//                         }
//                       });
//                     },
//                     touchTooltipData: BarTouchTooltipData(
//                       tooltipBgColor: Colors.transparent,
//                       tooltipPadding: const EdgeInsets.all(0),
//                       tooltipMargin: 8,
//                       getTooltipItem: (
//                         BarChartGroupData group,
//                         int groupIndex,
//                         BarChartRodData rod,
//                         int rodIndex,
//                       ) {
//                         return BarTooltipItem(
//                           formatCurrency(context, rod.y),
//                           TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   titlesData: FlTitlesData(
//                     show: true,
//                     bottomTitles: SideTitles(
//                       rotateAngle: 270,
//                       showTitles: false,
//                       getTextStyles: (value) => const TextStyle(
//                           color: Color(0xff7589a2),
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14),
//                       margin: 5,
//                       getTitles: (double value) {
//                         return model.transactionsOfTheMonth
//                             .elementAt(value.toInt() - 1)['name'];
//                       },
//                     ),
//                     leftTitles: SideTitles(showTitles: false),
//                   ),
//                   borderData: FlBorderData(
//                     show: false,
//                   ),
//                   barGroups: showingBarGroups,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}

class ExpensesChartByCategory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ExpensesChartByCategoryState();
}

class ExpensesChartByCategoryState extends State<ExpensesChartByCategory> {
  List<PieChartSectionData> showingSections = [];
  double total = 0;

  @override
  void initState() {
    super.initState();
    loadChartData();
  }

  void loadChartData() async {
    var chartData = await Provider.of<TransactionModel>(context, listen: false)
        .getCategoryExpensesChartData();
//{amount: 7.0, monthofyear: 01, year: 2021, type: E},
    List<Map<String, dynamic>> chartDataParsed = [];
    Map<String, dynamic> el = {};
    chartData.forEach((element) {
      el['category'] = element['name'];
      el['amount'] = element['amount'];
      total = total + element['amount'];
      chartDataParsed.add(Map.from(el));
      el.clear();
    });

    chartDataParsed.forEach((element) {
      showingSections.add(
        PieChartSectionData(
          color: const Color(0xff0293ee),
          value: (element['amount'] / total) * 100,
          title: double.parse(element['amount'].toString()).toStringAsFixed(2),
          radius: 50,
          titleStyle: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff)),
        ),
      );
    });
    setState(() {
      showingSections = showingSections.sublist(1, 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      color: const Color(0xff2c4260),
      child: Padding(
        padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: PieChart(
                PieChartData(
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 30,
                  sections: showingSections,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Indicator(
                  color: Color(0xff0293ee),
                  text: 'First',
                  isSquare: false,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xfff8b250),
                  text: 'Second',
                  isSquare: false,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xff845bef),
                  text: 'Third',
                  isSquare: false,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xff13d38e),
                  text: 'Fourth',
                  isSquare: false,
                ),
                SizedBox(
                  height: 18,
                ),
              ],
            ),
            const SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
    );
  }
}
