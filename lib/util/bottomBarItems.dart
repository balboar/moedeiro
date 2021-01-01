import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Destination {
  const Destination(this.id, this.title, this.icon);
  final int id;
  final String title;
  final IconData icon;
}

const List<Destination> allDestinations = <Destination>[
  Destination(0, 'Home', Icons.home_outlined),
  Destination(1, 'Accounts', Icons.account_balance_wallet_outlined),
  Destination(2, 'Categories', Icons.category_outlined),
];
