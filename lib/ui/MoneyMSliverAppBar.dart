import 'package:flutter/material.dart';

class MoneyMSliverOverlapAbsorberAppBar extends StatelessWidget {
  final String titleName;
  final List<Widget> actions;
  final Widget tabs;
  MoneyMSliverOverlapAbsorberAppBar(this.titleName,
      {this.actions, this.tabs, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverOverlapAbsorber(
      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      sliver: SliverSafeArea(
        top: false,
        sliver: SliverAppBar(
          title: Text(titleName),
          bottom: tabs,
          floating: false,
          snap: false,
          pinned: true,
          actions: actions,
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
          expandedHeight: 200,
        ),
      ),
    );
  }
}

class MoneyMSliverAppBar extends StatelessWidget {
  final String titleName;
  final List<Widget> actions;
  final Widget tabs;
  MoneyMSliverAppBar(this.titleName, {this.actions, this.tabs, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(titleName),
      bottom: tabs,
      floating: false,
      snap: false,
      pinned: true,
      actions: actions,
      expandedHeight: 200,
    );
  }
}
