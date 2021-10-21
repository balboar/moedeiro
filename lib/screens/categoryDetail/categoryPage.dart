import 'package:flutter/material.dart';
import 'package:moedeiro/components/moedeiroWidgets.dart';
import 'package:moedeiro/components/showBottomSheet.dart';
import 'package:moedeiro/models/categories.dart';
import 'package:moedeiro/models/transaction.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/screens/categories/components/CategoryBottomSheetWidget.dart';
import 'package:moedeiro/screens/movements/components/transactionWidgets.dart';
import 'package:provider/provider.dart';
import 'package:moedeiro/generated/l10n.dart';

class CategoryPage extends StatefulWidget {
  final String? categoryUuid;

  const CategoryPage({Key? key, this.categoryUuid}) : super(key: key);
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Categori? category;
  bool emptyCategory = false;

  @override
  void initState() {
    if (widget.categoryUuid != null)
      category = Provider.of<CategoryModel>(context, listen: false)
          .getCategory(widget.categoryUuid!);
    super.initState();
  }

  List<Widget> buildActions() {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.edit),
        tooltip: S.of(context).account,
        onPressed: () {
          showCustomModalBottomSheet(
            context,
            CategoryBottomSheet(category, emptyCategory),
          );
        },
      ),
    ].toList();
  }

  Widget buildTransactionsList() {
    return Consumer<TransactionModel>(
        builder: (BuildContext context, TransactionModel model, Widget? child) {
      {
        List<Transaction> accountTransactions =
            model.getCategoryTransactions(widget.categoryUuid);
        emptyCategory = accountTransactions.length == 0;
        return accountTransactions.length == 0
            ? SliverToBoxAdapter(
                child: NoDataWidgetVertical(),
              )
            : SliverFixedExtentList(
                itemExtent: 80.0,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    Transaction _transaction = accountTransactions[index];
                    return TransactionTile(_transaction);
                  },
                  childCount: accountTransactions.length,
                ),
              );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _formKey,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: null,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(bottom: 10, left: 20),
              title: Text(category!.name!),
            ),
            actions: buildActions(),
            floating: false,
            snap: false,
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.30,
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10, top: 0.0, bottom: 10.0),
            sliver: buildTransactionsList(),
          ),
        ],
      ),
    );
  }
}
