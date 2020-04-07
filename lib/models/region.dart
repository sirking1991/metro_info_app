class Region {
  int id;
  String name;
  String shortName;

  Region({this.id, this.name, this.shortName});

  factory Region.fromJason(Map<String, dynamic> json) {
    return Region(
      id: json['id'],
      name: json['name'],
      shortName: json['short_name'],
    );
  }
}