import 'package:flutter/material.dart';
import 'package:moedeiro/generated/l10n.dart';
import 'package:moedeiro/screens/accounts/components/accountCharts.dart';
import 'package:moedeiro/screens/summary/components/transactionsCharts.dart';

class ChartsPage extends StatelessWidget {
  final String? data;
  ChartsPage({this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).analytics,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 15),
                reverse: true,
                scrollDirection: Axis.horizontal,
                child: ExpensesByMonthChart()),
            SingleChildScrollView(
                reverse: true,
                padding: EdgeInsets.symmetric(vertical: 15),
                scrollDirection: Axis.horizontal,
                child: TransactionChart()),
            SingleChildScrollView(
                reverse: true,
                padding: EdgeInsets.symmetric(vertical: 15),
                scrollDirection: Axis.horizontal,
                child: AccountBalanceChart()),
          ],
        ),
      ),
    );
  }
}
