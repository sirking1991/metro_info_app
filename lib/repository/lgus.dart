import 'dart:async';
import 'package:metro_info/networking/api_provider.dart';
import 'package:metro_info/models/lgus.dart';

class LGUsRepository {
  ApiProvider _provider = ApiProvider();

  Future<LGU> fetchLGUs(String regionShortName) async {
    final response = await _provider.get("/lgus/" + regionShortName);
    return LGU.fromJson(response);
  }
}