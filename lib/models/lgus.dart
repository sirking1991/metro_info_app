class LGU {
  int id;
  String regionShortName;
  String name;
  String slug;
  String logoUrl;
  String color;
  String createdAt;
  String updatedAt;

  LGU(
      {this.id=0,
      this.regionShortName="",
      this.name="",
      this.slug="",
      this.logoUrl="",
      this.color="",
      this.createdAt="",
      this.updatedAt=""});

  LGU.fromJson(Map<String, dynamic> json):
    id = json['id'],
    regionShortName = json['region_short_name'],
    name = json['name'],
    slug = json['slug'],
    logoUrl = json['logo_url'],
    color = json['color'],
    createdAt = json['created_at'],
    updatedAt = json['updated_at'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['region_short_name'] = this.regionShortName;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['logo_url'] = this.logoUrl;
    data['color'] = this.color;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  static List<LGU> getMapLGUs(List data) {
    
    List<LGU> datatemp = [];
    data.forEach((item) {
      datatemp.add(LGU(
          id: item["id"],
          name: item["name"],
          updatedAt: item["updated_at"],
          regionShortName: item["region_short_name"],
          slug: item["slug"],
          logoUrl: item["logo_url"],
          color: item["color"],
          createdAt: item["create_at"]));
    });
    return datatemp;
  }
}
