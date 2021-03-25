import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moedeiro/components/buttons.dart';
import 'package:moedeiro/components/dialogs/confirmDeleteDialog.dart';
import 'package:moedeiro/components/showBottomSheet.dart';
import 'package:moedeiro/models/transfer.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/screens/accounts/components/AccountsListBottonSheet.dart';
import 'package:provider/provider.dart';
import 'package:moedeiro/generated/l10n.dart';

class TransferBottomSheet extends StatefulWidget {
  final Transfer transfer;
  TransferBottomSheet(this.transfer);
  @override
  State<StatefulWidget> createState() {
    return _TransferBottomSheetState();
  }
}

class _TransferBottomSheetState extends State<TransferBottomSheet> {
  Transfer? transfer;
  late Map<String, dynamic> _data;
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
    _amountController.text = _data['amount'].toString();
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

  // ignore: missing_return
  Future<int?> _selectDate(BuildContext context) async {
    DateTime _date = DateTime.fromMillisecondsSinceEpoch(_data['timestamp']);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _date) {
      return Future.value(picked.millisecondsSinceEpoch);
    }
  }

  // ignore: missing_return
  Future<int?> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(_data['timestamp']),
      ),
    );

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

  Future<bool?> _showMyDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return ComfirmDeleteDialog();
      },
    );
  }

  void deleteTransfer(TransfersModel model) {
    if (_data['uuid'] != null) {
      _showMyDialog().then((value) {
        if (value!) {
          model.delete(_data['uuid']).then((value) {
            Provider.of<AccountModel>(context, listen: false).getAccounts();
            Navigator.pop(context);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void _submitForm(Function save) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        save(Transfer.fromMap(_data)).then(
          (value) {
            Provider.of<AccountModel>(context, listen: false).getAccounts();
            Navigator.pop(context);
          },
        );
      }
    }

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.only(right: 20.0, left: 20, top: 5, bottom: 5.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: space,
              ),
              TextFormField(
                initialValue: _data['name'] ?? '',
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.description),
                  labelText: S.of(context).description,
                ),
                onSaved: (String? value) {
                  _data['name'] = value;
                },
              ),
              SizedBox(
                height: space,
              ),
              TextFormField(
                controller: _amountController,
                onTap: () {
                  if (double.tryParse(_amountController.text)!.round() == 0) {
                    _amountController.text = '';
                  }
                },
                validator: (value) {
                  if (value!.isEmpty || double.tryParse(value) == 0) {
                    return S.of(context).amountError;
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.euro_outlined),
                  labelText: S.of(context).amount,
                ),
                onSaved: (String? value) {
                  _data['amount'] = double.parse(value!);
                },
              ),
              SizedBox(
                height: space,
              ),
              TextFormField(
                controller: _accountFromController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.account_balance_wallet),
                  labelText: S.of(context).from,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return S.of(context).accountSelectError;
                  }
                  return null;
                },
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  showCustomModalBottomSheet(context, AccountListBottomSheet())
                      .then(
                    (value) {
                      if (value != null) {
                        _data['accountFrom'] = value;
                        _accountFromController.text =
                            Provider.of<AccountModel>(context, listen: false)
                                .getAccountName(value);
                        _data['accountFromName'] = _accountFromController.text;
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
                  prefixIcon: Icon(Icons.account_balance_wallet),
                  labelText: S.of(context).to,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return S.of(context).accountSelectError;
                  }
                  return null;
                },
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());

                  showCustomModalBottomSheet(context, AccountListBottomSheet())
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
                        prefixIcon: Icon(Icons.calendar_today),
                        labelText: S.of(context).date,
                      ),
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _selectDate(context).then((int? value) {
                          if (value != null)
                            setState(() {
                              _dateController.text = DateFormat.yMMMd().format(
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
                        prefixIcon: Icon(Icons.hourglass_bottom_outlined),
                        labelText: S.of(context).time,
                      ),
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _selectTime(context).then((int? value) {
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
              Consumer<TransfersModel>(builder:
                  (BuildContext context, TransfersModel model, Widget? widget) {
                return ButtonBar(
                  buttonHeight: 40.0,
                  buttonMinWidth: 140.0,
                  alignment: MainAxisAlignment.spaceAround,
                  children: [
                    DeleteButton(() {
                      deleteTransfer(model);
                    }),
                    SaveButton(() {
                      _submitForm(model.insertTransferIntoDb);
                    }),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
