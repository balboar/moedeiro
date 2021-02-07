import 'package:flutter/material.dart';
import 'package:moedeiro/components/buttons.dart';
import 'package:moedeiro/components/dialogs/confirmDeleteDialog.dart';
import 'package:moedeiro/generated/l10n.dart';
import 'package:moedeiro/models/categories.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:provider/provider.dart';

enum CategoryType { income, expense }

class CategoryBottomSheet extends StatefulWidget {
  final Categori category;

  CategoryBottomSheet(this.category);
  @override
  State<StatefulWidget> createState() {
    return CategoryBottomSheetState();
  }
}

class CategoryBottomSheetState extends State<CategoryBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Categori category;
  CategoryType _categoryType = CategoryType.income;
  double space = 7.0;

  @override
  void initState() {
    category = widget.category ?? Categori(type: 'E');
    if (category.type == 'E') _categoryType = CategoryType.expense;
    super.initState();
  }

  Future<bool> _showMyDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return ComfirmDeleteDialog();
      },
    );
  }

  void deleteCategory(CategoryModel model) {
    if (category.uuid != null) {
      _showMyDialog().then((value) {
        if (value) {
          //   model.delete(_data['uuid']);
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void _submitForm(Function save) {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        save(category);
        Navigator.pop(context);
      }
    }

    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _formKey,
          child: Padding(
              padding:
                  EdgeInsets.only(right: 20.0, left: 20, top: 5, bottom: 5.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: space,
                  ),
                  TextFormField(
                    initialValue: category.name,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.dashboard_outlined),
                      labelStyle: TextStyle(fontSize: 20.0),
                      labelText: S.of(context).name,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return S.of(context).nameError;
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      category.name = value;
                    },
                  ),
                  RadioListTile(
                    title: Text(S.of(context).income),
                    value: CategoryType.income,
                    groupValue: _categoryType,
                    onChanged: (CategoryType value) {
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
                    onChanged: (CategoryType value) {
                      setState(() {
                        _categoryType = value;
                        category.type = 'E';
                      });
                    },
                  ),
                  Consumer<CategoryModel>(builder: (BuildContext context,
                      CategoryModel model, Widget widget) {
                    return ButtonBar(
                      buttonHeight: 40.0,
                      buttonMinWidth: 140.0,
                      alignment: MainAxisAlignment.center,
                      children: [
                        DeleteButton(() {
                          deleteCategory(model);
                        }),
                        SaveButton(() {
                          _submitForm(model.insertCategoryIntoDb);
                        }),
                      ],
                    );
                  }),
                ],
              )),
        ),
      ),
    );
  }
}
