import 'dart:async';
import 'package:sqflite/sql.dart';
import 'package:synchronized/synchronized.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Helper {
  final String path;

  Helper(this.path);

  Database _db;

  static int get _version => 1;
  final _lock = new Lock();

  static void _onCreate(Database db, int version) async {
    await db.transaction((txn) async {
      await txn.execute(
        'CREATE TABLE accounts (uuid TEXT PRIMARY KEY NOT NULL, name TEXT, initialamount REAL, icon TEXT )',
      );
    });
  }

  static void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Database version is updated, alter the table
    await db.transaction(
      (txn) async {
        await txn.execute(
          'DROP TABLE accounts',
        );
      },
    );
  }

  Future<Database> getDb() async {
    if (_db == null) {
      await _lock.synchronized(() async {
        // Check again once entering the synchronized block
        if (_db == null) {
          _db = await openDatabase(path,
              version: _version, onCreate: _onCreate, onUpgrade: _onUpgrade);
        }
      });
    }
    return _db;
  }
}

class DB {
  static Database _db;
  static String dbName = 'moneym.db';

  static Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      String _path = join(await getDatabasesPath(), dbName);
      _db = await Helper(_path).getDb();
    } catch (ex) {
      print(ex);
    }
  }

  static Future<List<Map<String, dynamic>>> query(String table) async {
    return await _db.transaction(
      (txn) async {
        return await txn.query(table);
      },
    );
  }

  // static Future<List<Fichaje>> getLastFichajes() async {
  //   List<Map<String, dynamic>> result = await _db.rawQuery(
  //       'SELECT * FROM ' + Fichaje.table + ' ORDER BY entrada DESC LIMIT 20; ');
  //   if (result.length > 0) {
  //     return List.generate(result.length, (int i) {
  //       return Fichaje.fromMap(result[i]);
  //     });
  //   } else {
  //     return null;
  //   }
  // }

  // static Future<bool> guardaDatosEnDB(
  //     String table, Map<String, dynamic> item) async {
  //   List<Map<String, dynamic>> _data = await _db.rawQuery(
  //       'SELECT UUID FROM ' + table + ' where uuid="' + item['uuid'] + '"');

  //   if (_data == null) {
  //     await _db.insert(table, item);
  //   } else
  //     await _db.update(table, item,
  //         where: "uuid = ?",
  //         whereArgs: [item['uuid']],
  //         conflictAlgorithm: ConflictAlgorithm.replace);
  //   return Future.value(true);
  // }

  // static Future<List<Dieta>> getLastDietas() async {
  //   List<Map<String, dynamic>> result = await _db.rawQuery(
  //       'SELECT * FROM ' + Dieta.table + ' ORDER BY fecha DESC LIMIT 20; ');

  //   if (result.length > 0) {
  //     return List.generate(result.length, (int i) {
  //       return Dieta.fromMap(result[i]);
  //     });
  //   } else {
  //     return null;
  //   }
  // }

  static Future<int> insert(String table, Map<String, dynamic> item) async {
    return await _db.transaction((txn) async {
      return await txn.insert(table, item,
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  static void deleteItem(String table, String uuid) async {
    await _db.delete(table, where: "uuid=?", whereArgs: [uuid]);
  }

  static void update(String table, Map<String, dynamic> item) async {
    await _db.update(
      table,
      item,
      where: "uuid = ?",
      whereArgs: [item['uuid']],
    );
  }
}
