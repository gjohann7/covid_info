import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/chart_data.dart';

class StackedAreaLineChart extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  StackedAreaLineChart(this.seriesList, {this.animate});

  factory StackedAreaLineChart.fromScratch(data) {
    final recoveredTimeline = data.recoveredTimeline;
    final activeCasesTimeline = data.activeCasesTimeline;
    final deathsTimeline = data.deathsTimeline;
    return new StackedAreaLineChart(
      _seriesChartData(recoveredTimeline['data'], activeCasesTimeline['data'],
          deathsTimeline['data']),
      animate: true,
    );
  }

  @override
  State<StatefulWidget> createState() => new _StackedAreaLineChartState();

  static List<charts.Series<ChartData, DateTime>> _seriesChartData(
    List<ChartData> recoveredTimeline,
    List<ChartData> activeCasesTimeline,
    List<ChartData> deathsTimeline,
  ) {
    return [
      new charts.Series<ChartData, DateTime>(
        id: 'Recovered',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (ChartData info, _) => DateTime.parse(info.label),
        measureFn: (ChartData info, _) => info.value,
        data: recoveredTimeline,
      ),
      new charts.Series<ChartData, DateTime>(
        id: 'Active',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (ChartData info, _) => DateTime.parse(info.label),
        measureFn: (ChartData info, _) => info.value,
        data: activeCasesTimeline,
      ),
      new charts.Series<ChartData, DateTime>(
        id: 'Deaths',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (ChartData info, _) => DateTime.parse(info.label),
        measureFn: (ChartData info, _) => info.value,
        data: deathsTimeline,
      )
    ];
  }
}

class _StackedAreaLineChartState extends State<StackedAreaLineChart> {
  String _time;
  Map<String, num> _measures;

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    DateFormat formatter = new DateFormat.yMMMMd();
    DateTime dateTime;
    String time;
    final measures = <String, num>{};

    if (selectedDatum.isNotEmpty) {
      dateTime = DateTime.parse(selectedDatum.first.datum.label);
      time = formatter.format(dateTime);
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.value;
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
        defaultRenderer:
            new charts.LineRendererConfig(includeArea: true, stacked: true),
        behaviors: [
          new charts.SeriesLegend(),
          new charts.PanAndZoomBehavior(),
        ],
        selectionModels: [
          new charts.SelectionModelConfig(
            type: charts.SelectionModelType.info,
            changedListener: _onSelectionChanged,
          )
        ],
      )),
    ];

    final row = <Widget>[];
    final column = <Widget>[];

    if (_time != null) {
      row.add(Column(children: <Widget>[new Text(_time)]));
    }

    _measures?.forEach((String series, num value) {
      column.add(new Text('$series: ${ChartData.commafy(value)}'));
    });

    row.add(Column(children: column));

    if (row.isNotEmpty) {
      children.add(new Padding(
          padding: new EdgeInsets.only(top: 5.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row,
          )));
    }

    return new Column(children: children);
  }
}
