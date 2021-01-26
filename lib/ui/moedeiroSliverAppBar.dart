import 'package:flutter/material.dart';

class MoedeiroSliverOverlapAbsorberAppBar extends StatefulWidget {
  final String titleName;
  final List<Widget> actions;
  final Widget tabs;

  MoedeiroSliverOverlapAbsorberAppBar(this.titleName,
      {this.actions, this.tabs, Key key})
      : super(key: key);

  @override
  _MoedeiroSliverOverlapAbsorberAppBarState createState() =>
      _MoedeiroSliverOverlapAbsorberAppBarState();
}

class _MoedeiroSliverOverlapAbsorberAppBarState
    extends State<MoedeiroSliverOverlapAbsorberAppBar> {
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
      sliver: SliverSafeArea(
        top: false,
        sliver: SliverAppBar(
          title: Text(widget.titleName),
          bottom: widget.tabs,
          floating: false,
          snap: false,
          pinned: true,
          actions: widget.actions,
          expandedHeight: 200,
        ),
      ),
    );
  }
}

class MoedeiroSliverAppBar extends StatelessWidget {
  final String titleName;
  final List<Widget> actions;
  final Widget tabs;
  MoedeiroSliverAppBar(this.titleName, {this.actions, this.tabs, Key key})
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
