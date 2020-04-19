import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:metro_info/networking/api_provider.dart';
import 'package:flutter/services.dart';
import 'package:metro_info/provider/app_state.dart';
import 'package:metro_info/views/region_lgu_selector.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _dob = TextEditingController();

  SharedPreferences _pref;

  AppUser _appUser = AppUser();

  bool _processing = false;

  @override
  void initState() {
    _getProfile();
    super.initState();
  }

  _getProfile() async {
    _pref = await SharedPreferences.getInstance();

    _appUser.firstName = _pref.getString("first_name") ?? "";
    _appUser.lastName = _pref.getString("last_name") ?? "";
    _appUser.mobile = _pref.getString("mobile") ?? "";
    _appUser.email = _pref.getString("email") ?? "";
    _appUser.dob = _pref.getString("dob") ?? "";
    _appUser.lguId = _pref.getInt("lgu_id") ?? "";

    setState(() {
      _firstName.text = _appUser.firstName;
      _lastName.text = _appUser.lastName;
      _mobile.text = _appUser.mobile;
      _email.text = _appUser.email;
      _dob.text = _appUser.dob;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(top: 30.0, right: 15.0, left: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Colors.black45,
                      iconSize: 30.0,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
              child: Text(
                'Your Profile',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                    fontSize: 32.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: 'First name'),
                    controller: _firstName,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Last name'),
                    controller: _lastName,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Mobile'),
                    controller: _mobile,
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Email'),
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  GestureDetector(
                    onTapDown: (e) async {
                      var _dt;
                      try {
                        _dt = null == _dob.text.toString() ||
                                '' == _dob.text.toString()
                            ? DateTime.now()
                            : DateTime.parse(
                                _dob.text.toString() + ' 00:00:00');
                      } catch (e) {
                        _dt = DateTime.now();
                      }

                      showDatePicker(
                        context: context,
                        initialDate: _dt,
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2021),
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.dark(),
                            child: child,
                          );
                        },
                      ).then((dt) {
                        if (null==dt) return;
                        _dt = dt.toString().split(' ');
                        setState(() {
                          _dob.text = _dt[0];
                        });
                      });
                    },
                    child: TextField(
                      controller: _dob,
                      readOnly: true,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(labelText: 'Birth date'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Consumer<AppState>(
                      builder: (BuildContext context, AppState appState,
                          Widget child) {
                        if (_processing) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return DialogButton(
                            color: appState.themeColor,
                            child: Text(
                              'Update',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () => _save(),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: DialogButton(
                      color: Provider.of<AppState>(context, listen: false)
                          .themeColor,
                      child: Text(
                        'Change Region/LGU',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegionLGUSelector()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _save() {
    setState(() => _processing = true);

    _appUser.firstName = _firstName.text.trim();
    _appUser.lastName = _lastName.text.trim();
    _appUser.mobile = _mobile.text.trim();
    _appUser.email = _email.text.trim();
    _appUser.dob = _dob.text.trim();

    // save to pref
    _pref.setString("device_id", _appUser.deviceId);
    _pref.setString("first_name", _appUser.firstName);
    _pref.setString("last_name", _appUser.lastName);
    _pref.setString("mobile", _appUser.mobile);
    _pref.setString("email", _appUser.email);
    _pref.setString("dob", _appUser.dob);

    var _themeColor = Provider.of<AppState>(context, listen: false).themeColor;

    // register user to API
    ApiProvider().post("register_app_user", _appUser.toJson()).then((response) {
      setState(() => _processing = false);
      Alert(
          context: context,
          title: "Profile updated",
          type: AlertType.success,
          buttons: [
            DialogButton(
              color: _themeColor,
              child: Text(
                "Okay",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            )
          ]).show();
    }).catchError((error) {
      setState(() => _processing = false);
      Alert(
          context: context,
          title: "Error",
          desc:
              "An error occured while registering your profile. Try again later.",
          type: AlertType.error,
          buttons: [
            DialogButton(
              color: _themeColor,
              child: Text(
                "Okay",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ]).show();
    });
  }
}

class AppUser {
  String deviceId;
  String firstName;
  String lastName;
  String mobile;
  String email;
  String dob;
  int lguId;

  AppUser() {
    _getDeviceInfo();
  }

  void _getDeviceInfo() async {
    deviceId = await DeviceId.getID;
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
