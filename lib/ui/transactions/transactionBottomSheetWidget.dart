import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moedeiro/dataModels/transaction.dart';
import 'package:moedeiro/models/mainModel.dart';
import 'package:moedeiro/ui/accounts/AccountsListBottonSheet.dart';
import 'package:moedeiro/ui/dialogs/confirmDeleteDialog.dart';
import 'package:moedeiro/ui/showBottomSheet.dart';
import 'package:moedeiro/ui/widgets/buttons.dart';
import 'package:provider/provider.dart';
import 'package:moedeiro/generated/l10n.dart';

class TransactionBottomSheet extends StatefulWidget {
  Transaction transaction;
  TransactionBottomSheet(this.transaction);
  @override
  State<StatefulWidget> createState() {
    return _TransactionBottomSheetState();
  }
}

class _TransactionBottomSheetState extends State<TransactionBottomSheet> {
  Map<String, dynamic> _data;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _accountController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  bool isExpense = false;
  double space = 7.0;

  @override
  void initState() {
    _data = widget.transaction.toMap();
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

    _categoryController.text = _data['categoryName'] ?? '';
    _accountController.text = _data['accountName'] ?? '';
    _amountController.text = _data['amount'].toString() ?? '';
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_data['account'] == null) {
      var _accounts =
          Provider.of<AccountModel>(context, listen: false).accounts;
      if (_accounts.length > 0) {
        _data['account'] =
            Provider.of<AccountModel>(context, listen: false).accounts[0].uuid;

        _accountController.text =
            Provider.of<AccountModel>(context, listen: false)
                .getAccountName(_data['account']);
        _data['accountName'] = _accountController.text;
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _dateController.dispose();
    _timeController.dispose();
    _categoryController.dispose();
    _accountController.dispose();
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

  void deleteTransaction(TransactionModel model) {
    if (_data['uuid'] != null) {
      _showMyDialog().then((value) {
        if (value) {
          model.delete(_data['uuid']);
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
        if (isExpense) _data['amount'] = -1 * _data['amount'];
        save(Transaction.fromMap(_data));
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
                  initialValue: _data['name'] ?? '',
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                    labelText: S.of(context).description,
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
                      return S.of(context).amountError;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.attach_money_outlined),
                    border: OutlineInputBorder(),
                    labelText: S.of(context).amount,
                  ),
                  onSaved: (String value) {
                    _data['amount'] = double.parse(value);
                  },
                ),
                SizedBox(
                  height: space,
                ),
                TextFormField(
                  readOnly: true,
                  controller: _categoryController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.category_outlined),
                    border: OutlineInputBorder(),
                    labelText: S.of(context).categoryTitle,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return S.of(context).categoryError;
                    }
                    return null;
                  },
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    Map<String, dynamic> result = await Navigator.pushNamed(
                        context, '/categoriesPage',
                        arguments: 'newTransaction');
                    if (result != null) {
                      _data['category'] = result['uuid'];
                      _categoryController.text = result['name'];
                      _data['categoryName'] = result['name'];
                      isExpense = result['type'] == 'E';
                    }
                  },
                ),
                SizedBox(
                  height: space,
                ),
                TextFormField(
                  readOnly: true,
                  controller: _accountController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_balance_wallet),
                    border: OutlineInputBorder(),
                    labelText: S.of(context).account,
                  ),
                  validator: (value) {
                    if (_accountController.text.isEmpty) {
                      return S.of(context).accountSelectError;
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
                          _data['account'] = value;
                          _accountController.text =
                              Provider.of<AccountModel>(context, listen: false)
                                  .getAccountName(value);
                          _data['accountName'] = _accountController.text;
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
                          border: OutlineInputBorder(),
                          labelText: S.of(context).date,
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
                          prefixIcon: Icon(Icons.hourglass_bottom_outlined),
                          border: OutlineInputBorder(),
                          labelText: S.of(context).time,
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
                Consumer<TransactionModel>(
                  builder: (BuildContext context, TransactionModel model,
                      Widget widget) {
                    return ButtonBar(
                      buttonHeight: 40.0,
                      buttonMinWidth: 140.0,
                      alignment: MainAxisAlignment.center,
                      children: [
                        DeleteButton(() {
                          deleteTransaction(model);
                        }),
                        SaveButton(() {
                          _submitForm(model.insertTransactiontIntoDb);
                        }),
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
