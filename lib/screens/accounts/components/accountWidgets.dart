import 'dart:io';

import 'package:flutter/material.dart';
import 'package:moedeiro/models/accounts.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/screens/charts/components/accountCharts.dart';
import 'package:moedeiro/screens/charts/components/transactionsCharts.dart';
import 'package:moedeiro/util/utils.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:moedeiro/generated/l10n.dart';

class AccountCard extends StatefulWidget {
  final Account account;
  AccountCard({Key key, this.account}) : super(key: key);

  @override
  _AccountCardState createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  @override
  void initState() {
    // checkIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: ListTile(
        onTap: () {
          Provider.of<AccountModel>(context, listen: false).setActiveAccount =
              widget.account.uuid;
          Navigator.pushNamed(context, '/accountTransactionsPage',
              arguments: false);
        },
        leading: CircleAvatar(
          backgroundImage: widget.account.icon != null
              ? FileImage(
                  File(widget.account.icon),
                )
              : null,
          backgroundColor: Colors.transparent,
          radius: 20,
        ),
        title: Text(
          widget.account.name, //
          overflow: TextOverflow.clip,
          maxLines: 1,
        ),
        subtitle: Text(
          '${formatCurrency(context, widget.account.amount)}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(S.of(context).expensesMonth),
            Text(
              '${formatCurrency(context, widget.account.expensesMonth)}',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}

class AccountMiniCard extends StatefulWidget {
  final Account account;
  AccountMiniCard({Key key, this.account}) : super(key: key);

  @override
  _AccountMiniCardState createState() => _AccountMiniCardState();
}

class _AccountMiniCardState extends State<AccountMiniCard> {
  @override
  void initState() {
    // checkIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            color: Theme.of(context).cardTheme.color,
            child: Padding(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          widget.account.name, //
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                              fontSize: 17.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 5.0),
                        child: CircleAvatar(
                          backgroundImage: widget.account.icon != null
                              ? FileImage(
                                  File(widget.account.icon),
                                )
                              : null,
                          backgroundColor: Colors.transparent,
                          radius: 11,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Align(
                    child: Text(
                      '${formatCurrency(context, widget.account.amount)}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    alignment: Alignment.centerLeft,
                  )
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
      width: 170.0,
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
  final controller = PageController(viewportFraction: 1);

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
        title: Text(widget.activeAccount.name +
            ' ' +
            formatCurrency(context, widget.activeAccount.amount)),
        bottom: widget.tabs,
        floating: false,
        snap: false,
        pinned: true,
        actions: widget.actions,
        flexibleSpace: FlexibleSpaceBar(
          stretchModes: [StretchMode.blurBackground],
          collapseMode: CollapseMode.pin,
          background: Column(
            children: [
              Container(
                height: kToolbarHeight,
              ),
              Container(
                height: 180,
                margin:
                    EdgeInsets.only(left: 0.0, right: 0, top: 2.0, bottom: 2.0),
                child: PageView(
                  physics: BouncingScrollPhysics(),
                  controller: controller,
                  children: [
                    AccountBalanceChart(account: widget.activeAccount),
                    ExpensesByMonthChart(
                        accountUuid: widget.activeAccount.uuid),
                  ],
                  scrollDirection: Axis.horizontal,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 40.0),
                child: SmoothPageIndicator(
                  controller: controller,
                  count: 2,
                  effect: WormEffect(
                      dotHeight: 7,
                      activeDotColor: Colors.blue,
                      dotWidth: 7,
                      dotColor: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        expandedHeight: 270,
      ),
    );
  }
}