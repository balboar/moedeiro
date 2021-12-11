import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moedeiro/components/buttons.dart';
import 'package:moedeiro/generated/l10n.dart';

class CalendarFilterBottomSheet extends StatefulWidget {
  @override
  State<CalendarFilterBottomSheet> createState() =>
      _CalendarFilterBottomSheetState();
}

class _CalendarFilterBottomSheetState extends State<CalendarFilterBottomSheet> {
  TextEditingController _dateFromController = TextEditingController();

  TextEditingController _dateToController = TextEditingController();

  Map<String, dynamic> _data = {'Filter': 'M', 'Date1': null, 'Date2': null};

  bool _selectedMonthly = false;
  bool _selectedYearly = false;
  bool _selectedCustomRange = false;

  Icon _monthlyIconNotSelected = Icon(Icons.calendar_view_month);
  Icon _yearlyIconNotSelected = Icon(Icons.calendar_today);

  late Icon _monthlyIconSelected;
  late Icon _yearlyIconSelected;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _monthlyIconSelected =
        Icon(Icons.calendar_view_month, color: Theme.of(context).primaryColor);

    _yearlyIconSelected =
        Icon(Icons.calendar_today, color: Theme.of(context).primaryColor);

    super.didChangeDependencies();
  }

  Future<int?> _selectDate(BuildContext context, DateTime _date) async {
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:
          // maxChildSize: 0.95,
          // minChildSize: 0.25,
          // expand: false,
          // builder: (BuildContext context, ScrollController scrollController) {
          Padding(
        padding: EdgeInsets.only(
            right: 20.0,
            left: 20,
            top: 30,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, bottom: 20),
              child: Text('${S.of(context).group}...',
                  style: Theme.of(context).textTheme.headline6),
            ),
            ListTile(
                onTap: () {
                  setState(() {
                    _data['Filter'] = 'M';
                    _selectedMonthly = !_selectedMonthly;
                    if (_selectedMonthly) _selectedYearly = false;
                    if (_selectedMonthly) {
                      _dateToController.text = '';
                      _dateFromController.text = '';
                    }
                  });
                },
                leading: _selectedMonthly
                    ? _monthlyIconSelected
                    : _monthlyIconNotSelected,
                title: Text(S.of(context).monthly)),
            ListTile(
                onTap: () {
                  setState(() {
                    _data['Filter'] = 'Y';
                    _selectedYearly = !_selectedYearly;

                    if (_selectedYearly) _selectedMonthly = false;

                    if (_selectedYearly) {
                      _dateToController.text = '';
                      _dateFromController.text = '';
                    }
                  });
                },
                leading: _selectedYearly
                    ? _yearlyIconSelected
                    : _yearlyIconNotSelected,
                title: Text(S.of(context).yearly)),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
              child: Text(
                S.of(context).customRange,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 130,
                  child: TextFormField(
                    readOnly: true,
                    controller: _dateFromController,
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      prefixIcon: Icon(Icons.calendar_today),
                      labelText: S.of(context).from,
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _selectDate(context, DateTime.now()).then((int? value) {
                        if (value != null) {
                          setState(() {
                            _selectedCustomRange = !_selectedCustomRange;

                            if (_selectedCustomRange) {
                              _selectedMonthly = false;
                              _selectedYearly = false;
                            }

                            _data['Filter'] = 'C';
                            _data['Date1'] =
                                DateTime.fromMillisecondsSinceEpoch(value);
                            _dateFromController.text = DateFormat.yMd().format(
                              DateTime.fromMillisecondsSinceEpoch(value),
                            );
                          });
                        }
                      });
                    },
                  ),
                ),
                Container(
                  width: 130,
                  child: TextFormField(
                    readOnly: true,
                    controller: _dateToController,
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      prefixIcon: Icon(Icons.calendar_today),
                      labelText: S.of(context).to,
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _selectDate(context, DateTime.now()).then((int? value) {
                        if (value != null) {
                          setState(() {
                            _selectedCustomRange = !_selectedCustomRange;
                            if (_selectedCustomRange) {
                              _selectedMonthly = false;
                              _selectedYearly = false;
                            }

                            _data['Filter'] = 'C';
                            _data['Date2'] =
                                DateTime.fromMillisecondsSinceEpoch(value);
                            _dateToController.text = DateFormat.yMd().format(
                              DateTime.fromMillisecondsSinceEpoch(value),
                            );
                          });
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                height: 40.0,
                width: MediaQuery.of(context).size.width - 50,
                child: MainButtonMoedeiro(
                  onPressed: () {
                    Navigator.pop(context, _data);
                  },
                  label: S.of(context).acceptButtonText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
