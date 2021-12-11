import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moedeiro/components/buttonBarForBottomSheet.dart';
import 'package:moedeiro/components/buttons.dart';
import 'package:moedeiro/components/dialogs/confirmDeleteDialog.dart';
import 'package:moedeiro/components/showBottomSheet.dart';
import 'package:moedeiro/models/recurrences.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/screens/accounts/components/AccountsListBottonSheet.dart';
import 'package:provider/provider.dart';
import 'package:moedeiro/generated/l10n.dart';

class RecurrenceBottomSheet extends StatefulWidget {
  final Recurrence recurrence;
  RecurrenceBottomSheet(this.recurrence);
  @override
  State<StatefulWidget> createState() {
    return _RecurrenceBottomSheetState();
  }
}

class _RecurrenceBottomSheetState extends State<RecurrenceBottomSheet> {
  late Map<String, dynamic> _data;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _dateNextEventController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _accountController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _periodicityController = TextEditingController();
  TextEditingController _periodicityIntervalController =
      TextEditingController();
  bool? isExpense;
  double space = 7.0;
  String? _selectedValue = 'M';

  @override
  void initState() {
    _data = widget.recurrence.toMap();
    _dateController.text = _data['timestamp'] != null
        ? DateFormat.yMMMd().format(
            DateTime.fromMillisecondsSinceEpoch(_data['timestamp']),
          )
        : '';

    _dateNextEventController.text = _data['nextEvent'] != null
        ? DateFormat.yMMMd().format(
            DateTime.fromMillisecondsSinceEpoch(_data['nextEvent']),
          )
        : '';

    _categoryController.text = _data['categoryName'] ?? '';
    _accountController.text = _data['accountName'] ?? '';
    _amountController.text = _data['amount'].toString();
    _periodicityIntervalController.text = _data['periodicityInterval'] != null
        ? _data['periodicityInterval'].toString()
        : '1';
    _periodicityController.text = _data['periodicity'] ?? 'M';

    _selectedValue = _data['periodicity'] ?? 'M';

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
    _dateController.dispose();
    _categoryController.dispose();
    _accountController.dispose();
    _dateNextEventController.dispose();
    _amountController.dispose();
    _periodicityController.dispose();
    _periodicityIntervalController.dispose();
    super.dispose();
  }

  // ignore: missing_return
  Future<int?> _selectDate(
      BuildContext context, int _dateInMilliseconds) async {
    DateTime _date = DateTime.fromMillisecondsSinceEpoch(_dateInMilliseconds);
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

  void deleteRecurrence() {
    if (_data['uuid'] != null) {
      _showMyDialog().then(
        (value) {
          if (value!) {
            Provider.of<RecurrenceModel>(context, listen: false)
                .delete(_data['uuid'])
                .then(
              (value) {
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
      Provider.of<RecurrenceModel>(context, listen: false)
          .insertRecurrenceIntoDb(Recurrence.fromMap(_data))
          .then(
        (value) {
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
              TextFormField(
                readOnly: true,
                controller: _dateController,
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  prefixIcon: Icon(Icons.calendar_today),
                  labelText: S.of(context).date,
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _selectDate(context, _data['timestamp']).then((int? value) {
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
              SizedBox(
                height: space,
              ),
              TextFormField(
                readOnly: true,
                controller: _dateNextEventController,
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  prefixIcon: Icon(Icons.next_plan),
                  labelText: S.of(context).nextEvent,
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _selectDate(context, _data['nextEvent']).then((int? value) {
                    if (value != null)
                      setState(() {
                        _dateNextEventController.text =
                            DateFormat.yMMMd().format(
                          DateTime.fromMillisecondsSinceEpoch(value),
                        );
                        _data['nextEvent'] = value;
                      });
                  });
                },
              ),
              SizedBox(
                height: space,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: S.of(context).frequency,
                        enabledBorder: InputBorder.none,
                        prefixIcon: Icon(Icons.repeat_rounded),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedValue = value;
                        });
                      },
                      onSaved: (String? value) {
                        setState(() {
                          _selectedValue = value;
                          _data['periodicity'] = value;
                        });
                      },
                      validator: (String? value) {
                        if (value == null) {
                          return "can't empty";
                        } else {
                          return null;
                        }
                      },
                      items: [
                        DropdownMenuItem<String>(
                          child: Text(S.of(context).daily),
                          value: 'D',
                        ),
                        DropdownMenuItem<String>(
                          child: Text(S.of(context).weekly),
                          value: 'W',
                        ),
                        DropdownMenuItem<String>(
                          child: Text(S.of(context).monthly),
                          value: 'M',
                        ),
                        DropdownMenuItem<String>(
                          child: Text(S.of(context).yearly),
                          value: 'Y',
                        ),
                      ],
                      value: _selectedValue,
                    ),
                  ),
                  SizedBox(
                    width: space,
                  ),
                  Container(
                    width: 100,
                    child: TextFormField(
                      onTap: () {
                        if (int.tryParse(
                                _periodicityIntervalController.text)! ==
                            0) {
                          _periodicityIntervalController.text = '';
                        }
                      },
                      validator: (value) {
                        if (value!.isEmpty || int.tryParse(value) == 0) {
                          return S.of(context).amountError;
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      onSaved: (String? value) {
                        _data['periodicityInterval'] = int.parse(value!);
                      },
                      controller: _periodicityIntervalController,
                      decoration: InputDecoration(
                        labelText: S.of(context).every,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              ButtonBarMoedeiro(
                _data['uuid'] == null,
                onPressedButton1: () {
                  _submitForm();
                },
                onPressedButton2: () {
                  deleteRecurrence();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
