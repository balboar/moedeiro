import 'package:flutter/material.dart';
import 'package:moedeiro/models/mainModel.dart';
import 'package:moedeiro/ui/moedeiroSliverList.dart';
import 'package:moedeiro/ui/moedeiroSliverAppBar.dart';
import 'package:moedeiro/ui/categories/CategoryBottomSheetWidget.dart';
import 'package:moedeiro/ui/moedeiroWidgets.dart';
import 'package:moedeiro/ui/showBottomSheet.dart';
import 'package:provider/provider.dart';
import 'package:moedeiro/generated/l10n.dart';

class CategoriesPage extends StatelessWidget {
  String data;
  CategoriesPage({this.data});

  Widget buildTabs(BuildContext context) {
    return TabBar(
      tabs: [
        Tab(
          text: S.of(context).incomes,
        ),
        Tab(
          text: S.of(context).expenses,
        ),
      ],
    );
  }

  Widget buildIncomeList() {
    return Consumer<CategoryModel>(
      builder: (BuildContext context, CategoryModel model, Widget child) {
        return model.incomecategories.length == 0
            ? NoDataWidgetVertical()
            : ListView.builder(
                itemExtent: 60.0,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      model.incomecategories[index].name,
                    ),
                    onTap: () => {
                      if (data == 'newTransaction')
                        Navigator.pop(context, {
                          'uuid': model.incomecategories[index].uuid,
                          'name': model.incomecategories[index].name,
                          'type': model.incomecategories[index].type
                        })
                      else
                        showCustomModalBottomSheet(context,
                            CategoryBottomSheet(model.incomecategories[index]))
                    },
                  );
                },
                itemCount: model.incomecategories.length,
              );
      },
    );
  }

  Widget buildExpensesList() {
    return Consumer<CategoryModel>(
      builder: (BuildContext context, CategoryModel model, Widget child) {
        return model.expenseCategories.length == 0
            ? NoDataWidgetVertical()
            : ListView.builder(
                itemExtent: 60.0,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      model.expenseCategories[index].name,
                    ),
                    onTap: () => {
                      if (data == 'newTransaction')
                        Navigator.pop(context, {
                          'uuid': model.expenseCategories[index].uuid,
                          'name': model.expenseCategories[index].name,
                          'type': model.expenseCategories[index].type
                        })
                      else
                        showCustomModalBottomSheet(context,
                            CategoryBottomSheet(model.expenseCategories[index]))
                    },
                  );
                },
                itemCount: model.expenseCategories.length,
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2, // This is the number of tabs.
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).categoryTitle),
          bottom: buildTabs(context),
        ),
        body: TabBarView(
            // These are the contents of the tab views, below the tabs.
            children: <Widget>[
              buildIncomeList(),
              buildExpensesList(),
            ]),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_outlined),
          onPressed: () {
            showCustomModalBottomSheet(context, CategoryBottomSheet(null));
          },
        ),
      ),
    );
  }
}
