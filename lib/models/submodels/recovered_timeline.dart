class RecoveredTimeline {
  int id;
  final int recovered;
  final DateTime date;

  RecoveredTimeline(this.recovered, this.date);

  Map<String, dynamic> toMap() {
    return {'recovered': recovered, 'date': date.toString()};
  }

  static RecoveredTimeline fromMap(Map<String, dynamic> map) {
    return RecoveredTimeline(map['recovered'], DateTime.parse(map['date']));
  }

  @override
  String toString() {
    return "{\n  recovered: $recovered,\n  date: $date\n}";
  }
}
