import 'package:flutter/material.dart';

import 'package:markdown_table_generator/my_enums.dart';
import 'my_cell.dart';

class CellHelper {

  static int getKeyNum(GlobalKey<MyCellState> cellKey) => cellKey.currentState?.getKeyNum() ?? -1;
  static double getWidth(GlobalKey<MyCellState> cellKey) => cellKey.currentState?.getSize().width ?? 0.0;
  static double getHeight(GlobalKey<MyCellState> cellKey) => cellKey.currentState?.getHeight() ?? 0.0;
  static String getMDText(GlobalKey<MyCellState> cellKey) => cellKey.currentState?.getMDText() ?? "";
  static Alignments getAlignment(GlobalKey<MyCellState> cellKey) => cellKey.currentState?.getAlignment() ?? Alignments.center;

  static void setText(GlobalKey<MyCellState> cellKey, String text) => cellKey.currentState?.setText(text);

  static void setWidth(GlobalKey<MyCellState> cellKey, double width) => cellKey.currentState?.setWidth(width);
  static void setHeight(GlobalKey<MyCellState> cellKey, double height) => cellKey.currentState?.setHeight(height);

  static void setFocusedColor(GlobalKey<MyCellState> cellKey, FocusColor focused) => cellKey.currentState?.setFocusedColor(focused);
  static void changeAlignment(GlobalKey<MyCellState> cellKey, Alignments alignment) => cellKey.currentState?.changeAlignment(alignment);
  static void changeBold(GlobalKey<MyCellState> cellKey) => cellKey.currentState?.changeBold();
  static void changeItalic(GlobalKey<MyCellState> cellKey) => cellKey.currentState?.changeItalic();
  static void changeStrike(GlobalKey<MyCellState> cellKey) => cellKey.currentState?.changeStrike();
  static void changeCode(GlobalKey<MyCellState> cellKey) => cellKey.currentState?.changeCode();
  static void changeLink(GlobalKey<MyCellState> cellKey) => cellKey.currentState?.changeLink();
  static void clearDeco(GlobalKey<MyCellState> cellKey) => cellKey.currentState?.clearDeco();
  static void changeListing(GlobalKey<MyCellState> cellKey, Listings listing) => cellKey.currentState?.changeListing(listing);

}