import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
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
                      decoration:
                          const InputDecoration(labelText: 'First name'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'First name is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Last name'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Last name is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          labelText: 'Mobile phone number'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Mobile phone number is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Birth date'),
                      validator: (value) {
                        return null;
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
                            final prefs = await SharedPreferences.getInstance();

// set value
                            //prefs.setInt('first_name', counter);

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
}
