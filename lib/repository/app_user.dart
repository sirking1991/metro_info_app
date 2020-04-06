import 'dart:async';
import 'package:metro_info/models/app_user.dart';
import 'package:metro_info/networking/api_provider.dart';

class AppUserRepository {
  ApiProvider _provider = ApiProvider();

  Future<void> registerUser(AppUser appUser) async {

    final response = await _provider.post("register_app_user", appUser.toJson());
    print('register user result: ' + response.toString());
  }
}