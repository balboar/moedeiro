import 'package:flutter/material.dart';
import 'package:moedeiro/models/mainModel.dart';
import 'package:moedeiro/ui/moedeiroSliverList.dart';
import 'package:moedeiro/ui/moedeiroSliverAppBar.dart';
import 'package:moedeiro/ui/categories/CategoryBottomSheetWidget.dart';
import 'package:moedeiro/ui/moedeiro_widgets.dart';
import 'package:moedeiro/ui/showBottomSheet.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatelessWidget {
  String data;
  CategoriesPage({this.data});

  PreferredSizeWidget buildTabs() {
    return TabBar(tabs: [
      Tab(
        text: 'Income',
      ),
      Tab(
        text: 'Expenses',
      ),
    ]);
  }

  Widget buildIncomeList() {
    return Consumer<CategoryModel>(
      builder: (BuildContext context, CategoryModel model, Widget child) {
        return model.incomecategories.length == 0
            ? SliverToBoxAdapter(
                child: NoDataWidgetVertical(),
              )
            : SliverFixedExtentList(
                itemExtent: 60.0,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
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
                          showCustomModalBottomSheet(
                              context,
                              CategoryBottomSheet(
                                  model.incomecategories[index]))
                      },
                    );
                  },
                  childCount: model.incomecategories.length,
                ),
              );
      },
    );
  }

  Widget buildExpensesList() {
    return Consumer<CategoryModel>(
      builder: (BuildContext context, CategoryModel model, Widget child) {
        return model.expenseCategories.length == 0
            ? SliverToBoxAdapter(
                child: NoDataWidgetVertical(),
              )
            : SliverFixedExtentList(
                itemExtent: 60.0,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
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
                          showCustomModalBottomSheet(
                              context,
                              CategoryBottomSheet(
                                  model.expenseCategories[index]))
                      },
                    );
                  },
                  childCount: model.expenseCategories.length,
                ),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        initialIndex: 1,
        length: 2, // This is the number of tabs.
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              MoedeiroSliverOverlapAbsorberAppBar(
                'Categories',
                tabs: buildTabs(),
              )
            ];
          },
          body: TabBarView(
              // These are the contents of the tab views, below the tabs.
              children: <Widget>[
                MoedeiroSliverList('Income', buildIncomeList()),
                MoedeiroSliverList('Expenses', buildExpensesList()),
              ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_outlined),
        onPressed: () {
          showCustomModalBottomSheet(context, CategoryBottomSheet(null));
        },
      ),
    );
  }
}
