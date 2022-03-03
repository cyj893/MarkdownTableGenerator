import 'package:flutter/material.dart';

class CellSizeProvider with ChangeNotifier {
  bool isWidthChanged = false;
  bool isHeightChanged = false;

  void endWidthChanging(){
    isWidthChanged = false;
  }

  void endHeightChanging(){
    isHeightChanged = false;
  }

  void changeWidth(){
    isWidthChanged = true;
    notifyListeners();
  }

  void changeHeight(){
    isHeightChanged = true;
    notifyListeners();
  }

}