import 'package:flutter/material.dart';

class MoedeiroSliverList extends StatelessWidget {
  final String title;
  final Widget list;
  MoedeiroSliverList(this.title, this.list, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
          return CustomScrollView(
            key: PageStorageKey<String>(title),
            slivers: <Widget>[
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: list,
              ),
            ],
          );
        },
      ),
    );
  }
}
