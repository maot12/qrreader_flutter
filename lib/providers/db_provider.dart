import 'dart:io';

import 'package:path/path.dart';
import 'package:qrreader/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {

  static Database? _database;

  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database?> get  database async {
    if(_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  Future<Database> initDB() async {

    //Path de donde almacenaremos la base de datos
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');
    print(path);

    //Creación de la base de datos
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE SCANS(
          id INTEGER PRIMARY KEY,
          tipo TEXT,
          valor TEXT
        )
        ''');
      },
    );
  }

  Future<int?>nuevoScanRaw(ScanModel scanModel) async {

    final id    = scanModel.id;
    final tipo  = scanModel.tipo;
    final valor = scanModel.valor;

    //verificar la base de datos
    final db = await database;

    final res = await db?.rawInsert('''
      INSERT INTO Scans ( id, tipo, valor )
        VALUES ( $id, '$tipo', '$valor' )
    ''');

    return res;
  }

  Future<int?>nuevoScan (ScanModel scanModel) async {
    final db = await database;
    final res = await db?.insert('Scans', scanModel.toJson());

    //Es eFuture<ScanModel?> insertado
    print(res);

    return res;
  }

  Future<ScanModel?> getScanById(int id) async{
    final db = await database;
    final res = await db?.query('Scans', where: 'id = ?', whereArgs: [id]);

    return res!.isNotEmpty
        ?ScanModel.fromJson(res.first)
        : null;
  }
  Future<List<ScanModel>?> getTodosLosScans() async{
    final db = await database;
    final res = await db?.query('Scans');

    return res!.isNotEmpty
        ? res.map((s) => ScanModel.fromJson(s)).toList()
        : [];
  }
  Future<List<ScanModel>?> getScansPorTipo(String tipo) async{
    final db = await database;
    final res = await db?.rawQuery('''
      SELECT * FROM Scans WHERE tipo = '$tipo'
    ''');

    return res!.isNotEmpty
        ? res.map((s) => ScanModel.fromJson(s)).toList()
        : [];
  }
  Future<int> updateScan (ScanModel nuevoScan) async {
    final db = await database;
    final res = await db!.update(
        'Scans',
        nuevoScan.toJson(),
        where: 'id = ?',
        whereArgs: [nuevoScan.id]
    );

    return res;
  }
  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db!.delete(
        'Scans',
    where: 'id = ?',
    whereArgs: [id]
    );

    return res;
  }
  Future<int> deleteAllScans() async {
    final db = await database;
    final res = await db!.rawDelete('''
      DELETE FROM Scans
    ''');
    return res;
  }
}