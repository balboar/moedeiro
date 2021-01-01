import 'dart:async';
import 'package:sqflite/sql.dart';
import 'package:synchronized/synchronized.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Helper {
  final String path;

  Helper(this.path);

  Database _db;

  static int get _version => 7;
  final _lock = new Lock();

  static void _onCreate(Database db, int version) async {
    await db.transaction((txn) async {
      await txn.execute(
        'CREATE TABLE accounts (uuid TEXT PRIMARY KEY NOT NULL, name TEXT, initialAmount REAL, icon TEXT )',
      );

      await txn.execute(
        'CREATE TABLE category (uuid TEXT PRIMARY KEY NOT NULL, name TEXT, parent TEXT, icon TEXT,type TEXT )',
      );

      await txn.execute(
        'CREATE TABLE transactions (uuid TEXT PRIMARY KEY NOT NULL, name TEXT, amount REAL, ' +
            ' category TEXT,account TEXT, timestamp INTEGER,FOREIGN KEY(account) REFERENCES accounts(uuid), ' +
            'FOREIGN KEY(category) REFERENCES category(uuid) )',
      );
      await txn.insert('category', {
        'uuid': '465c88a7-2234-4a69-804c-cddee611ee6d',
        'name': 'Intereses',
        'type': 'I'
      });
      await txn.insert('category', {
        'uuid': '94b3d98c-1280-4308-85ce-b5dc5fafde3a',
        'name': 'Otros',
        'type': 'I'
      });
      await txn.insert('category', {
        'uuid': '2534ab95-4c7b-4439-8885-f3a698ec4e78',
        'name': 'Propina',
        'type': 'I'
      });
      await txn.insert('category', {
        'uuid': '76f9cad1-07ac-4e23-bb63-5e870fe08c99',
        'name': 'Salario',
        'type': 'I'
      });
      await txn.insert('category', {
        'uuid': 'd4a5d470-13d7-4566-b2b9-d5ebd6a5217d',
        'name': 'Venta',
        'type': 'I'
      });
      await txn.insert('category', {
        'uuid': '51b6ff89-5681-4d42-9f7f-0e504c9cf2f5',
        'name': 'Comida y bebida',
        'type': 'E'
      });
      await txn.insert('category', {
        'uuid': '1d5966d3-76cb-4218-be42-b7f1e9c360a9',
        'name': 'Deporte',
        'type': 'E'
      });
      await txn.insert('category', {
        'uuid': '073f506b-fe0d-4961-bcf6-58bad7c8d3ac',
        'name': 'Automovil',
        'type': 'E'
      });
      await txn.insert('category', {
        'uuid': '68660ce7-f78b-4a54-b050-a9c8b751264c',
        'name': 'Teconologia',
        'type': 'E'
      });
      await txn.insert('category', {
        'uuid': '1d3ecba4-ec6c-45a4-a874-95f85c207a3d',
        'name': 'Movil',
        'type': 'E'
      });
      await txn.insert('category', {
        'uuid': 'd5d35c87-5454-423f-8b67-baa638d2bce1',
        'name': 'Otros',
        'type': 'E'
      });
      await txn.insert('category', {
        'uuid': '5acee860-15e8-4658-a78d-1f44fca4b1d4',
        'name': 'Viaje',
        'type': 'E'
      });
    });
  }

  static void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Database version is updated, alter the table
    await db.transaction(
      (txn) async {
        await txn.delete('category');
        await txn.insert('category', {
          'uuid': '465c88a7-2234-4a69-804c-cddee611ee6d',
          'name': 'Intereses',
          'type': 'I'
        });
        await txn.insert('category', {
          'uuid': '94b3d98c-1280-4308-85ce-b5dc5fafde3a',
          'name': 'Otros',
          'type': 'I'
        });
        await txn.insert('category', {
          'uuid': '2534ab95-4c7b-4439-8885-f3a698ec4e78',
          'name': 'Propina',
          'type': 'I'
        });
        await txn.insert('category', {
          'uuid': '76f9cad1-07ac-4e23-bb63-5e870fe08c99',
          'name': 'Salario',
          'type': 'I'
        });
        await txn.insert('category', {
          'uuid': 'd4a5d470-13d7-4566-b2b9-d5ebd6a5217d',
          'name': 'Venta',
          'type': 'I'
        });
        await txn.insert('category', {
          'uuid': '51b6ff89-5681-4d42-9f7f-0e504c9cf2f5',
          'name': 'Comida y bebida',
          'type': 'E'
        });
        await txn.insert('category', {
          'uuid': '1d5966d3-76cb-4218-be42-b7f1e9c360a9',
          'name': 'Deporte',
          'type': 'E'
        });
        await txn.insert('category', {
          'uuid': '073f506b-fe0d-4961-bcf6-58bad7c8d3ac',
          'name': 'Automovil',
          'type': 'E'
        });
        await txn.insert('category', {
          'uuid': '68660ce7-f78b-4a54-b050-a9c8b751264c',
          'name': 'Teconologia',
          'type': 'E'
        });
        await txn.insert('category', {
          'uuid': '1d3ecba4-ec6c-45a4-a874-95f85c207a3d',
          'name': 'Movil',
          'type': 'E'
        });
        await txn.insert('category', {
          'uuid': 'd5d35c87-5454-423f-8b67-baa638d2bce1',
          'name': 'Otros',
          'type': 'E'
        });
        await txn.insert('category', {
          'uuid': '5acee860-15e8-4658-a78d-1f44fca4b1d4',
          'name': 'Viaje',
          'type': 'E'
        });
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
  static String dbName = 'moedeiro.db';

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

  static Future<List<Map<String, dynamic>>> queryCategory(
      String table, String type) async {
    return await _db.transaction(
      (txn) async {
        return await txn.query(table, where: 'type=?', whereArgs: [type]);
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getTransactions() async {
    return await _db.transaction(
      (txn) async {
        return await txn.rawQuery(
            'SELECT a.*,b.name accountName,c.name categoryName FROM transactions a ' +
                'left outer join accounts b on b.uuid=a.account ' +
                'left outer join category c on c.uuid=a.category');
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getAllExpenses(
      String uuidAccount) async {
    return await _db.transaction(
      (txn) async {
        return await txn.rawQuery(
            'SELECT coalesce(sum(amount),0) amount FROM transactions a ' +
                'inner join category c on c.uuid=a.category and c.type="E" where a.account='
                    '"' +
                uuidAccount +
                '"');
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getAllIncomes(
      String uuidAccount) async {
    return await _db.transaction(
      (txn) async {
        return await txn.rawQuery(
            'SELECT coalesce(sum(amount),0) amount FROM transactions a ' +
                'inner join category c on c.uuid=a.category and c.type="I" where a.account='
                    '"' +
                uuidAccount +
                '"');
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getCategoryAndMovements() async {
    return await _db.transaction(
      (txn) async {
        return await txn.rawQuery(
            'SELECT  coalesce(sum(amount),0) amount,c.name,c.uuid FROM transactions a ' +
                'inner join category c on c.uuid=a.category group by 2,3 order by 1 desc LIMIT 5');
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
