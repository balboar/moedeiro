import 'dart:convert';

class Recurrence {
  static String table = 'recurrences';
  String? name;
  String? uuid;
  double? amount;
  String? category;
  String? categoryName;
  int? timestamp;
  String? account;
  String? accountName;
  String? periodicity;
  int? periodicityInterval;
  int? nextEvent;
  Recurrence({
    this.name,
    this.uuid,
    this.amount,
    this.category,
    this.categoryName,
    this.timestamp,
    this.account,
    this.accountName,
    this.periodicity,
    this.periodicityInterval,
    this.nextEvent,
  });

  Recurrence copyWith({
    String? name,
    String? uuid,
    double? amount,
    String? category,
    String? categoryName,
    int? timestamp,
    String? account,
    String? accountName,
    String? periodicity,
    int? periodicityInterval,
    int? nextEvent,
  }) {
    return Recurrence(
      name: name ?? this.name,
      uuid: uuid ?? this.uuid,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      categoryName: categoryName ?? this.categoryName,
      timestamp: timestamp ?? this.timestamp,
      account: account ?? this.account,
      accountName: accountName ?? this.accountName,
      periodicity: periodicity ?? this.periodicity,
      periodicityInterval: periodicityInterval ?? this.periodicityInterval,
      nextEvent: nextEvent ?? this.nextEvent,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uuid': uuid,
      'amount': amount,
      'category': category,
      'categoryName': categoryName,
      'timestamp': timestamp,
      'account': account,
      'accountName': accountName,
      'periodicity': periodicity,
      'periodicityInterval': periodicityInterval,
      'nextEvent': nextEvent,
    };
  }

  Map<String, dynamic> toDbMap() {
    return {
      'name': name,
      'uuid': uuid,
      'amount': amount,
      'category': category,
      'timestamp': timestamp,
      'account': account,
      'periodicity': periodicity,
      'periodicityInterval': periodicityInterval,
      'nextEvent': nextEvent,
    };
  }

  factory Recurrence.fromMap(Map<String, dynamic> map) {
    return Recurrence(
      name: map['name'] != null ? map['name'] : '',
      uuid: map['uuid'] != null ? map['uuid'] : null,
      amount: map['amount'] != null ? map['amount'] : null,
      category: map['category'] != null ? map['category'] : null,
      categoryName: map['categoryName'] != null ? map['categoryName'] : null,
      timestamp: map['timestamp'] != null ? map['timestamp'] : null,
      account: map['account'] != null ? map['account'] : null,
      accountName: map['accountName'] != null ? map['accountName'] : null,
      periodicity: map['periodicity'] != null ? map['periodicity'] : null,
      periodicityInterval: map['periodicityInterval'] != null
          ? map['periodicityInterval']
          : null,
      nextEvent: map['nextEvent'] != null ? map['nextEvent'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Recurrence.fromJson(String source) =>
      Recurrence.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Recurrence(name: $name, uuid: $uuid, amount: $amount, category: $category, categoryName: $categoryName, timestamp: $timestamp, account: $account, accountName: $accountName, periodicity: $periodicity, periodicityInterval: $periodicityInterval, nextEvent: $nextEvent)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Recurrence &&
        other.name == name &&
        other.uuid == uuid &&
        other.amount == amount &&
        other.category == category &&
        other.categoryName == categoryName &&
        other.timestamp == timestamp &&
        other.account == account &&
        other.accountName == accountName &&
        other.periodicity == periodicity &&
        other.periodicityInterval == periodicityInterval &&
        other.nextEvent == nextEvent;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        uuid.hashCode ^
        amount.hashCode ^
        category.hashCode ^
        categoryName.hashCode ^
        timestamp.hashCode ^
        account.hashCode ^
        accountName.hashCode ^
        periodicity.hashCode ^
        periodicityInterval.hashCode ^
        nextEvent.hashCode;
  }
}
