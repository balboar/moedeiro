import 'package:flutter/material.dart';
import 'package:moedeiro/components/showBottomSheet.dart';
import 'package:moedeiro/models/recurrences.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/screens/recurrences/components/recurrenceBottomSheet.dart';
import 'package:moedeiro/screens/recurrences/components/recurrenceWidgets.dart';
import 'package:provider/provider.dart';
import 'package:moedeiro/generated/l10n.dart';

class RecurrencesPage extends StatefulWidget {
  RecurrencesPage({Key? key}) : super(key: key);

  @override
  _RecurrencesPageState createState() => _RecurrencesPageState();
}

class _RecurrencesPageState extends State<RecurrencesPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controller = PageController(viewportFraction: 1);

  Widget flexibleSpace() {
    return FlexibleSpaceBar(
      stretchModes: [StretchMode.blurBackground],
      collapseMode: CollapseMode.pin,
      background: Column(
        children: [
          Container(
            height: kToolbarHeight + 20,
          ),
          Container(
            height:
                (MediaQuery.of(context).size.height / 2) - kToolbarHeight - 50,
            margin: EdgeInsets.only(left: 0.0, right: 0, top: 2.0, bottom: 2.0),
          ),
        ],
      ),
    );
  }

  Widget _buildRecurrencesList() {
    return Consumer<RecurrenceModel>(
      builder: (BuildContext context, RecurrenceModel model, Widget? child) {
        if (model.recurrences.length == 0) {
          return SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50.0,
                ),
                Image(
                  image: AssetImage('lib/assets/icons/not-found.png'),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  S.of(context).noDataLabel,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        } else {
          return SliverPadding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10, top: 0.0, bottom: 10.0),
            sliver: SliverFixedExtentList(
              itemExtent: 120.0,
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return RecurrenceCard(
                    model.recurrences[index],
                    key: Key(model.recurrences[index].uuid!),
                  );
                },
                childCount: model.recurrences.length,
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: EdgeInsets.symmetric(horizontal: 10),
              title: Text(S.of(context).recurrences),
            ),
            floating: false,
            snap: false,
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.30,
          ),
          _buildRecurrencesList(),
        ],
      ),
      key: _formKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCustomModalBottomSheet(
              context,
              RecurrenceBottomSheet(Recurrence(
                  amount: 0, timestamp: DateTime.now().millisecondsSinceEpoch)),
              enableDrag: false);
        },
        child: Icon(Icons.add_outlined),
      ),
    );
  }
}
