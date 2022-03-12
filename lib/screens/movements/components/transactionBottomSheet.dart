import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moedeiro/components/buttonBarForBottomSheet.dart';
import 'package:moedeiro/components/dialogs/confirmDeleteDialog.dart';
import 'package:moedeiro/components/showBottomSheet.dart';
import 'package:moedeiro/models/transaction.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/screens/accounts/components/AccountsListBottonSheet.dart';
import 'package:provider/provider.dart';
import 'package:moedeiro/generated/l10n.dart';

class TransactionBottomSheet extends StatefulWidget {
  final Transaction transaction;
  TransactionBottomSheet(this.transaction);
  @override
  State<StatefulWidget> createState() {
    return _TransactionBottomSheetState();
  }
}

class _TransactionBottomSheetState extends State<TransactionBottomSheet> {
  late Map<String, dynamic> _data;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _accountController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  bool? isExpense;
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
    _amountController.text = _data['amount'].toString();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_data['category'] != null && isExpense == null)
      isExpense = Provider.of<CategoryModel>(context, listen: false)
          .isExpense(_data['category']);
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
        return ComfirmDeleteDialog('😮');
      },
    );
  }

  void deleteTransaction() {
    if (_data['uuid'] != null) {
      _showMyDialog().then(
        (value) {
          if (value!) {
            Provider.of<TransactionModel>(context, listen: false)
                .delete(_data['uuid'])
                .then(
              (value) {
                Provider.of<AccountModel>(context, listen: false).getAccounts();
                Navigator.pop(context);
              },
            );
          }
        },
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (isExpense!) _data['amount'] = -1 * _data['amount'].abs();
      Provider.of<TransactionModel>(context, listen: false)
          .insertTransactiontIntoDb(Transaction.fromMap(_data))
          .then(
        (value) {
          Provider.of<AccountModel>(context, listen: false).getAccounts();
          Navigator.pop(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.only(
              right: 20.0,
              left: 20,
              top: 5,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: space,
              ),
              TextFormField(
                initialValue: _data['name'] ?? '',
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
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
                  enabledBorder: InputBorder.none,
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
                readOnly: true,
                controller: _categoryController,
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.dashboard_outlined,
                  ),
                  labelText: S.of(context).categoryTitle,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return S.of(context).categoryError;
                  }
                  return null;
                },
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  Map<String, dynamic>? result = await Navigator.pushNamed(
                      context, '/categoriesPage',
                      arguments: 'newTransaction');
                  if (result != null) {
                    _data['category'] = result['uuid'];
                    _categoryController.text = result['name'];
                    _data['categoryName'] = result['name'];
                    if (result['defaultAccount'] != null) {
                      _data['account'] = result['defaultAccount'];
                      _accountController.text =
                          Provider.of<AccountModel>(context, listen: false)
                              .getAccountName(result['defaultAccount']);
                      _data['accountName'] = _accountController.text;
                    }
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
                  enabledBorder: InputBorder.none,
                  prefixIcon: Icon(Icons.account_balance_wallet),
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
                    context,
                    AccountListBottomSheet(),
                    isScrollControlled: true,
                  ).then(
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
                        enabledBorder: InputBorder.none,
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
                        enabledBorder: InputBorder.none,
                        prefixIcon: Icon(Icons.access_time),
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
              ButtonBarMoedeiro(
                _data['uuid'] == null,
                onPressedButton1: () {
                  _submitForm();
                },
                onPressedButton2: () {
                  deleteTransaction();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
