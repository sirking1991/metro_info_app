import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:metro_info/models/lgus.dart';
import 'package:metro_info/networking/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  int _lguId;
  int get lguId => _lguId;
  set lguId(int lguId) {
    _lguId = lguId;
    notifyListeners();
  }

  String _lguName;
  String get lguName => _lguName;
  set lguName(String lguName) {
    _lguName = lguName;
    notifyListeners();
  }

  String _lguLogoUrl = '';
  Widget get lguLogo {
    return '' == _lguLogoUrl || null == _lguLogoUrl
        ? Image.asset('images/mi-logo-transparent.png', width: 120.0)
        : CachedNetworkImage(
            placeholder: (context, url) =>
                Image.asset('images/mi-logo-transparent.png', width: 120.0),
            imageUrl: _lguLogoUrl,
            width: 120.0);
  }

  String _firstName = '';
  String get firstName => _firstName;

  String _lguThemeColor = 'indigo';
  Color get themeColor {
    switch (_lguThemeColor) {
      case 'amber':
        return Colors.amber;
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'lightGreen':
        return Colors.lightGreen;
      case 'blue':
        return Colors.blue;
      case 'blueAccent':
        return Colors.blueAccent;
      case 'blueGrey':
        return Colors.blueGrey;
      case 'brown':
        return Colors.brown;
      case 'cyan':
        return Colors.cyan;
      case 'orange':
        return Colors.orange;
      case 'pink':
        return Colors.pink;
      case 'purple':
        return Colors.purple;
      case 'indigo':
        return Colors.indigo;
      case 'teal':
        return Colors.teal;
      default:
        return Colors.green;
    }
  }

  String _regionShortName = '';
  String get regionShortName => _regionShortName;

  SharedPreferences _pref;
  SharedPreferences get pref => _pref;

  init() {
    print("AppState.init()");
    _setGlobalVars();
  }

  reset(){
    _setGlobalVars();
  }

  _setGlobalVars() async {
    _pref = await SharedPreferences.getInstance();

    _lguId = _pref.getInt("lgu_id");
    _lguName = _pref.getString("lgu_name");
    _lguThemeColor = _pref.getString('lgu_primary_color');
    _lguLogoUrl = _pref.getString('lgu_logo_url');
    _regionShortName = _pref.getString("region_short_name");
    _firstName = _pref.getString("first_name");
    notifyListeners();

    // get LGU details from API
    ApiProvider().get('lgu/' + _lguId.toString()).then((res) {
      LGU _lgu = LGU.fromJson(res);
      print(_lgu.toJson());

      _pref.setString('lgu_logo_url', _lgu.logoUrl);
      _pref.setString('lgu_primary_color', _lgu.color);

      _lguLogoUrl = _lgu.logoUrl;
      _lguThemeColor = _lgu.color;

      notifyListeners();

    }).catchError((error) {
      print("AppState: error=" + error.toString());
    });

    
  }
}
