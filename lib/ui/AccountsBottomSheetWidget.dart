import 'package:flutter/material.dart';
import 'package:moneym/models/mainModel.dart';
import 'package:provider/provider.dart';

class AccountBottomSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AccountBottomSheetState();
  }
}

class _AccountBottomSheetState extends State<AccountBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return _showAccountCard();
  }

  Widget _showAccountCard() {
    final Map<String, dynamic> _accountData = {
      'uuid': null,
      'name': null,
      'initialAmount': null,
      'icon': null
    };

    void _submitForm(Function insertAccount) {
      _formKey.currentState.save();
      insertAccount(_accountData);
      Navigator.pop(context);
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
                  'Cuenta',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                TextFormField(
                  initialValue:
                      _accountData['name'] != null ? _accountData['name'] : '',
                  decoration: InputDecoration(
                    icon: Icon(Icons.account_balance_wallet),
                    labelText: 'Nombre de la cuenta',
                  ),
                  onSaved: (String value) {
                    _accountData['name'] = value;
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
                  initialValue: _accountData['initialAmount'] != null
                      ? _accountData['initialAmount'].toString()
                      : '0',
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: Icon(Icons.monetization_on),
                    labelText: 'Cantidad Inicial',
                  ),
                  onSaved: (String value) {
                    _accountData['initialAmount'] = double.parse(value);
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
                    Consumer<AccountModel>(builder: (BuildContext context,
                        AccountModel model, Widget widget) {
                      return OutlineButton(
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
