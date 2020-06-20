import 'dart:async';
import '../models/country.dart';
import '../database/country_db.dart';

class CountryBloc {
  CountryDb db;
  List<Country> _countryList;

  final _countriesStreamController =
      StreamController<List<Country>>.broadcast();
  final _countryRenewController = StreamController<Country>();
  final _countryDeleteAllController = StreamController<bool>();

  Stream<List<Country>> get country => _countriesStreamController.stream;
  StreamSink<List<Country>> get countriesSink =>
      _countriesStreamController.sink;
  StreamSink<Country> get countryRenewSink => _countryRenewController.sink;
  StreamSink<bool> get countryDeleteAllSink => _countryDeleteAllController.sink;

  CountryBloc() {
    db = CountryDb();
    getAllCountries();

    _countriesStreamController.stream.listen(returnAllCountries);
    _countryRenewController.stream.listen(_renew);
    _countryDeleteAllController.stream.listen(_deleteAll);
  }

  Future<List<Country>> getAllCountries() async {
    List<Country> country = await db.getAll();
    _countryList = country;
    countriesSink.add(country);
    return country;
  }

  List<Country> returnAllCountries(country) {
    return country;
  }

  List<Country> get countryList {
    return _countryList;
  }

  void _renew(Country country) {
    db.insert(country).then((result) {
      getAllCountries();
    });
  }

  void _deleteAll(bool confirm) {
    if (confirm) {
      db.deleteAll().then((result) {
        getAllCountries();
      });
    }
  }

  void dispose() {
    _countriesStreamController.close();
    _countryRenewController.close();
    _countryDeleteAllController.close();
  }
}
