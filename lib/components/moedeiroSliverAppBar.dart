import 'package:flutter/material.dart';
import 'package:moedeiro/generated/l10n.dart';

class MoedeiroSliverOverlapAbsorberAppBar extends StatefulWidget {
  final String titleName;
  final List<Widget>? actions;
  final Widget? tabs;
  final Widget? flexibleSpace;

  MoedeiroSliverOverlapAbsorberAppBar(this.titleName,
      {this.actions, this.tabs, this.flexibleSpace, Key? key})
      : super(key: key);

  @override
  _MoedeiroSliverOverlapAbsorberAppBarState createState() =>
      _MoedeiroSliverOverlapAbsorberAppBarState();
}

class _MoedeiroSliverOverlapAbsorberAppBarState
    extends State<MoedeiroSliverOverlapAbsorberAppBar> {
  double height = 200;

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
      sliver: SliverSafeArea(
        top: false,
        sliver: SliverAppBar(
          title: Text(widget.titleName),
          bottom: widget.tabs as PreferredSizeWidget?,
          floating: false,
          snap: false,
          pinned: true,
          centerTitle: true,
          flexibleSpace: widget.flexibleSpace,
          actions: widget.actions,
          expandedHeight: MediaQuery.of(context).size.height / 2,
        ),
      ),
    );
  }
}

class MoedeiroSliverAppBar extends StatelessWidget {
  final String titleName;
  final List<Widget>? actions;
  final Widget? tabs;
  final Widget? flexibleSpace;
  MoedeiroSliverAppBar(this.titleName,
      {this.actions, this.tabs, this.flexibleSpace, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(titleName),
      bottom: tabs as PreferredSizeWidget?,
      floating: false,
      snap: false,
      pinned: true,
      actions: actions,
      flexibleSpace: flexibleSpace,
      expandedHeight: MediaQuery.of(context).size.height / 2,
    );
  }
}

class SearchBar extends StatefulWidget {
  SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {

  bool isSearchClicked = true;
  final TextEditingController _filter = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      titlePadding: EdgeInsets.only(bottom: 10, left: 15, right: 15),
      centerTitle: true,
      title: Container(
        padding: EdgeInsets.only(bottom: 2),
        constraints: BoxConstraints(minHeight: 40, maxHeight: 40),
        child: TextField(
          onChanged: (String value) {},
          controller: _filter,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: S.of(context).search,
            hintStyle: TextStyle(
              color: Color(0xffC4C6CC),
              fontSize: 14.0,
            ),
            prefixIcon: Icon(
              Icons.search,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(style: BorderStyle.solid, width: 1.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                  color: Color(0xffF0F1F5),
                  style: BorderStyle.solid,
                  width: 1.0),
            ),
          ),
        ),
      ),
    );
  }
}
