import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:moedeiro/generated/l10n.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MPieChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PieChartState();
}

class PieChartState extends State {
  int touchedIndex = -1;
  List<Map<String, dynamic>> chartData = [];
  int _currentMonth = 0;
  int _currentYear = 0;
  int _actualMonth = 0;
  int _actualYear = 0;

  @override
  void initState() {
    var date = new DateTime.now().toString();

    var dateParse = DateTime.parse(date);
    _currentMonth = dateParse.month;
    _currentYear = dateParse.year;
    _actualMonth = _currentMonth;
    _actualYear = _currentYear;
    loadChartData(_currentMonth, _currentYear);
    super.initState();
  }

  void loadChartData(int month, int year) async {
    chartData = await Provider.of<TransactionModel>(context, listen: false)
        .getPieChartData(month.toString(), year.toString());

    setState(() {
      chartData = chartData;
    });
  }

  String returnMonth(month, year) {
    DateTime _date = DateTime(year, month, 1);
    return new DateFormat.MMMM().format(_date);
  }

  void setMonthYear(month, year) {
    DateTime _date = DateTime(year, month, 1);
    _currentMonth = int.parse(DateFormat.M().format(_date));
    _currentYear = int.parse(DateFormat.y().format(_date));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          height: (MediaQuery.of(context).size.height / 2) - 140,
          child: PieChart(
            PieChartData(
                pieTouchData:
                    PieTouchData(touchCallback: (event, pieTouchResponse) {
                  setState(() {
                    final desiredTouch =
                        pieTouchResponse!.touchedSection is! PointerExitEvent &&
                            pieTouchResponse.touchedSection is! PointerUpEvent;
                    if (desiredTouch &&
                        pieTouchResponse.touchedSection != null) {
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    } else {
                      touchedIndex = -1;
                    }
                  });
                }),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 2,
                centerSpaceRadius:
                    (MediaQuery.of(context).size.height / 2) * 0.23,
                sections: showingSections()),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    _currentMonth = _currentMonth - 1;
                    setMonthYear(_currentMonth, _currentYear);
                    loadChartData(_currentMonth, _currentYear);
                  }),
            ),
            SizedBox(
              width: 120,
              child: Center(
                child: Text(
                  '${returnMonth(_currentMonth, _currentYear)} ${_currentYear.toString()}',
                ),
              ),
            ),
            _currentMonth == _actualMonth && _currentYear == _actualYear
                ? SizedBox(
                    width: 50,
                  )
                : SizedBox(
                    width: 50,
                    child: IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          _currentMonth = _currentMonth + 1;
                          setMonthYear(_currentMonth, _currentYear);
                          loadChartData(_currentMonth, _currentYear);
                        }),
                  )
          ],
        )
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    double _totalAmount = 0;
    chartData.forEach((element) {
      _totalAmount = _totalAmount + element["amount"];
    });
    return chartData.length > 0
        ? chartData.map((e) {
            return PieChartSectionData(
              color: e["type"] == 'E' ? Colors.red : Colors.green,
              value: double.tryParse(
                      ((e["amount"] / _totalAmount) * 100).toString())
                  ?.roundToDouble(),
              title:
                  '${double.tryParse(((e["amount"] / _totalAmount) * 100).toString())?.round()}%',
              titlePositionPercentageOffset: -2.5,
              radius: 8.0,
              titleStyle: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.subtitle1?.color),
            );
          }).toList()
        : [
            PieChartSectionData(
              color: Theme.of(context).disabledColor,
              value: 100,
              title: '',
              badgeWidget: Center(
                  child: Text(
                S.of(context).noDataLabel,
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.subtitle1?.color),
              )),
              badgePositionPercentageOffset: -7,
              radius: 8.0,
            )
          ];
  }
}
