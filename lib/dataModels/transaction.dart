import 'dart:convert';

// 'CREATE TABLE transactions (uuid TEXT PRIMARY KEY NOT NULL, name TEXT, Amount REAL, ' +
//           ' category TEXT,account TEXT, timestamp INTEGER,FOREIGN KEY(account) REFERENCES accounts(uuid), ' +
//           'FOREIGN KEY(category) REFERENCES category(uuid) )',

class Transaction {
  static String table = 'transactions';
  String name;
  String uuid;
  double amount;
  String category;
  String categoryName;
  int timestamp;
  String account;
  String accountName;
  Transaction({
    this.name,
    this.uuid,
    this.amount = 0,
    this.category,
    this.categoryName,
    this.timestamp,
    this.account,
    this.accountName,
  });

  Transaction copyWith({
    String name,
    String uuid,
    double amount,
    String category,
    String categoryName,
    int timestamp,
    String account,
    String accountName,
  }) {
    return Transaction(
      name: name ?? this.name,
      uuid: uuid ?? this.uuid,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      categoryName: categoryName ?? this.categoryName,
      timestamp: timestamp ?? this.timestamp,
      account: account ?? this.account,
      accountName: accountName ?? this.accountName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uuid': uuid,
      'amount': amount,
      'category': category,
      'timestamp': timestamp,
      'account': account,
      'categoryName': categoryName,
      'accountName': accountName
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
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Transaction(
      name: map['name'],
      uuid: map['uuid'],
      amount: map['amount'],
      category: map['category'],
      categoryName: map['categoryName'],
      timestamp: map['timestamp'],
      account: map['account'],
      accountName: map['accountName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Transaction(name: $name, uuid: $uuid, amount: $amount, category: $category, categoryName: $categoryName, timestamp: $timestamp, account: $account, accountName: $accountName)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Transaction &&
        o.name == name &&
        o.uuid == uuid &&
        o.amount == amount &&
        o.category == category &&
        o.categoryName == categoryName &&
        o.timestamp == timestamp &&
        o.account == account &&
        o.accountName == accountName;
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
        accountName.hashCode;
  }
}
