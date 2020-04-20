import 'package:metro_info/networking/custom_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class ApiProvider {
  //final String _baseUrl = "https://colossal-madrid-16udig9usgxj.vapor-farm-b1.com/api/";
  //final String _baseUrl = "https://metro-info.herokuapp.com/api/";
  final String _baseUrl = "https://fb227a59.ap.ngrok.io/api/";

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      print('GETting data from ' + _baseUrl + url);
      final response = await http.get(_baseUrl + url);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, dynamic data) async {
    var responseJson;
    try {
      print('POSTting data to ' + _baseUrl + url);

      final response = await http.post(_baseUrl + url,
          headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data)
      );

      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}