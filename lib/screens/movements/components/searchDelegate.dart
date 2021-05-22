import 'package:flutter/material.dart';
import 'package:moedeiro/components/moedeiroWidgets.dart';
import 'package:moedeiro/models/transaction.dart';
import 'package:moedeiro/provider/mainModel.dart';
import 'package:moedeiro/screens/movements/components/transactionWidgets.dart';
import 'package:provider/provider.dart';

class MovementsSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer<TransactionModel>(
        builder: (BuildContext context, TransactionModel model, Widget? child) {
      Future<List<Transaction>> _transactions;
      if (query.isEmpty)
        _transactions = model.searchTransactions('&&&&&&&&&&&&&&');
      else
        _transactions = model.searchTransactions(query);
      return StreamBuilder(
        stream: _transactions.asStream(),
        builder: (context, AsyncSnapshot<List<Transaction>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else if (query.isEmpty) {
            return Center();
          } else if (snapshot.data!.length == 0) {
            return Center(child: NoDataWidgetVertical());
          } else {
            var results = snapshot.data;
            return ListView(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10, top: 0.0, bottom: 10.0),
              itemExtent: 80.0,
              children: results!
                  .map(
                      (e) => Container(height: 80.0, child: TransactionTile(e)))
                  .toList(),
            );
          }
        },
      );
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column();
  }
}
