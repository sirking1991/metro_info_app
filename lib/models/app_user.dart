import 'package:device_id/device_id.dart';
import 'package:flutter/foundation.dart';
import 'package:metro_info/repository/app_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUser extends ChangeNotifier {
  int id;
  String deviceId;
  String firstName;
  String lastName;
  String mobile;
  String email;
  String dob;
  int lguId;

  AppUser(){
    _loadProfileData();
    _getDeviceInfo();
  }

  save() {
    var appUserRepository = new AppUserRepository();
    appUserRepository.registerUser(this);
  }

  void _getDeviceInfo() async {
    String deviceid;

    deviceid = await DeviceId.getID;

    print('Your deviceid: $deviceid');

    deviceId = deviceid;

    notifyListeners();
  }

  void _loadProfileData() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    firstName = prefs.getString('first_name');
    lastName = prefs.getString('last_name');
    mobile = prefs.getString('mobile');
    email = prefs.getString('email');
    dob = prefs.getString('dob');

    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['device_id'] = this.deviceId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['dob'] = this.dob;
    data['lgu_id'] = this.lguId;
    return data;
  }
}