class News {
  int id;
  int lguId;
  String status;
  String postingDate;
  int postedBy;
  String subject;
  String content;
  String broadcast;
  String createdAt;
  String updatedAt;

  News(
      {this.id,
      this.lguId,
      this.status,
      this.postingDate,
      this.postedBy,
      this.subject,
      this.content,
      this.broadcast,
      this.createdAt,
      this.updatedAt});

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lguId = json['lgu_id'];
    status = json['status'];
    postingDate = json['posting_date'];
    postedBy = json['posted_by'];
    subject = json['subject'];
    content = json['content'];
    broadcast = json['broadcast'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lgu_id'] = this.lguId;
    data['status'] = this.status;
    data['posting_date'] = this.postingDate;
    data['posted_by'] = this.postedBy;
    data['subject'] = this.subject;
    data['content'] = this.content;
    data['broadcast'] = this.broadcast;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  static List<News> getMapNews(List data) {
    
    List<News> datatemp = [];
    data.forEach((item) {
      datatemp.add(News(
        id : item['id'],
        lguId : item['lgu_id'],
        status : item['status'],
        postingDate : item['posting_date'],
        postedBy : item['posted_by'],
        subject : item['subject'],
        content : item['content'],
        broadcast : item['broadcast'],
        createdAt : item['created_at'],
        updatedAt : item['updated_at']
        ));
    });
    return datatemp;
  }  
}
