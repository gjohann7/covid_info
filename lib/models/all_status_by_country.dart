import 'package:flutter/material.dart';
import 'chart_data.dart';
import 'submodels/active_cases_timeline.dart';
import 'submodels/deaths_timeline.dart';
import 'submodels/recovered_timeline.dart';

class AllStatusByCountry {
  int id;
  bool fresh = true;
  final String name;
  final List<DeathsTimeline> deaths;
  final List<ActiveCasesTimeline> actives;
  final List<RecoveredTimeline> recovered;

  AllStatusByCountry(this.name)
      : deaths = List<DeathsTimeline>(),
        actives = List<ActiveCasesTimeline>(),
        recovered = List<RecoveredTimeline>();

  AllStatusByCountry.fromDb(
      this.name, this.deaths, this.actives, this.recovered);

  Object get activeCasesTimeline {
    int iid = 0;
    return {
      'title': "Active Cases",
      'data': new List<ChartData>.from(actives.map((e) =>
          ChartData(iid++, e.date.toString(), e.active, Colors.blue[800])))
    };
  }

  Object get deathsTimeline {
    int iid = 0;
    return {
      'title': "Deaths",
      'data': new List<ChartData>.from(deaths.map((e) =>
          ChartData(iid++, e.date.toString(), e.deaths, Colors.red[800])))
    };
  }

  Object get recoveredTimeline {
    int iid = 0;
    return {
      'title': "Recovered",
      'data': new List<ChartData>.from(recovered.map((e) {
        return ChartData(
            iid++, e.date.toString(), e.recovered, Colors.green[800]);
      }))
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'deaths': deaths?.map((e) => e.toMap())?.toList(growable: false),
      'actives': actives?.map((e) => e.toMap())?.toList(growable: false),
      'recovered': recovered?.map((e) => e.toMap())?.toList(growable: false),
    };
  }

  static AllStatusByCountry fromMap(Map<String, dynamic> map) {
    return AllStatusByCountry.fromDb(
      map['name'],
      List<DeathsTimeline>.from(
          map['deaths'].map((e) => DeathsTimeline.fromMap(e))),
      List<ActiveCasesTimeline>.from(
          map['actives'].map((e) => ActiveCasesTimeline.fromMap(e))),
      List<RecoveredTimeline>.from(
          map['recovered'].map((e) => RecoveredTimeline.fromMap(e))),
    );
  }

  @override
  String toString() {
    return "{\n  name: $name," +
        "\n  recovered: " +
        recovered.toString() +
        "\n  deaths: " +
        deaths.toString() +
        ",\n  actives: " +
        actives.toString() +
        "\n}";
  }
}
