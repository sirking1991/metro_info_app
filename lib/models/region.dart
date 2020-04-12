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

  static List<Region> getMapRegion(List data) {
    // print(data);
    List<Region> datatemp = [];
    data.forEach((item) {
      datatemp.add(Region(
        id: item['id'],
        name: item['name'],
        shortName: item['short_name'],
      ));
      // print(datatemp);
    });
    return datatemp;
  }
}
