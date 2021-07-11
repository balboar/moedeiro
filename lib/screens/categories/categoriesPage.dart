import 'package:flutter/material.dart';
import 'package:moedeiro/components/moedeiroWidgets.dart';
import 'package:moedeiro/components/showBottomSheet.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/screens/categories/components/CategoryBottomSheetWidget.dart';
import 'package:provider/provider.dart';
import 'package:moedeiro/generated/l10n.dart';

class CategoriesPage extends StatelessWidget {
  final String? data;
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
      builder: (BuildContext context, CategoryModel model, Widget? child) {
        return model.incomecategories!.length == 0
            ? NoDataWidgetVertical()
            : ListView.builder(
                itemExtent: 60.0,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      model.incomecategories![index].name!,
                    ),
                    onTap: () => {
                      if (data == 'newTransaction')
                        Navigator.pop(context, {
                          'uuid': model.incomecategories![index].uuid,
                          'name': model.incomecategories![index].name,
                          'type': model.incomecategories![index].type,
                          'defaultAccount':
                              model.incomecategories![index].defaultAccount,
                        })
                      else
                        Navigator.pushNamed(context, '/categoryPage',
                            arguments: model.incomecategories![index].uuid)
                    },
                  );
                },
                itemCount: model.incomecategories!.length,
              );
      },
    );
  }

  Widget buildExpensesList() {
    return Consumer<CategoryModel>(
      builder: (BuildContext context, CategoryModel model, Widget? child) {
        return model.expenseCategories!.length == 0
            ? NoDataWidgetVertical()
            : ListView.builder(
                itemExtent: 60.0,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      model.expenseCategories![index].name!,
                    ),
                    // trailing: Icon(Icons.edit_outlined),
                    onTap: () => {
                      if (data == 'newTransaction')
                        Navigator.pop(context, {
                          'uuid': model.expenseCategories![index].uuid,
                          'name': model.expenseCategories![index].name,
                          'type': model.expenseCategories![index].type,
                          'defaultAccount':
                              model.expenseCategories![index].defaultAccount,
                        })
                      else
                        Navigator.pushNamed(context, '/categoryPage',
                            arguments: model.expenseCategories![index].uuid)
                    },
                  );
                },
                itemCount: model.expenseCategories!.length,
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
          title: Text(
            S.of(context).categoryTitle,
          ),
          bottom: buildTabs(context) as PreferredSizeWidget?,
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
            showCustomModalBottomSheet(
              context,
              CategoryBottomSheet(null, true),
            );
          },
        ),
      ),
    );
  }
}
