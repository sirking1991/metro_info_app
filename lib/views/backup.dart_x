import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metro_info/views/main.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:metro_info/networking/api_provider.dart';
import "package:metro_info/models/region.dart";
import "package:metro_info/models/lgus.dart";
import 'package:shared_preferences/shared_preferences.dart';

class RegionLGUSelector extends StatefulWidget {
  bool isIntial;
  RegionLGUSelector({Key key, this.isIntial=false}) : super(key: key);
  @override
  _RegionLGUSelector createState() {
    // TODO: implement createState
    return _RegionLGUSelector();
  }
}

class _RegionLGUSelector extends State<RegionLGUSelector> {
   final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Region> _religonData = []; 
  List<LGUs> _lgusData = [];
  Region _regionValue =Region(id: 0, name: "NCR", shortName: "NCR");  //Initial value
  LGUs _lguValue = LGUs(
        id: 0,
        name: "select LGUs",
        createdAt: null,
        regionShortName: " ",
        slug: " ",
        updatedAt: " ") ;//initial value of LGUS
  LGUs _initialValue;      //this will be used to keep the initial value of the application

  @override
  void initState() {
    _religonData.add(_regionValue);
    _lgusData.add(_lguValue);
    _initialValue=_lguValue;
    super.initState();
    ApiProvider().get("regions").then((response) {
    //calling the  function to make the map into list of region
      makeRegionList(response);
    }).then((res){
       getLGUs("NCR");

    }).catchError((error) {
      print("this is error");
      print(error);
    });
  }
  //this function is for storing the data in the sharedPrefreces and to show snackbar and navigate .
  void saveData()async{
   SharedPreferences prefs = await SharedPreferences.getInstance();
   try{
    prefs.setInt('lgu_id',_lguValue.id );
    prefs.setString("name", _lguValue.name);
    prefs.setString("slug", _lguValue.slug);
    prefs.setString("region_short_name", _lguValue.regionShortName);
   }catch(error){
     print(error);
     //Later in code we can handle the error on faiure
   }
     _displaySnackBar(context, 'Region set successfully');
     //we have added the time because we need to show of snack bar to user before the navigation
     Timer(Duration(seconds: 2), (){
      Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
     });
 }
 // this function is for making the list of map into list of region instance and setting the downdown items value
  void makeRegionList(List response) {
    List _region = Region.getMapRegion(response);
    _region.add(_regionValue);
    setState(() {
      _religonData = _region;     
     
    });
  }
 // this function is for making the list of map into list of LGUs instance and setting the downdown items value
  void getLGUs(lguValue) {
    ApiProvider().get("lgus/"+ lguValue).then((response) {
      print(response);
    List _lGUsDataList =LGUs.getMapLGUs(response);
    _lGUsDataList.add(_initialValue );
    setState(() {
      _lgusData =_lGUsDataList;
      _lguValue=_lGUsDataList[0];
    });
    }).catchError((error) {
      print("this is error");
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                        widget.isIntial
                            ? Alert(
                                    buttons: [
                                    DialogButton(
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      width: 120,
                                    )
                                  ],
                                    type: AlertType.info,
                                    context: context,
                                    title: "Metro_Info",
                                    desc: "Please select Region to procced")
                                .show()
                            : Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
              child: Text(
                'Region & LGU Selection',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                    fontSize: 32.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(25.0),
              child: DropdownButton(
                value: _regionValue ,
                onChanged: ( Region newValue) {
                  print(newValue);
                  setState(() {                    
                    _regionValue = newValue;
                  });
                  getLGUs(newValue.shortName);
                },
                items: _religonData.map<DropdownMenuItem<Region>>((value) {
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
                items: _lgusData.map<DropdownMenuItem<LGUs>>((value) {
                 
                  return DropdownMenuItem<LGUs>(
                    value: value,
                    child: Text(value.name),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: RaisedButton(
                child: Text('Save'),
                onPressed: ()=> saveData()
                ,
              ),
            ),
          ],
        ),
      ),
    );
  }

    void _displaySnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message),duration: Duration(seconds: 2),);
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
