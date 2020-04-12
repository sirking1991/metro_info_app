import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:metro_info/models/events.dart';

class EventsDetail extends StatelessWidget {
  Events _events;
  
  EventsDetail(this._events);

  @override
  Widget build(BuildContext context) {
    var jiffyEventFrom = Jiffy(DateTime.parse( _events.eventFrom));
    var jiffyEventTo = Jiffy(DateTime.parse( _events.eventTo));

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_events.name,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                        fontSize: 32.0),
                  ),
                  Text(
                    jiffyEventFrom.format('MMMM do yyyy, h:mm a') + ' to ' + jiffyEventTo.format('MMMM do yyyy, h:mm a'),
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15.0),
                  ),
                  SizedBox(height: 20.0),
                  Text(_events.content, style: TextStyle(
                        color: Colors.black.withOpacity(0.7),                        
                        fontSize: 20.0))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
