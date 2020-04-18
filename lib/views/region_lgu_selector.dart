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
  List<Region> _religonData = [];
  List<LGU> _lgusData = [];
  Region _regionValue; //Initial value
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
    try {
      prefs.setInt('lgu_id', _lguValue.id);
      prefs.setString("lgu_name", _lguValue.name);
      prefs.setString("lgu_slug", _lguValue.slug);
      prefs.setString("region_short_name", _lguValue.regionShortName);

      Provider.of<AppState>(context, listen: false).reset();

    } catch (error) {
      print(error);
      //Later in code we can handle the error on faiure
    }

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

  prepareDropDownData() async {
    List _regionDataone;
    List _tempRegionList;
    List _lGUsDataone;
    try {
      if (!done) {
        _regionDataone = await ApiProvider().get("regions");
        _tempRegionList = makeRegionList(_regionDataone);
        _regionValue = _tempRegionList[0];
        _lGUsDataone =
            await ApiProvider().get("lgus/" + _regionValue.shortName);
        List _lGUsDataList = LGU.getMapLGUs(_lGUsDataone);

        _lgusData = _lGUsDataList;
        _lgusData.add(_initialValue);
        _lguValue = _initialValue;
        //  _initialValue=_lguValue;
        _religonData = _tempRegionList;
        _regionValue = _tempRegionList[0];
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
              future: prepareDropDownData(),
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
                          value: _regionValue,
                          onChanged: (Region newValue) {
                            print(newValue);
                            setState(() {
                              _regionValue = newValue;
                            });
                            getLGUs(newValue);
                          },
                          items: _religonData
                              .map<DropdownMenuItem<Region>>((value) {
                            print(value);
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
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Loading...',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    )),
                  );
                }
              })),
    );
  }

}
