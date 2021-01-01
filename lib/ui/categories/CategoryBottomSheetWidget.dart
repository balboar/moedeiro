import 'package:flutter/material.dart';
import 'package:moedeiro/dataModels/categories.dart';
import 'package:moedeiro/models/mainModel.dart';
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

  @override
  void initState() {
    category = widget.category ?? Categori(type: 'E');
    if (category.type == 'E') _categoryType = CategoryType.expense;
    super.initState();
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
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Category',
                  style: TextStyle(fontSize: 20.0),
                ),
                Divider(
                  thickness: 2.0,
                  color: Theme.of(context).accentColor,
                ),
                TextFormField(
                  initialValue: category.name,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontSize: 20.0),
                    icon: GestureDetector(
                      child: Icon(Icons.category_outlined),
                      onTap: null,
                    ),
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
                  padding: EdgeInsets.all(10.0),
                ),
                ButtonBar(
                  buttonHeight: 50.0,
                  buttonMinWidth: 140.0,
                  alignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        gradient: LinearGradient(
                          colors: [Colors.red, Colors.red[300]],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: FlatButton(
                        child: new Text('Eliminar'),
                        onPressed: () {},
                      ),
                    ),
                    Consumer<CategoryModel>(builder: (BuildContext context,
                        CategoryModel model, Widget widget) {
                      return OutlineButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        borderSide: BorderSide(
                            width: 1.0, color: Theme.of(context).accentColor),
                        color: Theme.of(context).dialogBackgroundColor,
                        textColor: Colors.white,
                        onPressed: () {
                          _submitForm(model.insertCategoryIntoDb);
                        },
                        child: Text("Guardar"),
                      );
                    }),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
