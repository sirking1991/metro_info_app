import 'package:flutter/material.dart';
import 'package:metro_info/provider/app_state.dart';
import 'package:metro_info/views/main.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:metro_info/networking/api_provider.dart';
import "package:metro_info/models/region.dart";
import "package:metro_info/models/lgus.dart";
import 'package:shared_preferences/shared_preferences.dart';

class RegionLGUSelector extends StatefulWidget {
  final bool isIntial;
  RegionLGUSelector({Key key, this.isIntial = false}) : super(key: key);
  @override
  _RegionLGUSelector createState() {
    return _RegionLGUSelector();
  }
}

class _RegionLGUSelector extends State<RegionLGUSelector> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static List<Region> _regionList =
  [
    Region(id: 1, name: 'National Capital Region', shortName: 'NCR'),
    Region(id: 2, name: 'Ilocos Region', shortName: 'Region I'),
    Region(id: 3, name: 'Cordillera Administrative Region', shortName: 'CAR'),
    Region(id: 4, name: 'Cagayan Valley', shortName: 'Region II'),
    Region(id: 5, name: 'Central Luzon', shortName: 'Region III'),
    Region(id: 6, name: 'Calabarzon', shortName: 'Region IV-A'),
    Region(id: 7, name: 'Southwestern Tagalog Region', shortName: 'Mimaropa'),
    Region(id: 8, name: 'Bicol Region', shortName: 'Region V'),
    Region(id: 9, name: 'Western Visayas', shortName: 'Region VI'),
    Region(id: 10, name: 'Central Visayas', shortName: 'Region VII'),
    Region(id: 11, name: 'Eastern Visayas', shortName: 'Region VIII'),
    Region(id: 12, name: 'Zamboanga Peninsula', shortName: 'Region IX'),
    Region(id: 13, name: 'Northern Mindanao', shortName: 'Region X'),
    Region(id: 14, name: 'Davao Region', shortName: 'Region XI'),
    Region(id: 15, name: 'Soccsksargen', shortName: 'Soccsksargen'),
    Region(id: 16, name: 'Caraga Region', shortName: 'Region XIII'),
    Region(id: 17, name: 'Bangsamoro Autonomous Region in Muslim Mindanao', shortName: 'BARMM'),
  ];
  List<LGU> _lgusData = [];
  Region _selectedRegion = _regionList[0]; // Initially selected region is NCR
  LGU _lguValue; //initial value of LGUS
  LGU _initialValue = LGU(
      id: null,
      name: "select LGUs",
      createdAt: null,
      regionShortName: " ",
      slug: " ",
      updatedAt: " ");
  //this will be used to keep the initial value of the application
  bool done = false;

  //this function is for storing the data in the sharedPrefreces and to show snackbar and navigate .
  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_lguValue.id == null) {
      //acknowlege the user to first select lgus
      print("Please select the lgus first");
      Alert(
              buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
              type: AlertType.info,
              context: context,
              title: "metro_info",
              desc: "Please select LGU")
          .show();

      return;
    }

    // save to prefs
    prefs.setInt('lgu_id', _lguValue.id);
    prefs.setString("lgu_name", _lguValue.name);
    prefs.setString("lgu_slug", _lguValue.slug);
    prefs.setString("region_short_name", _lguValue.regionShortName);

    Provider.of<AppState>(context, listen: false).reset();

    Alert(
        context: context,
        style: AlertStyle(isCloseButton: false),
        title: "Preferred Region & LGU saved",
        buttons: [
          DialogButton(
              child: Text(
                "Okay ",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => MyHomePage()));
              })
        ]).show();
  }

  // this function is for making the list of map into list of region instance and setting the downdown items value
  List makeRegionList(List response) {
    List _region = Region.getMapRegion(response);
    return _region;
  }

  // this function is for making the list of map into list of LGUs instance and setting the downdown items value
  void getLGUs(lguValue) {
    ApiProvider().get("lgus/" + lguValue.shortName).then((response) {
      print(response);
      List _lGUsDataList = LGU.getMapLGUs(response);
      _lGUsDataList.add(_initialValue);
      setState(() {
        _lgusData = _lGUsDataList;
        _lguValue = _lGUsDataList[0];
      });
    }).catchError((error) {
      print("this is error");
      print(error);
    });
  }

  _getLGUList() async {
    List _lGUsDataone;
    try {
      if (!done) {
        _lGUsDataone =
            await ApiProvider().get("lgus/" + _selectedRegion.shortName);
        List _lGUsDataList = LGU.getMapLGUs(_lGUsDataone);

        _lgusData = _lGUsDataList;
        _lgusData.add(_initialValue);
        _lguValue = _initialValue;
      }

      done = true;

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
          child: FutureBuilder(
              future: _getLGUList(),
              builder: (context, AsyncSnapshot snapshot) {
                print(snapshot);
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 30.0, right: 15.0, left: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.arrow_back),
                                color: Colors.black45,
                                iconSize: 30.0,
                                onPressed: () {
                                  widget.isIntial
                                      ? Alert(
                                              buttons: [
                                              DialogButton(
                                                child: Text(
                                                  "OK",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                width: 120,
                                              )
                                            ],
                                              context: context,
                                              title:
                                                  "Please select Region to proceed")
                                          .show()
                                      : Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 30.0),
                        child: Text(
                          'Select Region & LGU',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontWeight: FontWeight.bold,
                              fontSize: 32.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(25.0),
                        child: DropdownButton(
                          value: _selectedRegion,
                          onChanged: (Region r) {
//                            setState(() {
//                              _selectedRegion = r;
//                            });
                            getLGUs(_selectedRegion);
                          },
                          items: _regionList
                              .map<DropdownMenuItem<Region>>((value) {
                            return DropdownMenuItem<Region>(
                              value: value,
                              child: Text(value.shortName),
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(25.0),
                        child: DropdownButton(
                          value: _lguValue,
                          onChanged: (newValue) {
                            print(newValue);
                            setState(() {
                              _lguValue = newValue;
                            });
                          },
                          items: _lgusData.map<DropdownMenuItem<LGU>>((value) {
                            return DropdownMenuItem<LGU>(
                              value: value,
                              child: Text(value.name),
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: DialogButton(
                          child: Text('Save'),
                          onPressed: () => saveData(),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('images/mi-logo.png', width: 200.0),
                        SizedBox(height: 20,),
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Loading list of LGU...',
                          textAlign: TextAlign.center,
                        )
                      ],
                    )),
                  );
                }
              })),
    );
  }

}
