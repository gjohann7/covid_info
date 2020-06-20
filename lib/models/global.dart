import 'package:flutter/material.dart';
import 'chart_data.dart';

class Global {
  int id;
  bool fresh = true;
  final int newConfirmed;
  final int totalConfirmed;

  final int newDeaths;
  final int totalDeaths;

  final int newRecovered;
  final int totalRecovered;

  Global(this.newConfirmed, this.totalConfirmed, this.newDeaths,
      this.totalDeaths, this.newRecovered, this.totalRecovered);

  Object get confirmedCases {
    return {
      "title": "Confirmed",
      "color": Colors.blue[900],
      "new": ChartData.commafy(newConfirmed),
      "total": ChartData.commafy(totalConfirmed)
    };
  }

  Object get deathsCases {
    return {
      "title": "Deaths",
      "color": Colors.red[900],
      "new": ChartData.commafy(newDeaths),
      "total": ChartData.commafy(totalDeaths)
    };
  }

  Object get recoveredCases {
    return {
      "title": "Recovered",
      "color": Colors.green[900],
      "new": ChartData.commafy(newRecovered),
      "total": ChartData.commafy(totalRecovered)
    };
  }

  Object get lethality {
    int iid = 0;
    return {
      'title': 'Lethality',
      'subtitle': getLethality(),
      'data': new List<ChartData>.from([
        new ChartData(iid++, 'Cases', totalConfirmed, Colors.blue[900]),
        new ChartData(iid++, 'Deaths', totalDeaths, Colors.red[900]),
      ])
    };
  }

  Object get worldTotal {
    int iid = 0;
    return {
      'title': "World's Totals",
      'data': new List<ChartData>.from([
        new ChartData(iid++, 'Cases', totalConfirmed, Colors.blue[900]),
        new ChartData(iid++, 'Recovered', totalRecovered, Colors.green[900]),
        new ChartData(iid++, 'Deaths', totalDeaths, Colors.red[900]),
      ])
    };
  }

  String getLethality() {
    double lethality = totalDeaths / totalConfirmed * 100;
    return lethality.toStringAsFixed(2) + "%";
  }

  String getRoundedCases() {
    double cases = totalConfirmed / 1000000;
    return truncateTo2(cases) + "M";
  }

  String getNewCasesRatio() {
    double newCases = newConfirmed / totalConfirmed * 100;
    return newCases.toStringAsFixed(2) + "% of new cases";
  }

  String truncateTo2(double value) {
    final stringValue = value.toString();
    return stringValue.substring(0, stringValue.indexOf(".") + 2);
  }

  Map<String, dynamic> toMap() {
    return {
      'newConfirmed': newConfirmed,
      'totalConfirmed': totalConfirmed,
      'newDeaths': newDeaths,
      'totalDeaths': totalDeaths,
      'newRecovered': newRecovered,
      'totalRecovered': totalRecovered,
    };
  }

  static Global fromResponse(Map<String, dynamic> map) {
    return Global(map['NewConfirmed'], map['TotalConfirmed'], map['NewDeaths'],
        map['TotalDeaths'], map['NewRecovered'], map['TotalRecovered']);
  }

  static Global fromMap(Map<String, dynamic> map) {
    return Global(map['newConfirmed'], map['totalConfirmed'], map['newDeaths'],
        map['totalDeaths'], map['newRecovered'], map['totalRecovered']);
  }

  @override
  String toString() {
    return "{\n  id: $id,\n  newConfirmed: $newConfirmed,\n  totalConfirmed: $totalConfirmed," +
        "\n  newDeaths: $newDeaths,\n  totalDeaths: $totalDeaths," +
        "\n  newRecovered: $newRecovered,\n  totalRecovered: $totalRecovered\n}";
  }
}
