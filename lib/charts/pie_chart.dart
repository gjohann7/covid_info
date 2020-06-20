import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import '../models/chart_data.dart';

class PieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  PieChart(this.seriesList, {this.animate});

  factory PieChart.fromScratch(String title, List<ChartData> data) {
    return new PieChart(_seriesChartData(title, data), animate: true);
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        animationDuration: Duration(milliseconds: 700),
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 60,
            arcRendererDecorators: [new charts.ArcLabelDecorator()]));
  }

  static List<charts.Series<ChartData, int>> _seriesChartData(
      String title, List<ChartData> data) {
    return [
      new charts.Series<ChartData, int>(
          id: title,
          domainFn: (ChartData info, _) => info.id,
          measureFn: (ChartData info, _) => info.value,
          data: data,
          labelAccessorFn: (ChartData info, _) => info.label,
          colorFn: (ChartData info, _) =>
              charts.ColorUtil.fromDartColor(info.color))
    ];
  }
}
