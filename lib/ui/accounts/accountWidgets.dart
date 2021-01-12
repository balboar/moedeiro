import 'package:flutter/material.dart';
import 'package:moedeiro/dataModels/accounts.dart';
import 'package:moedeiro/models/mainModel.dart';
import 'package:moedeiro/ui/accounts/AccountsBottomSheetWidget.dart';
import 'package:moedeiro/ui/charts/transactionsCharts.dart';
import 'package:moedeiro/ui/showBottomSheet.dart';
import 'package:moedeiro/util/utils.dart';
import 'package:provider/provider.dart';

class AccountCard extends StatefulWidget {
  Account account;
  AccountCard({Key key, this.account}) : super(key: key);

  @override
  _AccountCardState createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            color: Theme.of(context).cardTheme.color,
            child: Padding(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(widget.account.name, //
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).textTheme.bodyText1.color,
                                fontSize: 17.0)),
                      ),
                      GestureDetector(
                          child: Icon(Icons.more_vert),
                          onTap: () {
                            showCustomModalBottomSheet(
                                context, AccountBottomSheet(widget.account));
                          }),
                    ],
                  ),
                  Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          '${formatCurrency(context, widget.account.amount)}',
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Expenses month',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.subtitle2.color,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${formatCurrency(context, widget.account.expensesMonth)}',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              padding: EdgeInsets.all(10.0),
            ),
          ),
          onTap: () {
            Provider.of<AccountModel>(context, listen: false).setActiveAccount =
                widget.account.uuid;
            Navigator.pushNamed(context, '/accountTransactionsPage',
                arguments: false);
          }),
      width: 160.0,
    );
  }
}

class AccountPageAppBar extends StatefulWidget {
  final Account activeAccount;
  final List<Widget> actions;
  final Widget tabs;

  AccountPageAppBar(this.activeAccount, {this.actions, this.tabs, Key key})
      : super(key: key);

  @override
  _AccountPageAppBarState createState() => _AccountPageAppBarState();
}

class _AccountPageAppBarState extends State<AccountPageAppBar> {
  double height = 200;

  ScrollController _scrollController;

  bool lastStatus = true;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  bool get _isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (height - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    return SliverOverlapAbsorber(
      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      sliver: SliverAppBar(
        centerTitle: true,
        title: Text(widget.activeAccount.name),

        bottom: widget.tabs,
        floating: false,
        pinned: true,
        actions: widget.actions,

        flexibleSpace: FlexibleSpaceBar(
          stretchModes: [StretchMode.blurBackground],
          collapseMode: CollapseMode.pin,
          background: Column(children: [
            Container(
              height: kToolbarHeight + 20,
            ),
            Text(
              formatCurrency(context, widget.activeAccount.amount),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Theme.of(context).textTheme.headline5.fontSize),
            ),
            Container(
              child:
                  ExpensesByMonthChart(accountUuid: widget.activeAccount.uuid),
              height: 140,
            )
            // BarChartSample3(),
            // Container(
            //   height: 1,
            // ),
          ]),
        ),

        // FlexibleSpaceBar(
        //   stretchModes: [StretchMode.blurBackground],
        //   collapseMode: CollapseMode.pin,
        //   background: Column(children: [
        //     Container(
        //       height: 75,
        //     ),
        //     Text(
        //       formatCurrency(context, widget.activeAccount.amount),
        //       style: TextStyle(
        //           fontWeight: FontWeight.bold,
        //           fontSize: Theme.of(context).textTheme.headline5.fontSize),
        //     ),
        //     Container(
        //       child: ExpensesByMonthChart(
        //           accountUuid: widget.activeAccount.uuid),
        //       height: 140,
        //     )
        //     // BarChartSample3(),
        //     // Container(
        //     //   height: 1,
        //     // ),
        //   ]),
        // ),

        // flexibleSpace: FlexibleSpaceBar(
        //   background: Container(
        //     decoration: BoxDecoration(
        //       gradient: LinearGradient(
        //           begin: Alignment.topRight,
        //           end: Alignment.bottomLeft,
        //           stops: [
        //             0.1,
        //             0.4,
        //             0.7,
        //             0.9
        //           ],
        //           colors: [
        //             Colors.yellow,
        //             Colors.red,
        //             Colors.indigo,
        //             Colors.teal
        //           ]),
        //     ),
        //   ),
        // ),
        expandedHeight: 270,
      ),
    );
  }
}
