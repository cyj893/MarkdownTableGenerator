import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';

import 'cell_size_provider.dart';
import 'focused_cell.dart';
import 'my_cell.dart';

class TableManager extends StatefulWidget {

  const TableManager({
    Key? key,
  }) : super(key: key);

  @override
  TableManagerState createState() => TableManagerState();

}

class TableManagerState extends State<TableManager> {

  bool widthProvider = false;
  bool heightProvider = false;

  int rowLen = 3;
  int colLen = 3;
  bool isRowSelected = false;
  bool isColSelected = false;

  List<List<MyCell>> cellTable = [];
  List<List<GlobalKey<MyCellState>>> keyTable = [];

  @override
  void initState(){
    super.initState();

    for(int i = 0; i < 3; i++){
      keyTable.insert(i, List.generate(colLen, (index) => GlobalKey()));
      cellTable.insert(i, List.generate(colLen, (j) => MyCell(key: keyTable[i][j], function: setFocusedColor)));
    }
  }

  List<int> findFocusedCell(){
    List<int> ret = [];
    int focusKey = FocusedCell().getKey();
    for(int i = 0; i < keyTable.length; i++){
      for(int j = 0; j < keyTable[i].length; j++){
        if( keyTable[i][j].currentState?.cellKey == focusKey ){
          ret = [i, j];
          break;
        }
      }
    }
    return ret;
  }

  void insertRow(int location){
    List<int> list = findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error insertRow");
      return ;
    }

    List<double> maxList = [];
    for(int i = 0; i < colLen; i++){
      double maxWidth = 120.0;
      for(int j = 0; j < rowLen; j++){
        maxWidth = max<double>(maxWidth, keyTable[j][i].currentState!.getSize().width+50);
      }
      maxList.add(maxWidth);
    }
    setState(() {
      keyTable.insert(list[0]+location, List.generate(colLen, (i) => GlobalKey()));
      cellTable.insert(list[0]+location, List.generate(colLen, (j) {
        return MyCell(
          key: keyTable[list[0]+location][j],
          function: setFocusedColor,
          initialWidth: maxList[j],
          initialFocused: j == list[1] ? 1 : 0,
        );
      }));
      printKeyTable();
      rowLen++;
    });
  }

  void deleteRow(){
    List<int> list = findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error deleteRow");
      return ;
    }

    if( rowLen == 1 ) return ;
    setState(() {
      keyTable.removeAt(list[0]);
      cellTable.removeAt(list[0]);
      printKeyTable();
      rowLen--;

      for(int i = 0; i < colLen; i++){
        resizeTableWidth(i);
      }
    });
  }

  void insertColumn(int location){
    List<int> list = findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error insertColumn");
      return ;
    }

    List<double> maxList = [];
    for(int i = 0; i < rowLen; i++){
      double maxHeight = 72.0;
      for(int j = 0; j < colLen; j++){
        maxHeight = max<double>(maxHeight, keyTable[i][j].currentState!.getHeight());
      }
      maxList.add(maxHeight);
    }
    setState(() {
      for(int i = 0; i < rowLen; i++){
        keyTable[i].insert(list[1]+location, GlobalKey());
        cellTable[i].insert(list[1]+location, MyCell(
            key: keyTable[i][list[1]+location],
            function: setFocusedColor,
            initialHeight: maxList[i],
            initialFocused: i == list[0] ? 1 : 0,
        ));
      }
      printKeyTable();
      colLen++;
    });
  }

  void deleteColumn(){
    List<int> list = findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error deleteColumn");
      return ;
    }

    if( colLen == 1 ) return ;
    setState(() {
      for(int i = 0; i < rowLen; i++){
        keyTable[i].removeAt(list[1]);
        cellTable[i].removeAt(list[1]);
      }
      printKeyTable();
      colLen--;

      for(int i = 0; i < rowLen; i++){
        resizeTableHeight(i);
      }
    });
  }

  void printKeyTable(){
    print("");
    for(int i = 0; i < keyTable.length; i++){
      for(int j = 0; j < keyTable[i].length; j++){
        print("${keyTable[i][j].currentState?.cellKey} ");
      }
    }
    print("");
  }

  void setFocusedColor(){
    List<int> list = findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error setFocusedColor");
      return ;
    }
    for(int i = 0; i < keyTable.length; i++){
      for(int j = 0; j < keyTable[i].length; j++){
        if( i == list[0] && j == list[1] ){
          keyTable[i][j].currentState?.setFocusedColor(2);
        }
        else if( i == list[0] || j == list[1] ){
          keyTable[i][j].currentState?.setFocusedColor(1);
        }
        else{
          keyTable[i][j].currentState?.setFocusedColor(0);
        }
      }
    }
  }

  void setAlignment(int alignment){
    List<int> list = findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error setAlignment");
      return ;
    }
    for(int i = 0; i < keyTable.length; i++){
      keyTable[i][list[1]].currentState?.changeAlignment(alignment);
    }
  }

  void changeCellBold() {
    List<int> list = findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error changeCellBold");
      return ;
    }
    keyTable[list[0]][list[1]].currentState?.changeBold();
  }

  void changeCellItalic() {
    List<int> list = findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error changeCellItalic");
      return ;
    }
    keyTable[list[0]][list[1]].currentState?.changeItalic();
  }

  void changeCellStrike() {
    List<int> list = findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error changeCellStrike");
      return ;
    }
    keyTable[list[0]][list[1]].currentState?.changeStrike();
  }

  void changeCellCode() {
    List<int> list = findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error changeCellCode");
      return ;
    }
    keyTable[list[0]][list[1]].currentState?.changeCode();
  }

  void clearCellDeco() {
    List<int> list = findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error clearCellDeco");
      return ;
    }
    keyTable[list[0]][list[1]].currentState?.clearDeco();
  }

  void changeListing(int listing) {
    List<int> list = findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error changeListing");
      return ;
    }
    keyTable[list[0]][list[1]].currentState?.changeListing(listing);
  }

  String makeMdData(){
    String mdData = "";
    for(int i = 0; i < keyTable.length; i++){
      mdData += "|";
      for(int j = 0; j < keyTable[i].length; j++){
        mdData += " ${keyTable[i][j].currentState?.getMDText() ?? ""}\t |";
      }
      mdData += "\n";
      if( i == 0 ){
        mdData += "|";
        for(int j = 0; j < keyTable[i].length; j++){
          int alignment = keyTable[i][j].currentState?.getAlignment() ?? 1;
          switch( alignment ){
            case 0:
              mdData += " :-- |";
              break;
            case 1:
              mdData += " :--: |";
              break;
            case 2:
              mdData += " --: |";
              break;
            default:
              debugPrint("makeMdData Error");
          }
        }
        mdData += "\n";
      }
    }
    return mdData;
  }

  void resizeTableWidth(int colNum){
    List<List> list = List.generate(rowLen, (i) => [keyTable[i][colNum].currentState!.getSize().width+50, i]);
    list.sort((a, b) {
      if( a[0] >= b[0] ) return -1;
      return 1;
    });
    double maxWidth = max<double>(list[0][0], 120.0);
    for(int i = 0; i < rowLen; i++){
      keyTable[i][colNum].currentState?.setWidth(maxWidth);
    }
  }

  void resizeTableHeight(int rowNum){
    List<List> list = List.generate(colLen, (i) => [keyTable[rowNum][i].currentState!.getHeight(), i]);
    list.sort((a, b) {
      if( a[0] >= b[0] ) return -1;
      return 1;
    });
    double maxHeight = max<double>(list[0][0], 72.0);
    for(int i = 0; i < colLen; i++){
      keyTable[rowNum][i].currentState?.setHeight(maxHeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    widthProvider = context.watch<CellSizeProvider>().isWidthChanged;
    heightProvider = context.watch<CellSizeProvider>().isHeightChanged;
    if( widthProvider ){
      List indexes = findFocusedCell();
      resizeTableWidth(indexes[1]);
      context.read<CellSizeProvider>().endWidthChanging();
    }
    if( heightProvider ){
      List indexes = findFocusedCell();
      resizeTableHeight(indexes[0]);
      context.read<CellSizeProvider>().endHeightChanging();
    }
    return Column(
      children: List.generate(
          rowLen, (i) => Row(
        children: List.generate(colLen, (j) => cellTable[i][j]),)),
    );
  }

}