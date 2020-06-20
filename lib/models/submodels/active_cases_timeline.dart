class ActiveCasesTimeline {
  int id;
  final int active;
  final DateTime date;

  ActiveCasesTimeline(this.active, this.date);

  Map<String, dynamic> toMap() {
    return {'active': active, 'date': date.toString()};
  }

  static ActiveCasesTimeline fromMap(Map<String, dynamic> map) {
    return ActiveCasesTimeline(map['active'], DateTime.parse(map['date']));
  }

  @override
  String toString() {
    return "{\n  active: $active,\n  date: $date\n}";
  }
}
