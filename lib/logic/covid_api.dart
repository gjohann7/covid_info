import 'dart:convert';

import 'package:covid_info/models/all_status_by_country.dart';
import 'package:covid_info/models/submodels/deaths_timeline.dart';
import 'package:covid_info/models/submodels/recovered_timeline.dart';
import 'package:covid_info/models/submodels/active_cases_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../models/global.dart';
import '../models/country.dart';
import 'all_status_by_country_bloc.dart';
import 'global_bloc.dart';
import 'country_bloc.dart';

Future<Global> fetchGlobal(GlobalBloc globalBloc) async {
  try {
    final response = await http.get('https://api.covid19api.com/summary');

    if (response.statusCode == 200) {
      final summary = json.decode(response.body);
      final globalDic = summary["Global"];
      final global = Global.fromResponse(globalDic);

      globalBloc.globalRenewSink.add(global);

      return global;
    } else {
      debugPrint('Failed to get response data');
      throw Exception("Failed to get response data");
    }
  } catch (error) {
    List<Global> globals = List<Global>.from(globalBloc.globalList);

    if (globals.isEmpty) {
      debugPrint('Failed to load data');
      throw Exception("Failed to load data");
    }

    globals.last.fresh = false;

    return globals.last;
  }
}

Future<AllStatusByCountry> fetchAllStatusByCountry(
    AllStatusByCountryBloc allStatusByCountryBloc,
    CountryBloc countryBloc,
    String country) async {
  try {
    Future<List<Country>> futureCountries = fetchCountries(countryBloc);

    String countrySlug = await futureCountries.then((value) {
      for (int i = 0; i < value.length; i++) {
        if (value[i].name.toLowerCase() == country) {
          return value[i].slug;
        }
      }
      return "";
    });

    if (countrySlug == "") {
      debugPrint('Country not found');
      throw Exception("Country not found");
    }

    final date = new DateTime.now();
    final formatter = new DateFormat('yyyy-MM-dd');
    String now = formatter.format(date);

    final response = await http.get('https://api.covid19api.com/country/' +
        countrySlug +
        '?from=2020-01-01T00:00:00Z&to=' +
        now +
        'T00:00:00Z');

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      final allStatusByCountry = AllStatusByCountry(country);
      body.forEach((element) {
        String stringDate = element['Date'];
        final elementDate = stringDate.substring(0, stringDate.indexOf("T"));

        final active = element['Active'];
        final deaths = element['Deaths'];
        final recovered = element['Recovered'];

        if (active > 0 || deaths > 0 || recovered > 0) {
          allStatusByCountry.actives.add(ActiveCasesTimeline.fromMap(
              {'active': active, 'date': elementDate}));

          allStatusByCountry.deaths.add(
              DeathsTimeline.fromMap({'deaths': deaths, 'date': elementDate}));

          allStatusByCountry.recovered.add(RecoveredTimeline.fromMap(
              {'recovered': recovered, 'date': elementDate}));
        }
      });

      allStatusByCountryBloc.allStatusByCountryRenewSink
          .add(allStatusByCountry);

      return allStatusByCountry;
    } else {
      debugPrint('Failed to get response data');
      throw Exception("Failed to get response data");
    }
  } catch (error) {
    List<AllStatusByCountry> allStatusByCountries =
        List<AllStatusByCountry>.from(
            allStatusByCountryBloc.allStatusByCountryList);

    if (allStatusByCountries.isEmpty) {
      debugPrint('Failed to load data');
      throw Exception("Failed to load data");
    }

    allStatusByCountries.last.fresh = false;

    return allStatusByCountries.last;
  }
}

Future<List<Country>> fetchCountries(CountryBloc countryBloc) async {
  try {
    final response = await http.get('https://api.covid19api.com/countries');

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);

      List<Country> countries = List<Country>.from(body.map((element) {
        final country = Country.fromResponse(element);
        countryBloc.countryRenewSink.add(country);
        return country;
      }));

      return countries;
    } else {
      debugPrint('Failed to get response data');
      throw Exception("Failed to get response data");
    }
  } catch (error) {
    List<Country> countries = await countryBloc.getAllCountries();

    if (countries.isEmpty) {
      debugPrint('Failed to load data');
      throw Exception("Failed to load data");
    }

    return countries;
  }
}
