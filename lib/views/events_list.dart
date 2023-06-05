import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:metro_info/models/events.dart';
import 'package:metro_info/networking/api_provider.dart';
import 'package:metro_info/provider/app_state.dart';
import 'package:metro_info/views/events_detail.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventsList extends StatefulWidget {
  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  int _lgu = 0;

  late SharedPreferences _prefs;

  List<Events> _events = [];

  @override
  void initState() {
    _getPrefs();
    super.initState();
  }

  _getPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _lgu = _prefs.getInt("lgu_id")!!;

    var tmp = _prefs.getString("Events");
    if (null != tmp) {
      List<Events> tmpEventsList = Events.getMapEvents(json.decode(tmp));
      print("displaying Events from cache");
      setState(() => _events = tmpEventsList);
    }

    _getEventsFromAPI();
  }

  _getEventsFromAPI() {
    ApiProvider().get("events/$_lgu").then((response) {
      print("displaying Events from API");

      // save the Events to pref so we can load his later
      _prefs.setString("Events", json.encode(response));

      // rebuild
      setState(() => _events = Events.getMapEvents(response));
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, right: 25.0, left: 25.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0.0, 3.0),
              blurRadius: 15.0,
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Text(
                'Events',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            _events.length == 0 ? Padding(padding:EdgeInsets.all(10.0) ,child:Text("No scheduled events at the moment", style: TextStyle(fontSize: 15.0),)) : Column(
              children: <Widget>[
                ..._events.map((n) { return ListItem(n, _prefs); }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ListItem extends StatefulWidget {
  final _events;
  final _prefs;

  ListItem(this._events, this._prefs);

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    bool read = null !=
        widget._prefs.getBool("events_read_" + widget._events.id.toString());

    var jiffyEventFrom = Jiffy.parse(widget._events.eventFrom);
    var jiffyEventTo = Jiffy.parse(widget._events.eventTo);

    return Consumer<AppState>(
      builder: (BuildContext context, AppState appState, Widget? child) {
        return ListTile(
          leading: Icon(
            read ? Icons.calendar_today : Icons.calendar_today,
            size: 30.0,
            color: read ? Colors.grey : appState.themeColor,
          ),
          title: Text(
            widget._events.name,
            style: TextStyle(fontSize: 20.0),
          ),
          subtitle: Text(jiffyEventFrom.format(pattern: 'MMMM do yyyy, h:mm a') +
              ' to ' +
              jiffyEventTo.format(pattern: 'MMMM do yyyy, h:mm a')),
          enabled: true,
          contentPadding: EdgeInsets.only(top: 10.0, left: 10, right: 10),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    EventsDetail(widget._events)));
          },
        );
      },
    );
  }
}
