import 'package:device_id/device_id.dart';
import 'package:flutter/foundation.dart';
import 'package:metro_info/models/app_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile with ChangeNotifier {
  AppUser appUser;
  String _deviceId;

  UserProfile(){
    _loadProfileData();
    _getDeviceInfo();
  }


  void _getDeviceInfo() async {
    String deviceid;

    deviceid = await DeviceId.getID;

    print('Your deviceid: $deviceid');

    _deviceId = deviceid;
    notifyListeners();
  }


  void _loadProfileData() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    appUser.firstName = prefs.getString('first_name');
    appUser.lastName = prefs.getString('last_name');
    appUser.mobile = prefs.getString('mobile');
    appUser.email = prefs.getString('email');
    appUser.dob = prefs.getString('dob');

    notifyListeners();
  }
}