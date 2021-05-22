import 'dart:async';
import 'package:sqflite/sql.dart';
import 'package:synchronized/synchronized.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class Helper {
  final String path;

  Helper(this.path);

  Database? _db;

  static int get _version => 13;
  final _lock = new Lock();

  static void _onCreate(Database db, int version) async {
    await db.transaction((txn) async {
      await txn.execute(
        'CREATE TABLE accounts (uuid TEXT PRIMARY KEY NOT NULL, name TEXT, initialAmount REAL, icon TEXT,position INTEGER  )',
      );

      await txn.execute(
        'CREATE TABLE category (uuid TEXT PRIMARY KEY NOT NULL, name TEXT, parent TEXT, icon TEXT,type TEXT )',
      );

      await txn.execute(
        'CREATE TABLE transactions (uuid TEXT PRIMARY KEY NOT NULL, name TEXT, amount REAL, ' +
            ' category TEXT,account TEXT, timestamp INTEGER,FOREIGN KEY(account) REFERENCES accounts(uuid), ' +
            'FOREIGN KEY(category) REFERENCES category(uuid) )',
      );

      await txn.execute(
        'CREATE TABLE transfers (uuid TEXT PRIMARY KEY NOT NULL,amount REAL, ' +
            ' accountFrom TEXT,accountTo TEXT, timestamp INTEGER,FOREIGN KEY(accountFrom) REFERENCES accounts(uuid), ' +
            'FOREIGN KEY(accountTo) REFERENCES accounts(uuid) )',
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
    await db.transaction((txn) async {
      await txn.execute(
        'CREATE TABLE transfers (uuid TEXT PRIMARY KEY NOT NULL,amount REAL, ' +
            ' accountFrom TEXT,accountTo TEXT, timestamp INTEGER,FOREIGN KEY(accountFrom) REFERENCES accounts(uuid), ' +
            'FOREIGN KEY(accountTo) REFERENCES accounts(uuid) )',
      );
    });
  }

  Future<Database?> getDb() async {
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
  static Database? _db;
  static String dbName = 'moedeiro.db';

  static Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      String _path = p.join(await (getDatabasesPath()), dbName);
      _db = await Helper(_path).getDb();
    } catch (ex) {
      print(ex);
    }
  }

  static Future<List<Map<String, dynamic>>> query(String table,
      {String? where, List<dynamic>? whereArgs}) async {
    return await _db!.transaction(
      (txn) async {
        if (where != null && whereArgs != null)
          return await txn.query(table, where: where, whereArgs: whereArgs);
        else
          return await txn.query(table);
      },
    );
  }

  static Future<List<Map<String, dynamic>>> queryCategory(
      String table, String type) async {
    return await _db!.transaction(
      (txn) async {
        return await txn.query(table,
            where: 'type=?', whereArgs: [type], orderBy: 'name');
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getTransactions() async {
    return await _db!.transaction(
      (txn) async {
        return await txn.rawQuery(
          'SELECT a.*,b.name accountName,c.name categoryName,coalesce(b.initialAmount,0.0) initialAmount FROM transactions a ' +
              'left outer join accounts b on b.uuid=a.account ' +
              'left outer join category c on c.uuid=a.category order by a.timestamp desc',
        );
      },
    );
  }

  static Future<List<Map<String, dynamic>>> searchTransactions(
      String query) async {
    return await _db!.transaction(
      (txn) async {
        return await txn.rawQuery(
          'SELECT a.*,b.name accountName,c.name categoryName,coalesce(b.initialAmount,0.0) initialAmount FROM transactions a ' +
              'left outer join accounts b on b.uuid=a.account ' +
              "left outer join category c on c.uuid=a.category where a.name LIKE  '%$query%'  order by a.timestamp desc",
        );
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getAccountTransactions(
      String accountUuid) async {
    return await _db!.transaction(
      (txn) async {
        return await txn.rawQuery(
            'SELECT a.*,b.name accountName,c.name categoryName,coalesce(b.initialAmount,0.0) initialAmount FROM transactions a ' +
                'left outer join accounts b on b.uuid=a.account ' +
                'left outer join category c on c.uuid=a.category where a.account=? order by a.timestamp desc',
            [accountUuid]);
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getAccounts() async {
    return await _db!.transaction(
      (txn) async {
        return await txn.rawQuery(
            'select a.uuid,a.name,coalesce(a.initialAmount,0.0) initialAmount,a.position,a.icon,coalesce(a.initialAmount,0.0)+ ' +
                '(select coalesce(sum(bb.amount),0.0)  from accounts aa ' +
                'left outer join transactions bb on bb.account=aa.uuid where aa.uuid=a.uuid ) + ' +
                '(select coalesce(sum(amount),0.0) from transfers  where accountTo=a.uuid) ' +
                '	-(select coalesce(sum(d.amount),0.0) from transfers d where d.accountFrom=a.uuid)  amount ' +
                '	from accounts a   group by a.uuid,a.name,a.initialAmount,a.position order by a.position  ');
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getTransfers() async {
    return await _db!.transaction(
      (txn) async {
        return await txn.rawQuery(
          'SELECT a.*,b.name accountFromName,c.name accountToName FROM transfers a ' +
              'left outer join accounts b on b.uuid=a.accountFrom ' +
              'left outer join accounts c on c.uuid=a.accountTo order by a.timestamp desc',
        );
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getTransactionsPerWeek() async {
    return await _db!.transaction(
      (txn) async {
        return await txn.rawQuery(
          'SELECT sum(abs(a.amount)) amount,a.account,strftime("%W",datetime( substr(a.timestamp,1,10), "unixepoch"))   AS weekofyear  FROM transactions a ' +
              'left outer join category c on c.uuid=a.category where c.type="E" group by 2,3 order by 2 desc',
        );
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getAllExpenses(
      String uuidAccount) async {
    return await _db!.transaction(
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

  static Future<List<Map<String, dynamic>>> getExpensesLastMonth(
      String uuidAccount) async {
    return await _db!.transaction(
      (txn) async {
        return await txn.rawQuery(
            'SELECT coalesce(sum(amount),0) amount FROM transactions a ' +
                'inner join category c on c.uuid=a.category and c.type="E" where ' +
                ' date( substr(a.timestamp,1,10), "unixepoch")>= date("now","start of month") and a.account='
                    '"' +
                uuidAccount +
                '"');
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getTrasactionsLast6MonthByAccount(
      String? uuidAccount) async {
    return await _db!.transaction(
      (txn) async {
        return await txn.rawQuery(
            '   SELECT sum(abs(a.amount)) amount,strftime("%m",datetime( substr(a.timestamp,1,10), "unixepoch"))   AS monthofyear, ' +
                ' strftime("%Y",datetime( substr(a.timestamp,1,10), "unixepoch"))   AS year,c.type   FROM transactions a '
                    'left outer join category c on c.uuid=a.category where a.account='
                    '"' +
                uuidAccount! +
                '" and date( substr(a.timestamp,1,10), "unixepoch") > date("now","-0.5 YEAR") ' +
                ' group by 2,3,4 order by 3 ,2 ');
      },
    );
  }

  static Future<List<Map<String, dynamic>>>
      getTrasactionsLast6MonthByAccountAndDay(String uuidAccount) async {
    return await _db!.transaction(
      (txn) async {
        return await txn.rawQuery('SELECT round(sum(z.amount),2) amount, z.dayofYear, z.monthofyear, z.year FROM ' +
            '(SELECT sum(a.amount) amount, ' +
            'strftime("%d", datetime(substr(a.timestamp, 1, 10), "unixepoch")) AS dayofyear, ' +
            'strftime("%m", datetime(substr(a.timestamp, 1, 10), "unixepoch")) AS monthofyear,' +
            'strftime("%Y", datetime(substr(a.timestamp, 1, 10), "unixepoch")) AS YEAR ' +
            'FROM transactions a   WHERE a.account=   "' +
            uuidAccount +
            '" ' +
            '  AND date(substr(a.timestamp, 1, 10), "unixepoch") > date("now", "-0.5 YEAR")  ' +
            'GROUP BY 2,  3, 4  ' +
            'UNION SELECT sum(a.amount) amount, ' +
            '           strftime("%d", datetime(substr(a.timestamp, 1, 10), "unixepoch")) AS dayofyear, ' +
            '            strftime("%m", datetime(substr(a.timestamp, 1, 10), "unixepoch")) AS monthofyear, ' +
            '            strftime("%Y", datetime(substr(a.timestamp, 1, 10), "unixepoch")) AS YEAR ' +
            'FROM transfers a WHERE a.accountTo= "' +
            uuidAccount +
            '" ' +
            'AND date(substr(a.timestamp, 1, 10), "unixepoch") > date("now", "-0.5 YEAR") ' +
            'GROUP BY 2,   3,  4 ' +
            'UNION SELECT -sum(a.amount) amount, ' +
            '             strftime("%d", datetime(substr(a.timestamp, 1, 10), "unixepoch")) AS dayofyear, ' +
            '             strftime("%m", datetime(substr(a.timestamp, 1, 10), "unixepoch")) AS monthofyear, ' +
            '             strftime("%Y", datetime(substr(a.timestamp, 1, 10), "unixepoch")) AS YEAR ' +
            'FROM transfers a WHERE a.accountFrom= "' +
            uuidAccount +
            '" ' +
            'AND date(substr(a.timestamp, 1, 10), "unixepoch") > date("now", "-0.5 YEAR") ' +
            'GROUP BY 2, 3, 4   ORDER BY 4,  3,  2) AS z ' +
            'GROUP BY 2, 3, 4 ORDER BY 4, 3,  2');
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getTrasactionsLast6Month() async {
    return await _db!.transaction(
      (txn) async {
        return await txn.rawQuery(
            '   SELECT sum(abs(a.amount)) amount,strftime("%m",datetime( substr(a.timestamp,1,10), "unixepoch"))   AS monthofyear, ' +
                ' strftime("%Y",datetime( substr(a.timestamp,1,10), "unixepoch"))   AS year,c.type   FROM transactions a '
                    'left outer join category c on c.uuid=a.category where date( substr(a.timestamp,1,10), "unixepoch") > date("now","-0.5 YEAR") ' +
                ' group by 2,3,4 order by 3 ,2 ');
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getTrasactionsByMonthAndCategory(
      String month, String year) async {
    return await _db!.transaction(
      (txn) async {
        return await txn.rawQuery(
            'SELECT round(sum(abs(a.amount)),2) amount,c.name,c.uuid,count(a.uuid) total  FROM transactions a '
                    'left outer join category c on c.uuid=a.category where c.type="E" and ' +
                ' strftime("%m",datetime( substr(a.timestamp,1,10), "unixepoch"))=? and ' +
                'strftime("%Y",datetime( substr(a.timestamp,1,10), "unixepoch")) =?    group by 2,3 order by 1 desc ,2  desc',
            [month, year]);
      },
    );
  }

  static Future<List<Map<String, dynamic>>>
      getTrasactionSummaryByMonthAndCategory(String month, String year) async {
    return await _db!.transaction(
      (txn) async {
        return await txn.rawQuery(
            ' SELECT round(sum(abs(a.amount)),2) amount,c.type,count(a.uuid) total  FROM transactions a ' +
                'left outer join category c on c.uuid=a.category where ' +
                ' strftime("%m",datetime( substr(a.timestamp,1,10), "unixepoch"))=? and ' +
                'strftime("%Y",datetime( substr(a.timestamp,1,10), "unixepoch")) =?    group by 2 order by 1 desc ,2  desc',
            [month.padLeft(2, '0'), year]);
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getTrasactionsByCategoryMonth(
      String month, String year, String uuid) async {
    return await _db!.transaction(
      (txn) async {
        return await txn.rawQuery(
            'SELECT a.*  FROM transactions a '
                    'left outer join category c on c.uuid=a.category where c.type="E" and ' +
                ' strftime("%m",datetime( substr(a.timestamp,1,10), "unixepoch"))=? and ' +
                'strftime("%Y",datetime( substr(a.timestamp,1,10), "unixepoch")) =? and a,category=? ',
            [month, year, uuid]);
      },
    );
  }

  static Future<List<Map<String, dynamic>>>
      getTrasactionsGroupedByMonthAndCategory() async {
    return await _db!.transaction(
      (txn) async {
        return await txn.rawQuery(
            '   SELECT round(sum(abs(a.amount)),2) amount,strftime("%m",datetime( substr(a.timestamp,1,10), "unixepoch"))   AS monthofyear, ' +
                ' strftime("%Y",datetime( substr(a.timestamp,1,10), "unixepoch"))   AS year,c.type   FROM transactions a '
                    'left outer join category c on c.uuid=a.category where c.type="E"  group by 2,3,4 order by 3 ,2 ');
      },
    );
  }

  static Future<List<Map<String, dynamic>>>
      getTrasactionsLastMonthByCategory() async {
    return await _db!.transaction(
      (txn) async {
        return await txn.rawQuery(
            '   SELECT sum(abs(a.amount)) amount,c.name  FROM transactions a '
                    'left outer join category c on c.uuid=a.category where c.type="E" ' +
                ' and date( substr(a.timestamp,1,10), "unixepoch") >= date("now","start of month")' +
                ' group by 2 order by 1 desc limit 6 ');
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getAllIncomes(
      String uuidAccount) async {
    return await _db!.transaction(
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
    return await _db!.transaction(
      (txn) async {
        return await txn.rawQuery(
            'SELECT  coalesce(sum(ABS(amount)),0) amount,c.name,c.uuid FROM transactions a ' +
                'inner join category c on c.uuid=a.category where c.type="E" group by 2,3 order by 1 desc LIMIT 5');
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
    return await _db!.transaction((txn) async {
      return await txn.insert(table, item,
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  static Future<int> deleteItem(String table, String uuid) async {
    return await _db!.delete(table, where: "uuid=?", whereArgs: [uuid]);
  }

  static Future<int> update(String table, Map<String, dynamic> item) async {
    return await _db!.update(
      table,
      item,
      where: "uuid = ?",
      whereArgs: [item['uuid']],
    );
  }
}
