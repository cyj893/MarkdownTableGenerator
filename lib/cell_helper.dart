import 'package:flutter/material.dart';

import 'my_cell.dart';

class CellHelper {

  static int getKeyNum(GlobalKey<MyCellState> cellKey) => cellKey.currentState?.getKeyNum() ?? -1;
  static double getWidth(GlobalKey<MyCellState> cellKey) => cellKey.currentState?.getSize().width ?? 0.0;
  static double getHeight(GlobalKey<MyCellState> cellKey) => cellKey.currentState?.getHeight() ?? 0.0;
  static String getMDText(GlobalKey<MyCellState> cellKey) => cellKey.currentState?.getMDText() ?? "";
  static int getAlignment(GlobalKey<MyCellState> cellKey) => cellKey.currentState?.getAlignment() ?? 1;

  static void setWidth(GlobalKey<MyCellState> cellKey, double width) => cellKey.currentState?.setWidth(width);
  static void setHeight(GlobalKey<MyCellState> cellKey, double height) => cellKey.currentState?.setHeight(height);

  static void setFocusedColor(GlobalKey<MyCellState> cellKey, int focused) => cellKey.currentState?.setFocusedColor(focused);
  static void changeAlignment(GlobalKey<MyCellState> cellKey, int alignment) => cellKey.currentState?.changeAlignment(alignment);
  static void changeBold(GlobalKey<MyCellState> cellKey) => cellKey.currentState?.changeBold();
  static void changeItalic(GlobalKey<MyCellState> cellKey) => cellKey.currentState?.changeItalic();
  static void changeStrike(GlobalKey<MyCellState> cellKey) => cellKey.currentState?.changeStrike();
  static void changeCode(GlobalKey<MyCellState> cellKey) => cellKey.currentState?.changeCode();
  static void clearDeco(GlobalKey<MyCellState> cellKey) => cellKey.currentState?.clearDeco();
  static void changeListing(GlobalKey<MyCellState> cellKey, int listing) => cellKey.currentState?.changeListing(listing);



}