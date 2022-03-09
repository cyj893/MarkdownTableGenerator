import 'dart:math';
import 'package:flutter/material.dart';

import 'package:markdown_table_generator/globals.dart' as globals;
import 'package:markdown_table_generator/my_enums.dart';
import 'cell/my_cell.dart';
import 'cell/cell_helper.dart';
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
    for(List<GlobalKey<MyCellState>> row in table){
      for(GlobalKey<MyCellState> key in row){
        print("${CellHelper.getKeyNum(key)} ");
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
    for(List<GlobalKey<MyCellState>> row in table){
      for(GlobalKey<MyCellState> key in row){
        CellHelper.setFocusedColor(key, FocusColor.none);
      }
    }
    focusedCellKey = -1;
  }

  void resizeTableWidth(int colNum){
    List<List> list = List.generate(rowLen, (i) => [CellHelper.getWidth(table[i][colNum])+globals.widthMargin, i]);
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

  void resizeTable(){
    for(int i = 0; i < colLen; i++){
      resizeTableWidth(i);
    }
    for(int i = 0; i < rowLen; i++){
      resizeTableHeight(i);
    }
  }

  void inputFromCopy(String csvStr){
    List<int> pos = findFocusedCell();

    csvStr = csvStr.replaceAll('\r\n', '\n'); // convert CRLF to LF
    int di = 0;
    int dj = 0;
    for(int i = 0; i < csvStr.length; i++){
      int nowI = pos[0]+di;
      int nowJ = pos[1]+dj;
      if( csvStr[i] == '\t' ){
        dj++;
        continue;
      }
      if( csvStr[i] == '"' ){
        String s = "";
        int j = i+1;
        for( ; j < csvStr.length; j++){
          if( csvStr[j] == '"' ){
            j++;
            if( j >= csvStr.length ){
              debugPrint("!!");
              debugPrint("tabs error");
              return ;
            }
            bool breakSign = false;
            switch (csvStr[j]) {
              case '"': // just "
                s += '"';
                break;
              case '\t': // cell ending
                if( !csvStr.substring(i, j).contains('\n') ) s = '"$s"';
                if( nowI < rowLen && nowJ < colLen ) CellHelper.setText(table[nowI][nowJ], s);
                dj++;
                breakSign = true;
                break;
              case '\n':  // cell ending and line ending
                if( !csvStr.substring(i, j).contains('\n') ) s = '"$s"';
                if( nowI < rowLen && nowJ < colLen ) CellHelper.setText(table[nowI][nowJ], s);
                di++;
                dj = 0;
                breakSign = true;
                break;
              default:
                debugPrint("!");
                debugPrint("tabs Error");
                return ;
            }
            if( breakSign ) break;
          }
          else{
            s += csvStr[j];
          }
        }
        i = j;
      }
      else{
        String s = "";
        int j = i;
        for( ; j < csvStr.length; j++){
          bool breakSign = false;
          switch (csvStr[j]) {
            case '\t': // cell ending
              if( nowI < rowLen && nowJ < colLen ) CellHelper.setText(table[nowI][nowJ], s);
              dj++;
              breakSign = true;
              break;
            case '\n':  // cell ending and line ending
              if( nowI < rowLen && nowJ < colLen ) CellHelper.setText(table[nowI][nowJ], s);
              di++;
              dj = 0;
              breakSign = true;
              break;
            default:
              s += csvStr[j];
          }
          if( breakSign ) break;
        }
        i = j;
      }
    }
    resizeTable();
  }


}