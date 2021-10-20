import 'package:flutter/material.dart';
import 'package:moedeiro/components/moedeiroWidgets.dart';
import 'package:moedeiro/components/showBottomSheet.dart';
import 'package:moedeiro/generated/l10n.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/util/utils.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'components/CalendarFilterBottomSheet.dart';
import 'components/TransactionTypeFilterBottomSheet.dart';
import 'components/TransactionsListBottonSheet.dart';
import 'components/monthDetail.dart';
import 'package:intl/intl.dart';

Map<String, dynamic>? filterData;
Map<String, dynamic>? dateFilter;

class SummaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MonthViewer(),
      ),
      bottomNavigationBar: MoedeiroBottomAppBar(),
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

  final controllerCharts = PageController(viewportFraction: 1);

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() {
    Provider.of<AnalyticsModel>(context, listen: false).transactionsDateFilter =
        {'Filter': 'M', 'Date1': null, 'Date2': null};
    Provider.of<AnalyticsModel>(context, listen: false).transactionTypeFilter =
        'E';
  }

  Widget _mainBody(AnalyticsModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: model.transactionsGrouped.length == 0
              ? NoDataWidgetVertical()
              : ListView.builder(
                  reverse: true,
                  itemExtent: 60.0,
                  itemCount: model.transactionsGrouped.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CustomCard(
                        model.transactionsGrouped[index],
                        model.totalExpensesAbs,
                        model.currentMonth,
                        model.currentYear);
                  },
                ),
        ),
        Container(
          margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
          height: 60,
          child: PageView.builder(
            itemBuilder: (BuildContext context, int index) {
              return MonthDetail(
                model.transactionsSummary[index]['amount'],
                model.transactionsSummary[index]['monthofyear'],
                model.transactionsSummary[index]['year'],
              );
            },
            itemCount: model.transactionsSummary.length,
            pageSnapping: true,
            scrollDirection: Axis.horizontal,
            reverse: true,
            onPageChanged: (int index) async {
              model.selectedIndex = index;
            },
            controller: controller,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AnalyticsModel>(
      builder: (BuildContext context, AnalyticsModel model, Widget? child) {
        return model.transactionsSummary.length == 0
            ? Center()
            : _mainBody(model);
      },
    );
  }
}

class MoedeiroBottomAppBar extends StatefulWidget {
  @override
  State<MoedeiroBottomAppBar> createState() => _MoedeiroBottomAppBarState();
}

class _MoedeiroBottomAppBarState extends State<MoedeiroBottomAppBar> {
  Widget _buildChip(String label) {
    return Chip(
      labelPadding: EdgeInsets.all(2.0),
      label: Text(label, style: Theme.of(context).textTheme.subtitle2),
      padding: EdgeInsets.all(8.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.primary),
        child: Consumer<AnalyticsModel>(builder:
            (BuildContext context, AnalyticsModel model, Widget? child) {
          var dateFilter = model.transactionsDateFilter;
          var dateText = '';
          var filterText = '';
          if (dateFilter['Filter'] == 'Y') dateText = S.of(context).yearly;
          if (dateFilter['Filter'] == 'M') dateText = S.of(context).monthly;
          if (dateFilter['Filter'] == 'C')
            dateText =
                '${DateFormat.yMd().format(dateFilter['Date1'])} - ${DateFormat.yMd().format(dateFilter['Date2'])}';
          if (model.transactionTypeFilter == 'I')
            filterText = S.of(context).incomes;
          if (model.transactionTypeFilter == 'E')
            filterText = S.of(context).expense;
          if (model.transactionTypeFilter == '%')
            filterText = S.of(context).netIncome;
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width - 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  primary: true,
                  shrinkWrap: true,
                  children: <Widget>[
                    Wrap(spacing: 4.0, runSpacing: 0.0, children: [
                      _buildChip(filterText),
                      _buildChip(
                        dateText,
                      ),
                    ]),
                  ],
                ),
              ),
              IconButton(
                  tooltip: 'Type',
                  icon: const Icon(Icons.filter_list_outlined),
                  onPressed: () {
                    showCustomModalBottomSheet(
                      context,
                      TransactionTypeFilterBottomSheet(),
                      isScrollControlled: false,
                      enableDrag: false,
                    ).then(
                      (value) {
                        if (value is Map<String, dynamic>) {
                          Provider.of<AnalyticsModel>(context, listen: false)
                              .selectedIndex = 0;

                          Provider.of<AnalyticsModel>(context, listen: false)
                              .transactionTypeFilter = value['Filter'];
                        }
                      },
                    );
                  }),
              IconButton(
                tooltip: 'Calendar',
                icon: const Icon(Icons.calendar_today_outlined),
                onPressed: () {
                  showCustomModalBottomSheet(
                    context,
                    CalendarFilterBottomSheet(),
                    isScrollControlled: false,
                    enableDrag: false,
                  ).then(
                    (value) {
                      if (value is Map<String, dynamic>) {
                        Provider.of<AnalyticsModel>(context, listen: false)
                            .selectedIndex = 0;

                        Provider.of<AnalyticsModel>(context, listen: false)
                            .transactionsDateFilter = value;
                      }
                    },
                  );
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final double total;
  final String? month;
  final String year;
  CustomCard(this.data, this.total, this.month, this.year, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double percent = data['amount'].abs() / total.abs();
    if (percent > 1 || percent < 0) percent = 0;
    return GestureDetector(
        onTap: () {
          showModalBottomSheet(
              enableDrag: true,
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              builder: (BuildContext context) {
                // ARREGLAR ESTO
                return TransactionsListBottomSheet(data['uuid'], month, year);
              });
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          height: 50.0,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data['name'] ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                    Text(
                      formatCurrency(context, data['amount']),
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: LinearPercentIndicator(
                  lineHeight: 5.0,
                  percent: percent,
                  backgroundColor: Colors.grey.shade200,
                  progressColor:
                      data["type"] == 'E' ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ));
  }
}
