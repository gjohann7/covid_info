import 'dart:async';
import '../models/all_status_by_country.dart';
import '../database/all_status_by_country_db.dart';

class AllStatusByCountryBloc {
  AllStatusByCountryDb db;
  List<AllStatusByCountry> _allStatusByCountryList;

  final _allStatusByCountriesStreamController =
      StreamController<List<AllStatusByCountry>>.broadcast();
  final _allStatusByCountryRenewController =
      StreamController<AllStatusByCountry>();
  final _allStatusByCountryDeleteAllController = StreamController<bool>();

  Stream<List<AllStatusByCountry>> get allStatusByCountries =>
      _allStatusByCountriesStreamController.stream;
  StreamSink<List<AllStatusByCountry>> get allStatusByCountriesSink =>
      _allStatusByCountriesStreamController.sink;
  StreamSink<AllStatusByCountry> get allStatusByCountryRenewSink =>
      _allStatusByCountryRenewController.sink;
  StreamSink<bool> get allStatusByCountryDeleteAllSink =>
      _allStatusByCountryDeleteAllController.sink;

  AllStatusByCountryBloc() {
    db = AllStatusByCountryDb();
    getAllStatusByCountries();

    _allStatusByCountriesStreamController.stream
        .listen(returnAllStatusByCountries);
    _allStatusByCountryRenewController.stream.listen(_renew);
    _allStatusByCountryDeleteAllController.stream.listen(_deleteAll);
  }

  Future getAllStatusByCountries() async {
    List<AllStatusByCountry> allStatusByCountries = await db.getAll();
    _allStatusByCountryList = allStatusByCountries;
    allStatusByCountriesSink.add(allStatusByCountries);
  }

  List<AllStatusByCountry> returnAllStatusByCountries(allStatusByCountries) {
    return allStatusByCountries;
  }

  List<AllStatusByCountry> get allStatusByCountryList {
    return _allStatusByCountryList;
  }

  void _renew(AllStatusByCountry allStatusByCountry) {
    db.insert(allStatusByCountry).then((result) {
      getAllStatusByCountries();
    });
  }

  void _deleteAll(bool confirm) {
    if (confirm) {
      db.deleteAll().then((result) {
        getAllStatusByCountries();
      });
    }
  }

  void dispose() {
    _allStatusByCountriesStreamController.close();
    _allStatusByCountryRenewController.close();
    _allStatusByCountryDeleteAllController.close();
  }
}
