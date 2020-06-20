import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:covid_info/models/country.dart';

class CountryDb {
  static final CountryDb _singleton = CountryDb._internal();
  CountryDb._internal();

  factory CountryDb() {
    return _singleton;
  }

  DatabaseFactory dbFactory = databaseFactoryIo;

  final store = intMapStoreFactory.store('country');

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
    final dbPath = join(docsPath.path, 'country.db');
    final db = await dbFactory.openDatabase(dbPath);
    return db;
  }

  Future insert(Country country) async {
    await store.delete(_database);
    await store.add(_database, country.toMap());
  }

  Future deleteAll() async {
    await store.delete(_database);
  }

  Future<List<Country>> getAll() async {
    await database;
    final finder = Finder(sortOrders: [
      SortOrder('id'),
    ]);
    final countriesSnapshot = await store.find(_database, finder: finder);
    return countriesSnapshot.map((snapshot) {
      final country = Country.fromMap(snapshot.value);
      country.id = snapshot.key;
      return country;
    }).toList();
  }
}
