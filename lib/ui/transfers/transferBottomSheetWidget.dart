import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moedeiro/dataModels/transfer.dart';
import 'package:moedeiro/models/mainModel.dart';
import 'package:moedeiro/ui/accounts/AccountsListBottonSheet.dart';
import 'package:moedeiro/ui/dialogs/confirmDeleteDialog.dart';
import 'package:moedeiro/ui/showBottomSheet.dart';
import 'package:provider/provider.dart';

class TransferBottomSheet extends StatefulWidget {
  Transfer transfer;
  TransferBottomSheet(this.transfer);
  @override
  State<StatefulWidget> createState() {
    return _TransferBottomSheetState();
  }
}

class _TransferBottomSheetState extends State<TransferBottomSheet> {
  Transfer transfer;
  Map<String, dynamic> _data;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _accountFromController = TextEditingController();
  TextEditingController _accountToController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  double space = 7.0;

  @override
  void initState() {
    _data = widget.transfer.toMap();
    _dateController.text = _data['timestamp'] != null
        ? DateFormat.yMMMd().format(
            DateTime.fromMillisecondsSinceEpoch(_data['timestamp']),
          )
        : '';

    _timeController.text = _data['timestamp'] != null
        ? DateFormat.Hm().format(
            DateTime.fromMillisecondsSinceEpoch(_data['timestamp']),
          )
        : '';

    _accountFromController.text = _data['accountFromName'] ?? '';
    _accountToController.text = _data['accountToName'] ?? '';
    _amountController.text = _data['amount'].toString() ?? '';
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _dateController.dispose();
    _timeController.dispose();
    _accountFromController.dispose();
    _accountToController.dispose();
    super.dispose();
  }

  Future<int> _selectDate(BuildContext context) async {
    DateTime _date = DateTime.fromMillisecondsSinceEpoch(_data['timestamp']);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark(),
            child: child,
          );
        });
    if (picked != null && picked != _date) {
      return Future.value(picked.millisecondsSinceEpoch);
    }
  }

  Future<int> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          DateTime.fromMillisecondsSinceEpoch(_data['timestamp']),
        ),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark(),
            child: child,
          );
        });

    if (picked != null) {
      setState(() {
        DateTime _fecha =
            DateTime.fromMillisecondsSinceEpoch(_data['timestamp']);
        int fecha = DateTime(_fecha.year, _fecha.month, _fecha.day, picked.hour,
                picked.minute)
            .millisecondsSinceEpoch;
        _data['timestamp'] = fecha;
      });
      return Future.value(_data['timestamp']);
    }
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
        save(Transfer.fromMap(_data));
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
                // Text(
                //   'Transfer',
                //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                // ),
                TextFormField(
                  initialValue: _data['name'] ?? '',
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                  ),
                  onSaved: (String value) {
                    _data['name'] = value;
                  },
                ),
                SizedBox(
                  height: space,
                ),
                TextFormField(
                  controller: _amountController,
                  onTap: () {
                    if (double.tryParse(_amountController.text).round() == 0) {
                      _amountController.text = '';
                    }
                  },
                  validator: (value) {
                    if (value.isEmpty || double.tryParse(value) == 0) {
                      return 'Amount should be greater than 0';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money_outlined),
                    labelText: 'Amount',
                  ),
                  onSaved: (String value) {
                    _data['amount'] = double.parse(value);
                  },
                ),
                SizedBox(
                  height: space,
                ),
                TextFormField(
                  controller: _accountFromController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.account_balance_wallet),
                    labelText: 'From',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please select an Account';
                    }
                    return null;
                  },
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    showCustomModalBottomSheet(
                            context, AccountListBottomSheet())
                        .then(
                      (value) {
                        if (value != null) {
                          _data['accountFrom'] = value;
                          _accountFromController.text =
                              Provider.of<AccountModel>(context, listen: false)
                                  .getAccountName(value);
                          _data['accountFromName'] =
                              _accountFromController.text;
                        }
                      },
                    );
                  },
                ),
                SizedBox(
                  height: space,
                ),
                TextFormField(
                  controller: _accountToController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.account_balance_wallet),
                    labelText: 'To',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please select an Account';
                    }
                    return null;
                  },
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());

                    showCustomModalBottomSheet(
                            context, AccountListBottomSheet())
                        .then(
                      (value) {
                        if (value != null) {
                          _data['accountTo'] = value;
                          _accountToController.text =
                              Provider.of<AccountModel>(context, listen: false)
                                  .getAccountName(value);
                          _data['accountToName'] = _accountToController.text;
                        }
                      },
                    );
                  },
                ),
                SizedBox(
                  height: space,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: _dateController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                          labelText: 'Date',
                        ),
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _selectDate(context).then((int value) {
                            if (value != null)
                              setState(() {
                                _dateController.text =
                                    DateFormat.yMMMd().format(
                                  DateTime.fromMillisecondsSinceEpoch(value),
                                );
                                _data['timestamp'] = value;
                              });
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: space,
                    ),
                    Container(
                      child: TextFormField(
                        readOnly: true,
                        controller: _timeController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.hourglass_bottom_outlined),
                          labelText: 'Time',
                        ),
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _selectTime(context).then((int value) {
                            if (value != null)
                              setState(() {
                                _timeController.text = DateFormat.Hm().format(
                                  DateTime.fromMillisecondsSinceEpoch(value),
                                );
                                _data['timestamp'] = value;
                              });
                          });
                        },
                      ),
                      width: 130,
                    ),
                  ],
                ),
                Padding(
                  child: Container(),
                  padding: EdgeInsets.all(5.0),
                ),
                Consumer<TransfersModel>(builder: (BuildContext context,
                    TransfersModel model, Widget widget) {
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
                            if (_data['uuid'] != null) {
                              _showMyDialog().then((value) {
                                if (value) {
                                  model.delete(_data['uuid']);
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
                            _submitForm(model.insertTransferIntoDb);
                          },
                        ),
                      )
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
