import 'package:flutter/material.dart';

class WidthProvider with ChangeNotifier {
  bool isChanged = false;

  void endChanging(){
    isChanged = false;
  }

  void changeWidth(){
    isChanged = true;
    notifyListeners();
  }
}