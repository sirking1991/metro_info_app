class AppUser {
  int id;
  String deviceID;
  String firstName;
  String lastName;
  String mobile;
  String email;
  String dob;
  int lguId;


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['device_id'] = this.deviceID;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['dob'] = this.dob;
    data['lgu_id'] = this.lguId;
    return data;
  }
}