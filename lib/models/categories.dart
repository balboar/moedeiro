import 'dart:convert';

//  'CREATE TABLE Categori (uuid TEXT PRIMARY KEY NOT NULL, name TEXT, parent TEXT, icon TEXT,type TEXT )',

class Categori {
  static String table = 'category';
  String? uuid;
  String? name;
  String? parent;
  String? type;
  String? defaultAccount;
  String? accountName;
  Categori({
    this.uuid,
    this.name,
    this.parent,
    this.type,
    this.accountName,
    this.defaultAccount,
  });

  Categori copyWith(
      {String? uuid,
      String? name,
      String? parent,
      String? type,
      String? accountUuid,
      String? accountName}) {
    return Categori(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      parent: parent ?? this.parent,
      type: type ?? this.type,
      defaultAccount: accountUuid ?? this.defaultAccount,
      accountName: accountName ?? this.accountName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
      'parent': parent,
      'type': type,
      'defaultAccount': defaultAccount,
    };
  }

  factory Categori.fromMap(Map<String, dynamic> map) {
    return Categori(
      uuid: map['uuid'],
      name: map['name'],
      parent: map['parent'],
      type: map['type'],
      defaultAccount: map['defaultAccount'],
      accountName: map['accountName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Categori.fromJson(String source) =>
      Categori.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Categori(uuid: $uuid, name: $name, parent: $parent, type: $type)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Categori &&
        o.uuid == uuid &&
        o.name == name &&
        o.parent == parent &&
        o.type == type;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^ name.hashCode ^ parent.hashCode ^ type.hashCode;
  }
}
