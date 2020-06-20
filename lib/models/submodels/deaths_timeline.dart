class DeathsTimeline {
  int id;
  final int deaths;
  final DateTime date;

  DeathsTimeline(this.deaths, this.date);

  Map<String, dynamic> toMap() {
    return {'deaths': deaths, 'date': date.toString()};
  }

  static DeathsTimeline fromMap(Map<String, dynamic> map) {
    return DeathsTimeline(map['deaths'], DateTime.parse(map['date']));
  }

  @override
  String toString() {
    return "{\n  deaths: $deaths,\n  date: $date\n}";
  }
}
