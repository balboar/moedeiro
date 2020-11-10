import 'dart:convert';

class Account {
  static String table = 'accounts';
  final String uuid;
  final String name;
  final double initialAmount;
  Account({
    this.uuid,
    this.name,
    this.initialAmount,
  });

  Account copyWith({
    String uuid,
    String name,
    double initialAmount,
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
      'initialAmount': initialAmount,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Account(
      uuid: map['uuid'],
      name: map['name'],
      initialAmount: map['initialAmount'],
    );
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
