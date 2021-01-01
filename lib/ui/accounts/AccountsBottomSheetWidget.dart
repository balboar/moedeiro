import 'package:flutter/material.dart';
import 'package:moedeiro/dataModels/accounts.dart';
import 'package:moedeiro/models/mainModel.dart';
import 'package:provider/provider.dart';

class AccountBottomSheet extends StatefulWidget {
  Account activeAccount;

  AccountBottomSheet(this.activeAccount);
  @override
  State<StatefulWidget> createState() {
    return _AccountBottomSheetState();
  }
}

class _AccountBottomSheetState extends State<AccountBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Account activeAccount;

  @override
  void initState() {
    activeAccount = widget.activeAccount ?? Account(initialAmount: 0.00);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _submitForm(Function insertAccount) {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        insertAccount(activeAccount);
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
                TextFormField(
                  initialValue: activeAccount.name,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontSize: 20.0),
                    icon: GestureDetector(
                      child: Icon(Icons.account_balance_wallet),
                      onTap: null,
                    ),
                    labelText: 'Nombre de la cuenta',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    activeAccount.name = value;
                  },
                ),
                // TextFormField(
                //   initialValue: _accountData['ubicacion'] != null
                //       ? _accountData['ubicacion']
                //       : '',
                //   decoration: InputDecoration(
                //     icon: Icon(Icons.edit_attributes),
                //     labelText: 'Moneda',
                //   ),
                //   onSaved: (String value) {
                //     _accountData['ubicacion'] = value;
                //   },
                // ),
                TextFormField(
                  initialValue: activeAccount.initialAmount.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: Icon(Icons.monetization_on),
                    labelText: 'Cantidad Inicial',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a number';
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    activeAccount.initialAmount = double.parse(value);
                  },
                ),
                Padding(
                  child: Container(),
                  padding: EdgeInsets.all(10.0),
                ),
                Consumer<AccountModel>(
                  builder: (BuildContext context, AccountModel model,
                      Widget widget) {
                    return ButtonBar(
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
                            onPressed: () {
                              model.deleteAccount(activeAccount.uuid);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        OutlineButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          borderSide: BorderSide(
                              width: 1.0, color: Theme.of(context).accentColor),
                          color: Theme.of(context).dialogBackgroundColor,
                          textColor: Colors.white,
                          onPressed: () {
                            _submitForm(model.insertAccountIntoDb);
                          },
                          child: Text("Guardar"),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
