import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeModel extends ChangeNotifier {
  int _index = 0;
  int get index => _index;

  set index(int value) {
    if (_index != value) {
      _index = value;
      notifyListeners();
    }
  }

  bool _isHalfWay = false;

  bool get isHalfWay => _isHalfWay;

  set isHalfWay(bool newValue) {
    if (_isHalfWay != newValue) {
      _isHalfWay = newValue;
      notifyListeners();
    }
  }

  bool _isToggled = false; // For switching between colors
  bool get isToggled => _isToggled;

  set isToggled(bool newValue) {
    _isToggled = newValue;
    notifyListeners();
  }

  Color _backgroundColor = Colors.accents[0];
  Color get backgroundColor => _backgroundColor;

  set backgroundColor(Color newValue) {
    _backgroundColor = newValue;
    notifyListeners();
  }

  Color _foregroundColor = Colors.accents[1];
  Color get foregroundColor => _foregroundColor;

  set foregroundColor(Color newValue) {
    _foregroundColor = newValue;
    notifyListeners();
  }

  void swapColors() {
    if (_isToggled) {
      _backgroundColor = Colors.accents[1];
      _foregroundColor = Colors.accents[0];
    } else {
      _backgroundColor = Colors.accents[0];
      _foregroundColor = Colors.accents[1];
    }
    notifyListeners();
  }
}
