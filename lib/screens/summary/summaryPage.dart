import 'package:flutter/material.dart';
import 'package:moedeiro/components/moedeiroWidgets.dart';
import 'package:moedeiro/generated/l10n.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/util/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'components/TransactionsListBottonSheet.dart';
import 'components/monthDetail.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MonthViewer(),
      ),
    );
  }
}

class MonthViewer extends StatefulWidget {
  MonthViewer({Key? key}) : super(key: key);

  @override
  _MonthViewerState createState() => _MonthViewerState();
}

class _MonthViewerState extends State<MonthViewer> {
  PageController controller = PageController(
    viewportFraction: 0.4,
  );
  double totalExpensesMonth = 0;
  String month = '';
  String year = '';

  final controllerCharts = PageController(viewportFraction: 1);

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    await Provider.of<TransactionModel>(context, listen: false)
        .getTrasactionsGroupedByMonthAndCategory();
    if (Provider.of<TransactionModel>(context, listen: false)
            .monthlyTransactions
            .length >
        0) {
      month = Provider.of<TransactionModel>(context, listen: false)
          .monthlyTransactions
          .first['monthofyear'];
      year = Provider.of<TransactionModel>(context, listen: false)
          .monthlyTransactions
          .first['year'];

      Provider.of<TransactionModel>(context, listen: false)
          .getTrasactionsByMonthAndCategory(month, year);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).movementsTitle),
      ),
      body: SafeArea(
        child: Consumer<TransactionModel>(
          builder:
              (BuildContext context, TransactionModel model, Widget? child) {
            if (totalExpensesMonth == 0 &&
                model.monthlyTransactions.length > 0) {
              totalExpensesMonth = model.monthlyTransactions[0]['amount'];
            }
            return model.monthlyTransactions.length == 0
                ? Center()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // Container(
                      //   height: 200,
                      //   child: ExpensesByCategoryChart(),
                      // ),
                      Expanded(
                        child: model.transactionsOfTheMonth.length == 0
                            ? NoDataWidgetVertical()
                            : ListView.builder(
                                reverse: true,
                                itemExtent: 50.0,
                                itemCount: model.transactionsOfTheMonth.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return CustomCard(
                                      model.transactionsOfTheMonth[index],
                                      totalExpensesMonth,
                                      month == ''
                                          ? model.monthlyTransactions[0]
                                              ['monthofyear']
                                          : month,
                                      year == ''
                                          ? model.monthlyTransactions[0]['year']
                                          : year);
                                },
                              ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        height: 60,
                        child: PageView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return MonthDetail(
                              model.monthlyTransactions[index]['amount'],
                              model.monthlyTransactions[index]['monthofyear'],
                              model.monthlyTransactions[index]['year'],
                            );
                          },
                          itemCount: model.monthlyTransactions.length,
                          pageSnapping: true,
                          reverse: true,
                          onPageChanged: (int index) async {
                            Provider.of<TransactionModel>(context,
                                    listen: false)
                                .getTrasactionsByMonthAndCategory(
                                    model.monthlyTransactions[index]
                                        ['monthofyear'],
                                    model.monthlyTransactions[index]['year']);
                            month =
                                model.monthlyTransactions[index]['monthofyear'];
                            year = model.monthlyTransactions[index]['year'];
                            totalExpensesMonth =
                                model.monthlyTransactions[index]['amount'];
                          },
                          controller: controller,
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final double total;
  final String month;
  final String year;
  CustomCard(this.data, this.total, this.month, this.year, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      linearStrokeCap: LinearStrokeCap.round,
      padding: EdgeInsets.zero,
      progressColor: Colors.red.withOpacity(0.2),
      backgroundColor: Colors.transparent,
      lineHeight: 50,
      percent: data['amount'] / total,
      center: Container(
        height: 50.0,
        child: ListTile(
          onTap: () {
            showModalBottomSheet(
                enableDrag: true,
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                builder: (BuildContext context) {
                  return TransactionsListBottomSheet(data['uuid'], month, year);
                });
          },
          title: Text(
            data['name'] ?? '',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Theme.of(context).textTheme.subtitle1!.fontSize,
                color: Theme.of(context).textTheme.subtitle1!.color),
          ),
          trailing: Text(
            formatCurrency(context, data['amount']),
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}

class DropdownButtonFilter extends StatefulWidget {
  @override
  _DropdownButtonFilterState createState() {
    return _DropdownButtonFilterState();
  }
}

class _DropdownButtonFilterState extends State<DropdownButtonFilter> {
  String _value = 'm';
  @override
  void initState() {
    loadSettings();
    super.initState();
  }

  loadSettings() async {
    var prefs = await SharedPreferences.getInstance();
    _value = prefs.getString('movementsFilter') ?? 'w';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<String>(
        underline: Container(color: Colors.transparent),
        style: Theme.of(context).textTheme.headline6,
        items: [
          // DropdownMenuItem<String>(
          //   child: Text('Weekly'),
          //   value: 'w',
          // ),
          DropdownMenuItem<String>(
            child: Text('Monthly'),
            value: 'm',
          ),
          DropdownMenuItem<String>(
            child: Text('Yearly'),
            value: 'y',
          ),
        ],
        onChanged: (String? value) async {
          var prefs = await SharedPreferences.getInstance();
          prefs.setString('movementsFilter', value!);
          setState(() {
            _value = value;
          });
        },
        value: _value,
      ),
    );
  }
}
