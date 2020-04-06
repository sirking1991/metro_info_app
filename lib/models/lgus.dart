class LGUs {
  int id;
  String regionShortName;
  String name;
  String slug;
  Null createdAt;
  String updatedAt;

  LGUs(
      {this.id,
        this.regionShortName,
        this.name,
        this.slug,
        this.createdAt,
        this.updatedAt});

  LGUs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    regionShortName = json['region_short_name'];
    name = json['name'];
    slug = json['slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['region_short_name'] = this.regionShortName;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}