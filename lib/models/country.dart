class Country {
  int id;
  final String name;
  final String slug;

  Country(this.name, this.slug);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'slug': slug,
    };
  }

  static Country fromResponse(Map<String, dynamic> map) {
    return Country(
      map['Country'],
      map['Slug'],
    );
  }

  static Country fromMap(Map<String, dynamic> map) {
    return Country(
      map['name'],
      map['slug'],
    );
  }

  @override
  String toString() {
    return "{\n  id: $id,\n  name: $name,\n  slug: $slug\n}";
  }
}
