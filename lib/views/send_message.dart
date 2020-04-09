import 'package:flutter/material.dart';

class SendMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

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
                'Send Message',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                    fontSize: 32.0),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      maxLines: 3,
                      maxLength: 256,
                      decoration:
                          const InputDecoration(labelText: 'Your message',),
                      validator: (value) {
                        return value.isEmpty ? 'Message is required' : null;
                      },
                    ),
                    SizedBox(height: 10.0,),
                    Row(children: <Widget>[
                      Icon(Icons.camera),
                      SizedBox(width: 10.0,),
                      Text('Attach photo', style: TextStyle(fontSize: 18.0),)
                    ],),                    
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: RaisedButton(
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (Form.of(context).validate()) {
                            // Process data.
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.send),
                            SizedBox(width: 10.0,),
                            Text('Send'),
                          ],
                        ),
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
