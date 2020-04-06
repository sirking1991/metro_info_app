import 'dart:async';
import 'package:metro_info/networking/api_provider.dart';
import 'package:metro_info/models/regions.dart';

class RegionsRepository {
  ApiProvider _provider = ApiProvider();

  Future<Regions> fetchRegions() async {
    final response = await _provider.get("regions");
    return Regions.fromJson(response);
  }
}