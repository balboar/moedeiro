import 'dart:io';

import 'package:flutter/material.dart';
import 'package:moedeiro/dataModels/accounts.dart';
import 'package:moedeiro/models/mainModel.dart';
import 'package:moedeiro/ui/accounts/AccountsBottomSheetWidget.dart';
import 'package:moedeiro/ui/charts/accountCharts.dart';
import 'package:moedeiro/ui/charts/transactionsCharts.dart';
import 'package:moedeiro/ui/showBottomSheet.dart';
import 'package:moedeiro/util/utils.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AccountCard extends StatefulWidget {
  Account account;
  double avatarSize = 10.0;
  AccountCard({Key key, this.account, this.avatarSize}) : super(key: key);

  @override
  _AccountCardState createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  @override
  void initState() {
    // initStorage();
    super.initState();
  }

  // void initStorage() async {
  //   if (widget.account.icon != null) {
  //     var file = await File(widget.account.icon).exists();
  //     print(file);
  //     if (!file) widget.account.icon = null;
  //   }
  // }

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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 5.0),
                        child: CircleAvatar(
                          backgroundImage: widget.account.icon != null
                              ? FileImage(
                                  File(widget.account.icon),
                                )
                              : null,
                          backgroundColor: Colors.transparent,
                          radius: widget.avatarSize,
                        ),
                      ),
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
              padding: EdgeInsets.all(7.0),
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
              // Text(
              //   formatCurrency(context, widget.activeAccount.amount),
              //   style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //       fontSize: Theme.of(context).textTheme.headline5.fontSize),
              // ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: 10.0, right: 10, top: 2.0, bottom: 2.0),
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
