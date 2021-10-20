import 'package:flutter/material.dart';
import 'package:moedeiro/components/buttons.dart';
import 'package:moedeiro/generated/l10n.dart';

class TransactionTypeFilterBottomSheet extends StatefulWidget {
  @override
  State<TransactionTypeFilterBottomSheet> createState() =>
      _TransactionTypeFilterBottomSheetState();
}

class _TransactionTypeFilterBottomSheetState
    extends State<TransactionTypeFilterBottomSheet> {
// N net, I Income, E Expenses
  Map<String, dynamic> _data = {'Filter': 'E'};

  bool _selectedIncome = false;
  bool _selectedExpense = false;
  bool _selectedNetIncome = false;

  Icon _incomeIconNotSelected = Icon(Icons.arrow_downward);
  Icon _expenseIconNotSelected = Icon(Icons.arrow_upward);
  Icon _netIncomeIconNotSelected = Icon(Icons.compare_arrows_outlined);

  late Icon _incomeIconSelected;
  late Icon _expenseIconSelected;
  late Icon _netIncomeIconSelected;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _incomeIconSelected =
        Icon(Icons.arrow_downward, color: Theme.of(context).primaryColor);
    _expenseIconSelected =
        Icon(Icons.arrow_upward, color: Theme.of(context).primaryColor);
    _netIncomeIconSelected = Icon(Icons.compare_arrows_outlined,
        color: Theme.of(context).primaryColor);
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
    return DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.9,
        minChildSize: 0.9,
        initialChildSize: 0.9,
        builder: (BuildContext context, ScrollController scrollController) {
          return Padding(
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
                    child: Text('${S.of(context).groupby}...',
                        style: Theme.of(context).textTheme.headline6),
                  ),
                  ListTile(
                      onTap: () {
                        setState(() {
                          _data['Filter'] = '%';
                          _selectedNetIncome = !_selectedNetIncome;
                          if (_selectedNetIncome) {
                            _selectedExpense = false;
                            _selectedIncome = false;
                          }
                        });
                      },
                      leading: _selectedNetIncome
                          ? _netIncomeIconSelected
                          : _netIncomeIconNotSelected,
                      title: Text(S.of(context).netIncome)),
                  ListTile(
                      onTap: () {
                        setState(() {
                          _data['Filter'] = 'I';
                          _selectedIncome = !_selectedIncome;
                          if (_selectedIncome) {
                            _selectedExpense = false;
                            _selectedNetIncome = false;
                          }
                        });
                      },
                      leading: _selectedIncome
                          ? _incomeIconSelected
                          : _incomeIconNotSelected,
                      title: Text(S.of(context).income)),
                  ListTile(
                      onTap: () {
                        setState(() {
                          _data['Filter'] = 'E';
                          _selectedExpense = !_selectedExpense;
                          if (_selectedExpense) {
                            _selectedNetIncome = false;
                            _selectedIncome = false;
                          }
                        });
                      },
                      leading: _selectedExpense
                          ? _expenseIconSelected
                          : _expenseIconNotSelected,
                      title: Text(S.of(context).expense)),
                  ButtonBar(
                    buttonHeight: 40.0,
                    buttonMinWidth: 140.0,
                    alignment: MainAxisAlignment.spaceAround,
                    children: [
                      SaveButton(
                        () {
                          Navigator.pop(context, _data);
                        },
                        label: S.of(context).acceptButtonText,
                      ),
                    ],
                  ),
                ],
              ));
        });
  }
}
