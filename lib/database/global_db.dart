import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:covid_info/models/global.dart';

class GlobalDb {
  static final GlobalDb _singleton = GlobalDb._internal();
  GlobalDb._internal();

  factory GlobalDb() {
    return _singleton;
  }

  DatabaseFactory dbFactory = databaseFactoryIo;

  final store = intMapStoreFactory.store('global');

  Database _database;

  Future<Database> get database async {
    if (_database == null) {
      await _openDb().then((db) {
        _database = db;
      });
    }
    return _database;
  }

  Future _openDb() async {
    final docsPath = await getApplicationDocumentsDirectory();
    final dbPath = join(docsPath.path, 'global.db');
    final db = await dbFactory.openDatabase(dbPath);
    return db;
  }

  Future insert(Global global) async {
    await store.delete(_database);
    await store.add(_database, global.toMap());
  }

  Future deleteAll() async {
    await store.delete(_database);
  }

  Future<List<Global>> getAll() async {
    await database;
    final finder = Finder(sortOrders: [
      SortOrder('id'),
    ]);
    final globalsSnapshot = await store.find(_database, finder: finder);
    return globalsSnapshot.map((snapshot) {
      final global = Global.fromMap(snapshot.value);
      global.id = snapshot.key;
      return global;
    }).toList();
  }
}
