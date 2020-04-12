import 'package:flutter/foundation.dart';

class LGUProvider extends ChangeNotifier {
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
}