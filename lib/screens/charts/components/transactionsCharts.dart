import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/util/utils.dart';
import 'package:provider/provider.dart';

class TransactionChart extends StatefulWidget {
  final String accountUuid;

  const TransactionChart({Key key, this.accountUuid}) : super(key: key);

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

  int touchedGroupIndex;

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
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      color: Colors.transparent, //const Color(0xff2c4260),
      child: Padding(
        padding: const EdgeInsets.only(top: 15, left: 5, right: 5),
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
                        touchCallback: (response) {
                          // if (response.spot == null) {
                          //   setState(() {
                          //     touchedGroupIndex = -1;
                          //     showingBarGroups = List.of(rawBarGroups);
                          //   });
                          //   return;
                          // }

                          // touchedGroupIndex =
                          //     response.spot.touchedBarGroupIndex;

                          // setState(() {
                          //   if (response.touchInput is FlLongPressEnd ||
                          //       response.touchInput is FlPanEnd) {
                          //     touchedGroupIndex = -1;
                          //     showingBarGroups = List.of(rawBarGroups);
                          //   } else {
                          //     showingBarGroups = List.of(rawBarGroups);
                          //     if (touchedGroupIndex != -1) {
                          //       double sum = 0;
                          //       for (BarChartRodData rod
                          //           in showingBarGroups[touchedGroupIndex]
                          //               .barRods) {
                          //         sum += rod.y;
                          //       }
                          //       final avg = sum /
                          //           showingBarGroups[touchedGroupIndex]
                          //               .barRods
                          //               .length;

                          //       showingBarGroups[touchedGroupIndex] =
                          //           showingBarGroups[touchedGroupIndex]
                          //               .copyWith(
                          //         barRods: showingBarGroups[touchedGroupIndex]
                          //             .barRods
                          //             .map((rod) {
                          //           return rod.copyWith(y: avg);
                          //         }).toList(),
                          //       );
                          //     }
                          //   }
                          // });
                        }),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (value) => const TextStyle(
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
                        getTextStyles: (value) => const TextStyle(
                            color: Color(0xff7589a2),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                        margin: 32,
                        reservedSize: 14,
                        getTitles: (value) {
                          if (value == 1000) {
                            return '1K';
                          } else if (value == 2000) {
                            return '2K';
                          } else if (value == 3000) {
                            return '3K';
                          } else if (value == 4000) {
                            return '4K';
                          } else if (value == 5000) {
                            return '5K';
                          } else if (value == 6000) {
                            return '6K';
                          } else if (value == 7000) {
                            return '7K';
                          } else {
                            return '';
                          }
                        },
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    barGroups: showingBarGroups,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    if (y1 == null) y1 = 0;
    if (y2 == null) y2 = 0;
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: [leftBarColor],
        width: width,
      ),
      BarChartRodData(
        y: y2,
        colors: [rightBarColor],
        width: width,
      ),
    ]);
  }
}

class ExpensesByMonthChart extends StatefulWidget {
  final String accountUuid;

  ExpensesByMonthChart({this.accountUuid});
  @override
  State<StatefulWidget> createState() => ExpensesByMonthChartState();
}

class ExpensesByMonthChartState extends State<ExpensesByMonthChart> {
  double maxY = 2000;

  List<BarChartGroupData> rawBarGroups = [];
  List<BarChartGroupData> showingBarGroups;
  List<Map<String, dynamic>> chartData;
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
          y: y1,
          colors: [
            Colors.red[900],
          ],
          width: 7,
        ),
      ],
      showingTooltipIndicators: [0],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      color: //widget.accountUuid != null
          //?
          Colors.transparent,
      // : const Color(0xff2c4260),
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
                      tooltipBottomMargin: 8,
                      getTooltipItem: (
                        BarChartGroupData group,
                        int groupIndex,
                        BarChartRodData rod,
                        int rodIndex,
                      ) {
                        return BarTooltipItem(
                          formatCurrency(context, rod.y),
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
                      getTextStyles: (value) => const TextStyle(
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
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingBarGroups,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExpensesByCategoryChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ExpensesByCategoryChartState();
}

class ExpensesByCategoryChartState extends State<ExpensesByCategoryChart> {
  double maxY = 0;
  int index = 1;
  int touchedIndex;

  List<BarChartGroupData> rawBarGroups = [];
  List<BarChartGroupData> showingBarGroups = [];
  @override
  void initState() {
    super.initState();
  }

  BarChartGroupData makeGroupData(int x, double y1, bool isTouched) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y1 + 1 : y1,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(7.0),
            topRight: Radius.circular(7.0),
          ),
          colors: [Colors.red, Colors.redAccent],
          width: 7,
        ),
      ],
      showingTooltipIndicators: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionModel>(
        builder: (BuildContext context, TransactionModel model, Widget child) {
      showingBarGroups.clear();
      index = 1;
      rawBarGroups.clear();
      model.transactionsOfTheMonth.forEach((Map<String, dynamic> value) {
        if (index < 7)
          rawBarGroups.add(
              makeGroupData(index, value['amount'], index == touchedIndex));
        index = index + 1;
      });
      showingBarGroups = rawBarGroups;

      if (model.transactionsOfTheMonth.length > 0)
        maxY = model.transactionsOfTheMonth.reduce((currentMap, nextMap) =>
            currentMap['amount'] > nextMap['amount']
                ? currentMap
                : nextMap)['amount'];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 40, left: 10, right: 10, bottom: 20),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  barTouchData: BarTouchData(
                    touchCallback: (barTouchResponse) {
                      setState(() {
                        if (barTouchResponse.spot != null &&
                            barTouchResponse.touchInput is! FlPanEnd &&
                            barTouchResponse.touchInput is! FlLongPressEnd) {
                          touchedIndex =
                              barTouchResponse.spot.touchedBarGroupIndex;
                        } else {
                          touchedIndex = -1;
                        }
                      });
                    },
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.transparent,
                      tooltipPadding: const EdgeInsets.all(0),
                      tooltipBottomMargin: 8,
                      getTooltipItem: (
                        BarChartGroupData group,
                        int groupIndex,
                        BarChartRodData rod,
                        int rodIndex,
                      ) {
                        return BarTooltipItem(
                          formatCurrency(context, rod.y),
                          TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                      rotateAngle: 270,
                      showTitles: false,
                      getTextStyles: (value) => const TextStyle(
                          color: Color(0xff7589a2),
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                      margin: 5,
                      getTitles: (double value) {
                        return model.transactionsOfTheMonth
                            .elementAt(value.toInt() - 1)['name'];
                      },
                    ),
                    leftTitles: SideTitles(showTitles: false),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingBarGroups,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key key,
    this.color,
    this.text,
    this.isSquare,
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
