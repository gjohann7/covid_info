import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:covid_info/models/chart_data.dart';
import 'package:intl/intl.dart';

class HorizontalBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  HorizontalBarChart(this.seriesList, {this.animate});

  factory HorizontalBarChart.fromScratch(category) {
    return new HorizontalBarChart(
        _seriesChartData(category['title'], category['data']),
        animate: true);
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      animationDuration: Duration(milliseconds: 500),
      vertical: false,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.NoneRenderSpec(), showAxisLine: false),
      domainAxis:
          new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
    );
  }

  static List<charts.Series<ChartData, String>> _seriesChartData(
      String title, List<ChartData> data) {
    final formatter = new DateFormat(DateFormat.MONTH);
    return [
      new charts.Series<ChartData, String>(
        id: title,
        domainFn: (ChartData info, _) =>
            formatter.format(DateTime.parse(info.label)),
        measureFn: (ChartData info, _) => info.value,
        data: data,
        labelAccessorFn: (ChartData info, _) =>
            formatter.format(DateTime.parse(info.label)) +
            ': ${ChartData.commafy(info.value)} deaths',
      )
    ];
  }
}
