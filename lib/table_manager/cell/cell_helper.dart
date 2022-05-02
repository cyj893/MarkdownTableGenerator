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
  static void changeDeco(GlobalKey<MyCellState> cellKey, CellDecoChange cellDecoChange){
    switch (cellDecoChange) {
      case CellDecoChange.bold:
        cellKey.currentState?.changeBold();
        break;
      case CellDecoChange.italic:
        cellKey.currentState?.changeItalic();
        break;
      case CellDecoChange.strike:
        cellKey.currentState?.changeStrike();
        break;
      case CellDecoChange.code:
        cellKey.currentState?.changeCode();
        break;
      case CellDecoChange.link:
        cellKey.currentState?.changeLink();
        break;
      case CellDecoChange.clearAll:
        cellKey.currentState?.clearDeco();
        break;
      default:
        debugPrint("Error");
    }
  }
  static void changeAlignment(GlobalKey<MyCellState> cellKey, Alignments alignment) => cellKey.currentState?.changeAlignment(alignment);
  static void changeListing(GlobalKey<MyCellState> cellKey, Listings listing) => cellKey.currentState?.changeListing(listing);

}