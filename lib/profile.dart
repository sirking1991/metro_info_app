import 'package:flutter/material.dart';
import 'package:metro_info/models/app_user.dart';
import 'package:metro_info/repository/app_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_id/device_id.dart';
import 'package:flutter/services.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  bool _initialLoad = true;

  String _firstName = '';
  String _lastName = '';
  String _mobile = '';
  String _email = '';
  String _dob = '';
  String _deviceId;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

  }

  void getDeviceInfo() async {
    String deviceid;
    String imei;
    String meid;

    deviceid = await DeviceId.getID;
    try {
      imei = await DeviceId.getIMEI;
      meid = await DeviceId.getMEID;
    } on PlatformException catch (e) {
      print(e.message);
    }
    print('Your deviceid: $deviceid\nYour IMEI: $imei\nYour MEID: $meid');

    _deviceId = deviceid;

  }


  void _loadProfileData() async {

    getDeviceInfo();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _firstName = prefs.getString('first_name');
      _lastName = prefs.getString('last_name');
      _mobile = prefs.getString('mobile');
      _email = prefs.getString('email');
      _dob = prefs.getString('dob');
    });

    _initialLoad = false;

    print('Profile data loaded first_name=' + _firstName + ' las_name=' + _lastName);
  }


  @override
  Widget build(BuildContext context) {

    if(_initialLoad) _loadProfileData();

    final _formKey = GlobalKey<FormState>();


    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // BEGIN: navbar
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
            // END: navbar

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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      initialValue: _firstName,
                      decoration:
                          const InputDecoration(labelText: 'First name'),
                      validator: (value) {
                        if (value.isEmpty) return 'First name is required';
                        return null;
                      },
                      onSaved: (String v) {
                        _firstName = v;
                      },
                    ),
                    TextFormField(
                      initialValue: _lastName,
                      decoration: const InputDecoration(labelText: 'Last name'),
                      validator: (value) {
                        if (value.isEmpty) return 'Last name is required';
                        return null;
                      },
                      onSaved: (String v) {
                        _lastName = v;
                      },
                    ),
                    TextFormField(
                      initialValue: _mobile,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          labelText: 'Mobile phone number'),
                      validator: (value) {
                        if (value.isEmpty)
                          return 'Mobile phone number is required';
                        return null;
                      },
                      onSaved: (String v) {
                        _mobile = v;
                      },
                    ),
                    TextFormField(
                      initialValue: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        Pattern pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(value))
                          return 'Enter Valid Email';
                        else
                          return null;
                      },
                      onSaved: (String v) {
                        _email = v;
                      },
                    ),
                    TextFormField(
                      initialValue: _dob,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Birth date'),
                      validator: (value) {
                        return null;
                      },
                      onSaved: (String v) {
                        _dob = v;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: RaisedButton(
                        onPressed: () async {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (_formKey.currentState.validate()) {
                            // Process data.
                            // obtain shared preferences
                            _formKey.currentState.save();

                            SharedPreferences prefs = await SharedPreferences.getInstance();

                            // set value
                            prefs.setString('first_name', _firstName.trim());
                            prefs.setString('last_name', _lastName.trim());
                            prefs.setString('mobile', _mobile.trim());
                            prefs.setString('email', _email.trim());
                            prefs.setString('dob', _dob.trim());

                            print('Profile saved');

                            var appUser = new AppUser();
                            appUser.deviceID = _deviceId;
                            appUser.firstName = _firstName.trim();
                            appUser.lastName = _lastName.trim();
                            appUser.mobile = _mobile.trim();
                            appUser.email = _email.trim();
                            appUser.dob = _dob.trim();

                            var appUserRepository = new AppUserRepository();
                            appUserRepository.registerUser(appUser);

                            _displaySnackBar(context, 'Profile saved');
                          }
                        },
                        child: Text('Update'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  void _displaySnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}

