import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import '../models/chart_data.dart';

class BarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  BarChart(this.seriesList, {this.animate});

  factory BarChart.fromScratch(String title, List<ChartData> data) {
    return new BarChart(_seriesChartData(title, data), animate: true);
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      animationDuration: Duration(milliseconds: 700),
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.NoneRenderSpec(), showAxisLine: false),
      domainAxis: new charts.OrdinalAxisSpec(showAxisLine: false),
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
    );
  }

  static List<charts.Series<ChartData, String>> _seriesChartData(
      String title, List<ChartData> data) {
    return [
      new charts.Series<ChartData, String>(
          id: title,
          domainFn: (ChartData info, _) => info.label,
          measureFn: (ChartData info, _) => info.value,
          data: data,
          labelAccessorFn: (ChartData info, _) => info.value
              .toString()
              .replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (Match m) => '${m[1]},'),
          colorFn: (ChartData info, _) =>
              charts.ColorUtil.fromDartColor(info.color))
    ];
  }
}
