import 'package:flutter/material.dart';
import 'package:moedeiro/dataModels/categories.dart';
import 'package:moedeiro/models/mainModel.dart';
import 'package:moedeiro/ui/dialogs/confirmDeleteDialog.dart';
import 'package:provider/provider.dart';

enum CategoryType { income, expense }

class CategoryBottomSheet extends StatefulWidget {
  Categori category;

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
  double space = 10.0;

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
                      prefixIcon: Icon(Icons.analytics_outlined),
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(fontSize: 20.0),
                      labelText: 'Name',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      category.name = value;
                    },
                  ),
                  RadioListTile(
                    title: const Text('Income'),
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
                    title: const Text('Expense'),
                    value: CategoryType.expense,
                    groupValue: _categoryType,
                    onChanged: (CategoryType value) {
                      setState(() {
                        _categoryType = value;
                        category.type = 'E';
                      });
                    },
                  ),
                  Padding(
                    child: Container(),
                    padding: EdgeInsets.all(5.0),
                  ),
                  Consumer<CategoryModel>(builder: (BuildContext context,
                      CategoryModel model, Widget widget) {
                    return ButtonBar(
                      buttonHeight: 40.0,
                      buttonMinWidth: 140.0,
                      alignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          child: FlatButton(
                            child: Text(
                              'Eliminar',
                              style: TextStyle(
                                color: Colors.grey[500],
                              ),
                            ),
                            onPressed: () {
                              if (category.uuid != null) {
                                _showMyDialog().then((value) {
                                  if (value) {
                                    //   model.delete(_data['uuid']);
                                    Navigator.pop(context);
                                  }
                                });
                              }
                            },
                          ),
                        ),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(217, 81, 157, 1),
                                Color.fromRGBO(237, 135, 112, 1)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          child: FlatButton(
                            child: Text(
                              'Guardar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              _submitForm(model.insertCategoryIntoDb);
                            },
                          ),
                        ),
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
