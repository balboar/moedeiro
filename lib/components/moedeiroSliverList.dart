import 'package:flutter/material.dart';

class MoedeiroSliverList extends StatelessWidget {
  final String title;
  final Widget list;
  MoedeiroSliverList(this.title, this.list, {Key? key}) : super(key: key);

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
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10, top: 0.0, bottom: 10.0),
                sliver: list,
              ),
            ],
          );
        },
      ),
    );
  }
}
