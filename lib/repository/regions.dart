import 'dart:async';
import 'dart:convert';
import 'package:metro_info/networking/api_provider.dart';
import 'package:metro_info/models/region.dart';

class RegionsRepository {
  ApiProvider _provider = ApiProvider();

  Future<Region> fetchRegions() async {
    // final response = await _provider.get("regions");
    // return Region.fromJason(response);
  }
}