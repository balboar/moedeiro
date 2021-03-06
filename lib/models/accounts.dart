import 'dart:convert';

import 'package:intl/intl.dart';

class Account {
  static String table = 'accounts';
  String? uuid;
  String? name;
  double? initialAmount = 0;
  double? amount = 0;
  double? expensesMonth = 0;
  int? position;
  String? icon;
  bool active = false;
  Account(
      {this.uuid,
      this.name,
      this.initialAmount,
      this.amount,
      this.position,
      this.icon,
      this.active = false});

  Account copyWith({
    String? uuid,
    String? name,
    double? initialAmount,
  }) {
    return Account(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      initialAmount: initialAmount ?? this.initialAmount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
      'initialAmount': NumberFormat(
        "###.0#",
        "en_US",
      ).format(initialAmount),
      'position': position,
      'icon': icon,
      'active': active ? 1 : 0
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
        uuid: map['uuid'],
        name: map['name'],
        initialAmount: map['initialAmount'],
        amount: map['amount'],
        position: map['position'],
        icon: map['icon'],
        active: map['active'] == 0 ? false : true);
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source));

  @override
  String toString() =>
      'Account(uuid: $uuid, name: $name, initialAmount: $initialAmount)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Account &&
        o.uuid == uuid &&
        o.name == name &&
        o.initialAmount == initialAmount;
  }

  @override
  int get hashCode => uuid.hashCode ^ name.hashCode ^ initialAmount.hashCode;
}
