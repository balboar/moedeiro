import 'package:flutter/material.dart';
import 'package:moedeiro/components/buttons.dart';
import 'package:moedeiro/components/dialogs/InfoDialog.dart';
import 'package:moedeiro/components/dialogs/confirmDeleteDialog.dart';
import 'package:moedeiro/components/showBottomSheet.dart';
import 'package:moedeiro/generated/l10n.dart';
import 'package:moedeiro/models/categories.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/screens/accounts/components/AccountsListBottonSheet.dart';
import 'package:provider/provider.dart';

enum CategoryType { income, expense }

class CategoryBottomSheet extends StatefulWidget {
  final Categori? category;
  final bool emptyCategory;

  CategoryBottomSheet(this.category, this.emptyCategory);
  @override
  State<StatefulWidget> createState() {
    return CategoryBottomSheetState();
  }
}

class CategoryBottomSheetState extends State<CategoryBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _accountController = TextEditingController();
  late Categori category;
  CategoryType? _categoryType = CategoryType.income;
  double space = 7.0;

  @override
  void initState() {
    category = widget.category ?? Categori(type: 'E');
    if (category.type == 'E') _categoryType = CategoryType.expense;
    _accountController.text = category.accountName ?? '';
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.

    _accountController.dispose();
    super.dispose();
  }

  Future<bool?> _showMyDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return ComfirmDeleteDialog(
          '😮',
          title: S.of(context).deleteCategory,
          subtitle: S.of(context).deleteCategorytDescription,
        );
      },
    );
  }

  Future<bool?> _showCategoryNotEmptyDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return InfoDialog(
          icon: Icons.error_outline,
          title: S.of(context).deleteCategoryError,
          subtitle: S.of(context).deleteCategorytDescriptionError,
        );
      },
    );
  }

  void deleteCategory(CategoryModel model) {
    if (!widget.emptyCategory)
      _showCategoryNotEmptyDialog().then((value) => Navigator.pop(context));
    else if (category.uuid != null) {
      _showMyDialog().then((value) {
        if (value!) {
          model.delete(category.uuid!);
          Navigator.pop(context);
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void _submitForm(Function save) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        save(category);
        Navigator.pop(context);
      }
    }

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.only(
                right: 20.0,
                left: 20,
                top: 5,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: space,
                ),
                TextFormField(
                  initialValue: category.name,
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    prefixIcon: Icon(Icons.dashboard_outlined),
                    labelStyle: TextStyle(fontSize: 20.0),
                    labelText: S.of(context).name,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return S.of(context).nameError;
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    category.name = value;
                  },
                ),
                TextFormField(
                  readOnly: true,
                  controller: _accountController,
                  decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      prefixIcon: Icon(Icons.account_balance_wallet),
                      labelStyle: TextStyle(fontSize: 20.0),
                      labelText: S.of(context).defaultAccount),
                  validator: (value) {
                    return null;
                  },
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());

                    showCustomModalBottomSheet(
                      context,
                      AccountListBottomSheet(),
                      isScrollControlled: true,
                    ).then(
                      (value) {
                        if (value != null) {
                          category.defaultAccount = value;
                          _accountController.text =
                              Provider.of<AccountModel>(context, listen: false)
                                  .getAccountName(value);
                          category.accountName = _accountController.text;
                        }
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                RadioListTile(
                  title: Text(S.of(context).income),
                  value: CategoryType.income,
                  groupValue: _categoryType,
                  onChanged: (CategoryType? value) {
                    setState(() {
                      _categoryType = value;
                      category.type = 'I';
                    });
                  },
                ),
                RadioListTile(
                  title: Text(S.of(context).expense),
                  value: CategoryType.expense,
                  groupValue: _categoryType,
                  onChanged: (CategoryType? value) {
                    setState(() {
                      _categoryType = value;
                      category.type = 'E';
                    });
                  },
                ),
                Consumer<CategoryModel>(builder: (BuildContext context,
                    CategoryModel model, Widget? widget) {
                  return ButtonBar(
                    buttonHeight: 40.0,
                    buttonMinWidth: 140.0,
                    alignment: MainAxisAlignment.spaceAround,
                    children: [
                      Visibility(
                        child: DeleteButton(() {
                          deleteCategory(model);
                        }),
                        visible: category.uuid != null,
                      ),
                      SaveButton(() {
                        _submitForm(model.insertCategoryIntoDb);
                      }),
                    ],
                  );
                }),
              ],
            )),
      ),
    );
  }
}
