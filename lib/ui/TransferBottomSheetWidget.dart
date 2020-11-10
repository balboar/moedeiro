import 'package:flutter/material.dart';

class TransferBottomSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TransferBottomSheetBottomSheetState();
  }
}

class _TransferBottomSheetBottomSheetState extends State<TransferBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return _showCompanyCard();
  }

  Widget _showCompanyCard() {
    final Map<String, dynamic> _companyData = {
      'uuid': null,
      'nombre': null,
      'ubicacion': null,
      'distancia': null,
      'user': null
    };

    Future<DateTime> _selectDate(BuildContext context) async {
      return await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101),
          builder: (BuildContext context, Widget child) {
            return Theme(
              data: ThemeData.dark(),
              child: child,
            );
          });
    }

    void _submitForm(Function insertCompany) {
      _formKey.currentState.save();

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
                  'Transferencia',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                TextFormField(
                  initialValue: _companyData['nombre'] != null
                      ? _companyData['nombre']
                      : '',
                  decoration: InputDecoration(
                    icon: Icon(Icons.description),
                    labelText: 'Descripcion',
                  ),
                  onSaved: (String value) {
                    _companyData['nombre'] = value;
                  },
                ),
                TextFormField(
                  initialValue: _companyData['ubicacion'] != null
                      ? _companyData['ubicacion']
                      : '',
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: Icon(Icons.monetization_on),
                    labelText: 'Importe',
                  ),
                  onSaved: (String value) {
                    _companyData['ubicacion'] = value;
                  },
                ),
                TextFormField(
                  initialValue: _companyData['distancia'] != null
                      ? _companyData['distancia'].toString()
                      : '',
                  decoration: InputDecoration(
                    icon: Icon(Icons.account_balance_wallet),
                    labelText: 'Cuenta',
                  ),
                  onSaved: (String value) {
                    _companyData['distancia'] = double.parse(value);
                  },
                ),
                TextFormField(
                  initialValue: _companyData['distancia'] != null
                      ? _companyData['distancia'].toString()
                      : '',
                  decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    labelText: 'Fecha',
                  ),
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _selectDate(context);
                  },
                  onSaved: (String value) {
                    _companyData['distancia'] = double.parse(value);
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
                    OutlineButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      borderSide: BorderSide(
                          width: 1.0, color: Theme.of(context).accentColor),
                      color: Theme.of(context).dialogBackgroundColor,
                      textColor: Colors.white,
                      onPressed: () {},
                      child: Text("Guardar"),
                    ),
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
