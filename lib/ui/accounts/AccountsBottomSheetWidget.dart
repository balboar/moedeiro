import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moedeiro/dataModels/accounts.dart';
import 'package:moedeiro/models/mainModel.dart';
import 'package:moedeiro/ui/dialogs/confirmDeleteDialog.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
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
  final picker = ImagePicker();
  File _image;
  String _imagePath;

  @override
  void initState() {
    activeAccount = widget.activeAccount ?? Account(initialAmount: 0.00);
    super.initState();
  }

  Future getImageFromFile() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    Directory _destination = await getApplicationDocumentsDirectory();
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _imagePath = _destination.path +
          '/${activeAccount.uuid}${p.extension(pickedFile.path)}';
      _image.copy(_imagePath);
    }

    setState(
      () {
        if (_imagePath != null) {
          activeAccount.icon = _imagePath;
        }
      },
    );
  }

  Future<bool> _showMyDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return ComfirmDeleteDialog(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Delete account?',
          subtitle: 'An account is going to be deleted, are you sure?',
        );
      },
    );
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
                GestureDetector(
                  child: CircleAvatar(
                    backgroundImage: activeAccount.icon != null
                        ? FileImage(
                            File(activeAccount.icon),
                          )
                        : null,
                    backgroundColor: Theme.of(context).dialogBackgroundColor,
                    child: activeAccount.icon != null ? null : Icon(Icons.add),
                    radius: 40,
                  ),
                  onTap: getImageFromFile,
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  initialValue: activeAccount.name,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_balance_wallet),
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(fontSize: 20.0),
                    // icon: Icon(Icons.account_balance_wallet),
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
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  initialValue: activeAccount.initialAmount.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.euro),
                    border: OutlineInputBorder(),
                    // icon: Icon(Icons.euro),
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
                  padding: EdgeInsets.all(5.0),
                ),
                Consumer<AccountModel>(
                  builder: (BuildContext context, AccountModel model,
                      Widget widget) {
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
                              if (activeAccount.uuid != null) {
                                _showMyDialog().then((value) {
                                  if (value) {
                                    model.deleteAccount(activeAccount.uuid);
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
                              _submitForm(model.insertAccountIntoDb);
                            },
                          ),
                        )
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
