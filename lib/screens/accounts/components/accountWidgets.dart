import 'dart:io';
import 'package:flutter/material.dart';
import 'package:moedeiro/models/accounts.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/screens/accounts/components/accountCharts.dart';
import 'package:moedeiro/screens/summary/components/transactionsCharts.dart';
import 'package:moedeiro/util/utils.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:moedeiro/generated/l10n.dart';

class AccountCard extends StatefulWidget {
  final Account? account;
  AccountCard({Key? key, this.account}) : super(key: key);

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
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: ListTile(
        onTap: () {
          Provider.of<AccountModel>(context, listen: false).setActiveAccount =
              widget.account!.uuid!;
          Navigator.pushNamed(context, '/accountTransactionsPage',
              arguments: false);
        },
        // leading: CircleAvatar(
        //   // backgroundImage: widget.account!.icon != null
        //   //     ? FileImage(File(widget.account!.icon!), scale: 0.9)
        //   //     : null,
        //   backgroundColor:
        //       widget.account!.icon != null ? Colors.transparent : Colors.grey,
        //   radius: 20,
        // ),

        leading: CircleAvatar(
          backgroundImage: widget.account!.icon != null
              ? FileImage(
                  File(
                    widget.account!.icon!,
                  ),
                  scale: 0.9)
              : null,
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          child: widget.account!.icon != null
              ? null
              : ClipOval(
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
          radius: 20,
        ),
        title: Text(
          widget.account!.name!, //
          overflow: TextOverflow.clip,
          maxLines: 1,
        ),
        subtitle: Text(
          '${formatCurrency(context, widget.account!.amount!)}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(S.of(context).expensesMonth),
            Text(
              '${formatCurrency(context, widget.account!.expensesMonth!)}',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}

class AccountMiniCard extends StatefulWidget {
  final Account? account;
  AccountMiniCard({Key? key, this.account}) : super(key: key);

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
                          widget.account!.name!, //
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                              fontSize: 17.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 5.0),
                        child: CircleAvatar(
                          backgroundImage: widget.account!.icon != null
                              ? FileImage(File(widget.account!.icon!),
                                  scale: 0.9)
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
                      '${formatCurrency(context, widget.account!.amount!)}',
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
                widget.account!.uuid!;
            Navigator.pushNamed(context, '/accountTransactionsPage',
                arguments: false);
          }),
      width: 170.0,
    );
  }
}

class AccountPageAppBar extends StatefulWidget {
  final Account? activeAccount;
  final List<Widget>? actions;
  final Widget? tabs;

  AccountPageAppBar(this.activeAccount, {this.actions, this.tabs, Key? key})
      : super(key: key);

  @override
  _AccountPageAppBarState createState() => _AccountPageAppBarState();
}

class _AccountPageAppBarState extends State<AccountPageAppBar> {
  double height = 200;
  final controller = PageController(viewportFraction: 1);

  late ScrollController _scrollController;

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
        bottom: widget.tabs as PreferredSizeWidget?,
        floating: false,
        snap: false,
        pinned: true,
        actions: widget.actions,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          titlePadding: EdgeInsets.only(bottom: 65),
          title: Text(widget.activeAccount!.name! +
              ' ' +
              formatCurrency(context, widget.activeAccount!.amount!)),
        ),
        expandedHeight: MediaQuery.of(context).size.height * 0.30,
      ),
    );
  }
}

 // SliverAppBar(
  //           flexibleSpace: FlexibleSpaceBar(
  //             centerTitle: true,
  //             title: Text(S.of(context).accountsTitle),
  //           ),
  //           floating: false,
  //           snap: false,
  //           pinned: true,
  //           expandedHeight: MediaQuery.of(context).size.height * 0.30,
  //         ),
