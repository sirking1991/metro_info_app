import 'package:flutter/material.dart';
import 'package:metro_info/models/app_user.dart';
import 'package:metro_info/providers/user_profile.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print('Profile build');

    return Consumer<UserProfile>(
      builder: (context, userProfile, child) => Scaffold(
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
                          initialValue: userProfile.appUser.firstName,
                          decoration:
                              const InputDecoration(labelText: 'First name'),
                          validator: (value) {
                            return value.isEmpty ? 'First name is required' : null;
                          },
                          onSaved: (String v) {
                            userProfile.appUser.firstName = v;
                          },
                        ),
                        TextFormField(
                          initialValue: userProfile.appUser.lastName,
                          decoration: const InputDecoration(labelText: 'Last name'),
                          validator: (value) {
                            return value.isEmpty ? 'Last name is required' : null;
                          },
                          onSaved: (String v) {
                            userProfile.appUser.lastName = v;
                          },
                        ),
                        TextFormField(
                          initialValue: userProfile.appUser.mobile,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                              labelText: 'Mobile phone number'),
                          validator: (value) {
                            return value.isEmpty ? 'Mobile phone number is required' : null;
                          },
                          onSaved: (String v) {
                            userProfile.appUser.mobile = v;
                          },
                        ),
                        TextFormField(
                          initialValue: userProfile.appUser.email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            Pattern pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regex = new RegExp(pattern);
                            return !regex.hasMatch(value) ? 'Enter Valid Email' : null;
                          },
                          onSaved: (String v) {
                            userProfile.appUser.email = v;
                          },
                        ),
                        TextFormField(
                          initialValue: userProfile.appUser.dob,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: 'Birth date'),
                          validator: (value) {
                            return null;
                          },
                          onSaved: (String v) {
                            userProfile.appUser.dob = v;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child: RaisedButton(
                            onPressed: () async {

                              //final FormState form = Form.of(context);
//                             final form = _formKey.currentState;

                              // Validate will return true if the form is valid, or false if
                              // the form is invalid.
                              if (_formKey.currentState.validate()) {
                                // Process data.
                                // obtain shared preferences
                                _formKey.currentState.save();

                                // set value
                                userProfile.appUser.firstName = _firstName.trim();
                                userProfile.appUser.lastName = _lastName.trim();
                                userProfile.appUser.mobile = _mobile.trim();
                                userProfile.appUser.email = _email.trim();
                                userProfile.appUser.dob = _dob.trim();

                                print('Profile saved');

                                var appUser = new AppUser();
                                appUser.deviceId = _deviceId;
                                appUser.firstName = _firstName.trim();
                                appUser.lastName = _lastName.trim();
                                appUser.mobile = _mobile.trim();
                                appUser.email = _email.trim();
                                appUser.dob = _dob.trim();

                                var appUserRepository = new AppUserRepository();
                                appUserRepository.registerUser(userProfile.appUser.);

                                _displaySnackBar(context, 'Profile saved');
                              }
                            },
                            child: Text('Update'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }


  void _displaySnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}

