import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid_info/models/chart_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeSeriesChart extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final ChartData larger;

  TimeSeriesChart(this.seriesList, {this.animate, this.larger});

  factory TimeSeriesChart.fromScratch(category) {
    List<ChartData> data = category['data'];
    ChartData larger = data.first;
    data.forEach((element) {
      if (element.value > larger.value) {
        larger = element;
      }
    });
    return new TimeSeriesChart(
      _seriesChartData(category['title'], data, larger),
      animate: true,
      larger: larger,
    );
  }

  @override
  State<StatefulWidget> createState() => new _TimeSeriesChartState();

  static List<charts.Series<ChartData, DateTime>> _seriesChartData(
      String title, List<ChartData> data, ChartData larger) {
    return [
      new charts.Series<ChartData, DateTime>(
        id: title,
        domainFn: (ChartData info, _) => DateTime.parse(info.label),
        measureFn: (ChartData info, _) => info.value,
        data: data,
        colorFn: (ChartData datum, __) {
          if (datum == larger) {
            return charts.MaterialPalette.red.shadeDefault;
          } else {
            return charts.MaterialPalette.blue.shadeDefault;
          }
        },
        strokeWidthPxFn: (ChartData datum, __) {
          if (datum == larger) {
            return 4;
          } else {
            return 2;
          }
        },
      )
    ];
  }
}

class _TimeSeriesChartState extends State<TimeSeriesChart> {
  String _time;
  List<int> _measures;

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    DateFormat formatter = new DateFormat.yMMMMd();
    DateTime dateTime;
    String time;
    final measures = List<int>();

    if (selectedDatum.isNotEmpty) {
      dateTime = DateTime.parse(selectedDatum.first.datum.label);
      time = formatter.format(dateTime);
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures.add(datumPair.datum.value);
      });
    }

    setState(() {
      _time = time;
      _measures = measures;
    });
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      new Expanded(
          child: new charts.TimeSeriesChart(
        widget.seriesList,
        animate: widget.animate,
        animationDuration: Duration(milliseconds: 500),
        domainAxis: new charts.EndPointsTimeAxisSpec(),
        behaviors: [
          new charts.PanAndZoomBehavior(),
        ],
        selectionModels: [
          new charts.SelectionModelConfig(
            type: charts.SelectionModelType.info,
            changedListener: _onSelectionChanged,
          )
        ],
      ))
    ];

    final row = <Widget>[];

    if (_time != null) {
      row.add(new Text(_time + ' - '));
    }

    _measures?.forEach((num value) {
      if (widget.larger.value == value) {
        row.add(new Text(ChartData.commafy(value) + ' cases (larger)'));
      } else {
        row.add(new Text(ChartData.commafy(value) + ' cases'));
      }
    });

    if (row.isNotEmpty) {
      children.add(new Padding(
          padding: new EdgeInsets.only(top: 5.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row,
          )));
    }

    return new Column(
      children: children,
    );
  }
}
