import 'package:flutter/material.dart';

class TransfersSliverList extends StatefulWidget {
  TransfersSliverList({Key key}) : super(key: key);

  @override
  _TransfersSliverListState createState() => _TransfersSliverListState();
}

class _TransfersSliverListState extends State<TransfersSliverList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
          return CustomScrollView(
            key: PageStorageKey<String>('Transfers'),
            slivers: <Widget>[
              SliverOverlapInjector(
                // This is the flip side of the SliverOverlapAbsorber above.
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: SliverFixedExtentList(
                  itemExtent: 60.0,
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      // This builder is called for each child.
                      // In this example, we just number each list item.
                      return ListTile(
                        leading: Text('04/5/2020'),
                        title: Text('Item #$index'),
                        subtitle: Text('pel'),
                        trailing: Text('50.04€'),
                        onTap: () => {},
                      );
                    },
                    childCount: 30,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
