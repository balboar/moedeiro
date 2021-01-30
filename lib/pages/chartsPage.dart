import 'package:flutter/material.dart';
import 'package:moedeiro/models/mainModel.dart';
import 'package:moedeiro/ui/charts/transactionsCharts.dart';
import 'package:moedeiro/generated/l10n.dart';
import 'package:moedeiro/util/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ChartsPage extends StatelessWidget {
  const ChartsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          DropdownButtonFilter(),
        ],
        title: Text(S.of(context).movementsTitle),
      ),
      body: MonthViewer(),
    );
  }
}

class MonthViewer extends StatefulWidget {
  MonthViewer({Key key}) : super(key: key);

  @override
  _MonthViewerState createState() => _MonthViewerState();
}

class _MonthViewerState extends State<MonthViewer> {
  PageController controller = PageController(
    viewportFraction: 0.4,
  );

  final controllerCharts = PageController(viewportFraction: 1);
  List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  List<Map<String, dynamic>> chartData = [];
  List<Widget> dataWidgets = [];
  List<Map<String, dynamic>> monthData = [];
  List<Widget> monthDataWidgets = [];
  @override
  void initState() {
    loadChartData();
    super.initState();
  }

  void loadChartData() async {
    chartData = await Provider.of<TransactionModel>(context, listen: false)
        .getTrasactionsGroupedByMonthAndCategory();
    chartData.forEach((element) {
      dataWidgets.add(
        Column(
          children: [
            Text(
              formatCurrency(context, element['amount']),
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              _months[int.parse(element['monthofyear']) - 1],
              style: Theme.of(context).textTheme.subtitle2,
            )
          ],
        ),
      );
    });
    setState(() {
      dataWidgets = dataWidgets;
    });
    controller.jumpToPage(dataWidgets.length - 1);

    loadMonthData(chartData.length - 1);
  }

  void loadMonthData(int pageIndex) async {
    monthData = await Provider.of<TransactionModel>(context, listen: false)
        .getTrasactionsByMonthAndCategory(
            chartData[pageIndex]['monthofyear'], chartData[pageIndex]['year']);
    monthData.forEach((element) {
      monthDataWidgets.add(
        Column(
          children: [
            Text(
              formatCurrency(context, element['amount']),
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              element['name'],
              style: Theme.of(context).textTheme.subtitle2,
            )
          ],
        ),
      );
    });
    setState(() {
      monthDataWidgets = monthDataWidgets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          //  margin: EdgeInsets.only(left: 10.0, right: 10, bottom: 2.0),
          height: 200,
          child: PageView(
            physics: BouncingScrollPhysics(),
            controller: controllerCharts,
            children: [
              ExpensesByCategoryChart(),
              ExpensesByMonthChart(),
              TransactionChart(),
            ],
            scrollDirection: Axis.horizontal,
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 5.0),
          child: SmoothPageIndicator(
            controller: controllerCharts,
            count: 3,
            effect: WormEffect(
                dotHeight: 7,
                activeDotColor: Colors.blue,
                dotWidth: 7,
                dotColor: Colors.grey),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          height: 60,
          child: PageView(
            onPageChanged: (int index) async {
              loadMonthData(index);
            },
            children: dataWidgets,
            controller: controller,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: monthData.length,
            itemExtent: 60.0,
            itemBuilder: (BuildContext context, int index) {
              return CustomCard(monthData[index]);
            },
          ),
        ),
      ],
    );
  }
}

class CustomCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const CustomCard(this.data, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).backgroundColor,
        radius: 23.0,
        child: CircleAvatar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: Text(
            data['total'].toString(),
            style:
                TextStyle(color: Theme.of(context).textTheme.subtitle1.color),
          ),
          radius: 21.5,
        ),
      ),
      title: Text(
        data['name'] ?? '',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
            color: Theme.of(context).textTheme.subtitle1.color),
      ),
      trailing: Text(
        formatCurrency(context, data['amount']),
        style: TextStyle(
          fontSize: 18.0,
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
  String _value = 'w';
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
          DropdownMenuItem<String>(
            child: Text('Weekly'),
            value: 'w',
          ),
          DropdownMenuItem<String>(
            child: Text('Monthly'),
            value: 'm',
          ),
          DropdownMenuItem<String>(
            child: Text('Yearly'),
            value: 'y',
          ),
        ],
        onChanged: (String value) async {
          var prefs = await SharedPreferences.getInstance();
          prefs.setString('movementsFilter', value);
          setState(() {
            _value = value;
          });
        },
        value: _value,
      ),
    );
  }
}
