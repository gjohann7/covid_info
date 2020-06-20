import 'package:flutter/material.dart';

class ChartData {
  final int id;
  final String label;
  final int value;
  final Color color;

  ChartData(this.id, this.label, this.value, this.color);

  static String commafy(int value) {
    return value.toString().replaceAllMapped(
        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}
