import 'dart:async';
import 'package:metro_info/networking/api_provider.dart';
import 'package:metro_info/models/lgus.dart';

class LGUsRepository {
  ApiProvider _provider = ApiProvider();

  Future<LGUs> fetchLGUs(String regionShortName) async {
    final response = await _provider.get("/lgus/" + regionShortName);
    return LGUs.fromJson(response);
  }
}