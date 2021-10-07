import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeModel2 extends ChangeNotifier {
  int _index = 0;
  int get index => _index;

  set index(int newValue) {
    if (_index != newValue) {
      if (newValue == 4) {
        _index = 0;
      } else {
        _index = newValue;
      }
      notifyListeners();
    }
  }

  Color _foregroundColor = Colors.accents[2];
  Color get foregroundColor => _foregroundColor;
  set foregroundColor(Color newValue) {
    if (newValue != _foregroundColor) {
      _foregroundColor = newValue;
      notifyListeners();
    }
  }

  Color _backgroundColor = Colors.accents[3];
  Color get backgroundColor => _backgroundColor;
  set backgroundColor(Color newValue) {
    if (newValue != _backgroundColor) {
      _backgroundColor = newValue;
      notifyListeners();
    }
  }

  bool _isHalfWay = false;
  bool get isHalfWay => _isHalfWay;
  set isHalfWay(bool newValue) {
    if (newValue != _isHalfWay) {
      _isHalfWay = newValue;
      notifyListeners();
    }
  }

  void swapColors() {
    if (_index % 2 != 0) {
      backgroundColor = Colors.accents[2];
      foregroundColor = Colors.accents[3];
    } else {
      backgroundColor = Colors.accents[3];
      foregroundColor = Colors.accents[2];
    }
    notifyListeners();
  }
}
