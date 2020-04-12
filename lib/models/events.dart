class Events {
  int id;
  int lguId;
  int postedBy;
  String name;
  String content;
  String eventFrom;
  String eventTo;
  String broadcast;
  String createdAt;
  String updatedAt;

  Events(
      {this.id,
      this.lguId,
      this.postedBy,
      this.name,
      this.content,
      this.eventFrom,
      this.eventTo,
      this.broadcast,
      this.createdAt,
      this.updatedAt});

  Events.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lguId = json['lgu_id'];
    postedBy = json['posted_by'];
    name = json['name'];
    content = json['content'];
    eventFrom = json['event_from'];
    eventTo = json['event_to'];
    broadcast = json['broadcast'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lgu_id'] = this.lguId;
    data['posted_by'] = this.postedBy;
    data['name'] = this.name;
    data['content'] = this.content;
    data['event_from'] = this.eventFrom;
    data['event_to'] = this.eventTo;
    data['broadcast'] = this.broadcast;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  static List<Events> getMapEvents(List data) {
    List<Events> datatemp = [];
    data.forEach((item) {
      datatemp.add(Events(
        id: item['id'],
        lguId: item['lgu_id'],
        postedBy: item['posted_by'],
        name: item['name'],
        content: item['content'],
        eventFrom: item['event_from'],
        eventTo: item['event_to'],
        broadcast: item['broadcast'],
        createdAt: item['created_at'],
        updatedAt: item['updated_at'],
      ));
    });
    return datatemp;
  }
}
