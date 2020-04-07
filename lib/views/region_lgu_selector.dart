import 'package:flutter/material.dart';
import 'package:metro_info/repository/regions.dart';

class RegionLGUSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> _locations = ['A', 'B', 'C', 'D'];

    return Scaffold(
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
                        Navigator.of(context).pop();
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
                value: '',
                items: _locations.map((String location) {
                  return new DropdownMenuItem<String>(
                    child: new Text(location),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: RaisedButton(
                child: Text('Get regions'),
                onPressed: () {
                  print('getting regions');
                  RegionsRepository regionReposiory = RegionsRepository();
                  final regions = regionReposiory.fetchRegions();
                  print(regions);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
