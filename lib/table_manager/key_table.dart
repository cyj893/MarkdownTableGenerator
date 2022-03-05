import 'dart:math';
import 'package:flutter/material.dart';

import 'package:markdown_table_generator/my_enums.dart';
import 'my_cell.dart';
import 'cell_helper.dart';
import 'table_helper.dart';

class KeyTable {
  static final KeyTable _keyTableInstance = KeyTable._internal();
  KeyTable._internal();
  factory KeyTable() {
    return _keyTableInstance;
  }

  List<List<GlobalKey<MyCellState>>> table = [];
  int focusedCellKey = -1;

  int rowLen = 3;
  int colLen = 3;

  void setFocusedCellKey(int key){
    focusedCellKey = key;
    setFocusedColor();
    TableHelper().setIsSelecting(false);
  }

  void printKeyTable(){
    print("");
    for(int i = 0; i < table.length; i++){
      for(int j = 0; j < table[i].length; j++){
        print("${CellHelper.getKeyNum(table[i][j])} ");
      }
    }
    print("");
  }

  List<int> findFocusedCell(){
    List<int> pos = [];
    for(int i = 0; i < table.length; i++){
      for(int j = 0; j < table[i].length; j++){
        if( CellHelper.getKeyNum(table[i][j]) == focusedCellKey ){
          pos = [i, j];
          break;
        }
      }
    }
    return pos;
  }

  void setFocusedColor(){
    List<int> list = findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error setFocusedColor");
      return ;
    }
    for(int i = 0; i < rowLen; i++){
      for(int j = 0; j < colLen; j++){
        if( i == list[0] && j == list[1] ){
          CellHelper.setFocusedColor(table[i][j], FocusColor.focused);
        }
        else if( i == list[0] || j == list[1] ){
          CellHelper.setFocusedColor(table[i][j], FocusColor.around);
        }
        else{
          CellHelper.setFocusedColor(table[i][j], FocusColor.none);
        }
      }
    }
  }

  void clearFocus(){
    for(int i = 0; i < rowLen; i++){
      for(int j = 0; j < colLen; j++){
        CellHelper.setFocusedColor(table[i][j], FocusColor.none);
      }
    }
    focusedCellKey = -1;
  }

  void resizeTableWidth(int colNum){
    List<List> list = List.generate(rowLen, (i) => [CellHelper.getWidth(table[i][colNum])+50, i]);
    list.sort((a, b) {
      if( a[0] >= b[0] ) return -1;
      return 1;
    });
    double maxWidth = max<double>(list[0][0], 120.0);
    for(int i = 0; i < rowLen; i++){
      CellHelper.setWidth(table[i][colNum], maxWidth);
    }
  }

  void resizeTableHeight(int rowNum){
    List<List> list = List.generate(colLen, (i) => [CellHelper.getHeight(table[rowNum][i]), i]);
    list.sort((a, b) {
      if( a[0] >= b[0] ) return -1;
      return 1;
    });
    double maxHeight = max<double>(list[0][0], 72.0);
    for(int i = 0; i < colLen; i++){
      CellHelper.setHeight(table[rowNum][i], maxHeight);
    }
  }

}