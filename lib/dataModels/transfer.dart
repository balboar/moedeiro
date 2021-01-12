import 'dart:convert';

// 'CREATE TABLE transfers (uuid TEXT PRIMARY KEY NOT NULL,amount REAL, ' +
//           ' accountFrom TEXT,accountTo TEXT, timestamp INTEGER,FOREIGN KEY(accountFrom) REFERENCES accounts(uuid), ' +
//           'FOREIGN KEY(accountTo) REFERENCES accounts(uuid) )',
//     );

class Transfer {
  static String table = 'transfers';
  String uuid;
  double amount;
  int timestamp;
  String accountFrom;
  String accountFromName;
  String accountTo;
  String accountToName;
  Transfer({
    this.uuid,
    this.amount = 0,
    this.timestamp,
    this.accountFrom,
    this.accountFromName,
    this.accountTo,
    this.accountToName,
  });

  Transfer copyWith({
    String uuid,
    double amount,
    int timestamp,
    String accountFrom,
    String accountFromName,
    String accountTo,
    String accountToName,
  }) {
    return Transfer(
      uuid: uuid ?? this.uuid,
      amount: amount ?? this.amount,
      timestamp: timestamp ?? this.timestamp,
      accountFrom: accountFrom ?? this.accountFrom,
      accountFromName: accountFromName ?? this.accountFromName,
      accountTo: accountTo ?? this.accountTo,
      accountToName: accountToName ?? this.accountToName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'amount': amount,
      'timestamp': timestamp,
      'accountFrom': accountFrom,
      'accountFromName': accountFromName,
      'accountTo': accountTo,
      'accountToName': accountToName,
    };
  }

  Map<String, dynamic> toDbMap() {
    return {
      'uuid': uuid,
      'amount': amount,
      'timestamp': timestamp,
      'accountFrom': accountFrom,
      'accountTo': accountTo,
    };
  }

  factory Transfer.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Transfer(
      uuid: map['uuid'],
      amount: map['amount'],
      timestamp: map['timestamp'],
      accountFrom: map['accountFrom'],
      accountFromName: map['accountFromName'],
      accountTo: map['accountTo'],
      accountToName: map['accountToName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Transfer.fromJson(String source) =>
      Transfer.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Transfer(uuid: $uuid, amount: $amount, timestamp: $timestamp, accountFrom: $accountFrom, accountFromName: $accountFromName, accountTo: $accountTo, accountToName: $accountToName)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Transfer &&
        o.uuid == uuid &&
        o.amount == amount &&
        o.timestamp == timestamp &&
        o.accountFrom == accountFrom &&
        o.accountFromName == accountFromName &&
        o.accountTo == accountTo &&
        o.accountToName == accountToName;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        amount.hashCode ^
        timestamp.hashCode ^
        accountFrom.hashCode ^
        accountFromName.hashCode ^
        accountTo.hashCode ^
        accountToName.hashCode;
  }
}
