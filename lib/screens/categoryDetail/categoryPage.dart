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
  final String categoryUuid;

  const CategoryPage({Key key, this.categoryUuid}) : super(key: key);
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Categori category;

  @override
  void initState() {
    if (widget.categoryUuid != null)
      category = Provider.of<CategoryModel>(context, listen: false)
          .getCategory(widget.categoryUuid);
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
            CategoryBottomSheet(category),
          );
        },
      ),
    ].toList();
  }

  Widget buildTransactionsList() {
    return Consumer<TransactionModel>(
        builder: (BuildContext context, TransactionModel model, Widget child) {
      {
        List<Transaction> accountTransactions =
            model.getCategoryTransactions(widget.categoryUuid);
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
            title: Text(category.name),
            actions: buildActions(),
            floating: false,
            expandedHeight: MediaQuery.of(context).size.height * 0.30,
          ),
          buildTransactionsList()
        ],
      ),
    );
  }
}
