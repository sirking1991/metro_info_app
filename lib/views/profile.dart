import 'package:flutter/material.dart';
import 'package:metro_info/models/app_user.dart';
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

    return Consumer<AppUser>(builder: (context, appUser, child) {
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
                        initialValue: appUser.firstName,
                        decoration:
                            const InputDecoration(labelText: 'First name'),
                        validator: (value) {
                          return value.isEmpty
                              ? 'First name is required'
                              : null;
                        },
                        onSaved: (String v) {
                          appUser.firstName = v;
                        },
                      ),
                      TextFormField(
                        initialValue: appUser.lastName,
                        decoration:
                            const InputDecoration(labelText: 'Last name'),
                        validator: (value) {
                          return value.isEmpty ? 'Last name is required' : null;
                        },
                        onSaved: (String v) {
                          appUser.lastName = v;
                        },
                      ),
                      TextFormField(
                        initialValue: appUser.mobile,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            labelText: 'Mobile phone number'),
                        validator: (value) {
                          return value.isEmpty
                              ? 'Mobile phone number is required'
                              : null;
                        },
                        onSaved: (String v) {
                          appUser.mobile = v;
                        },
                      ),
                      TextFormField(
                        initialValue: appUser.email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          Pattern pattern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regex = new RegExp(pattern);
                          return !regex.hasMatch(value)
                              ? 'Enter Valid Email'
                              : null;
                        },
                        onSaved: (String v) {
                          appUser.email = v;
                        },
                      ),
                      TextFormField(
                        initialValue: appUser.dob,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: 'Birth date'),
                        validator: (value) {
                          return null;
                        },
                        onSaved: (String v) {
                          appUser.dob = v;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: RaisedButton(
                          onPressed: () async {
                            // the form is invalid.
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();

                              appUser.save();

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
      );
    });
  }

  void _displaySnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
