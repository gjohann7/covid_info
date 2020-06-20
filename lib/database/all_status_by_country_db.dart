import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:covid_info/models/all_status_by_country.dart';

class AllStatusByCountryDb {
  static final AllStatusByCountryDb _singleton =
      AllStatusByCountryDb._internal();
  AllStatusByCountryDb._internal();

  factory AllStatusByCountryDb() {
    return _singleton;
  }

  DatabaseFactory dbFactory = databaseFactoryIo;

  final store = intMapStoreFactory.store('all_status_by_country');

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
    final dbPath = join(docsPath.path, 'all_status_by_country.db');
    final db = await dbFactory.openDatabase(dbPath);
    return db;
  }

  Future insert(AllStatusByCountry allStatusByCountry) async {
    await store.delete(_database);
    await store.add(_database, allStatusByCountry.toMap());
  }

  Future deleteAll() async {
    await store.delete(_database);
  }

  Future<List<AllStatusByCountry>> getAll() async {
    await database;
    final finder = Finder(sortOrders: [
      SortOrder('id'),
    ]);
    final allStatusByCountrysSnapshot =
        await store.find(_database, finder: finder);
    return allStatusByCountrysSnapshot.map((snapshot) {
      final allStatusByCountry = AllStatusByCountry.fromMap(snapshot.value);
      allStatusByCountry.id = snapshot.key;
      return allStatusByCountry;
    }).toList();
  }
}
