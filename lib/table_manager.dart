import 'package:flutter/material.dart';
import 'package:markdown_table_generator/mouse_drag_selectable.dart';
import 'dart:math';
import 'package:provider/provider.dart';

import 'cell_helper.dart';
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
        if( CellHelper.getKeyNum(keyTable[i][j]) == focusKey ){
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
        maxWidth = max<double>(maxWidth, CellHelper.getWidth(keyTable[j][i]) + 50);
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
        maxHeight = max<double>(maxHeight, CellHelper.getHeight(keyTable[i][j]));
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
        print("${CellHelper.getKeyNum(keyTable[i][j])} ");
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
          CellHelper.setFocusedColor(keyTable[i][j], 2);
        }
        else if( i == list[0] || j == list[1] ){
          CellHelper.setFocusedColor(keyTable[i][j], 1);
        }
        else{
          CellHelper.setFocusedColor(keyTable[i][j], 0);
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
      CellHelper.changeAlignment(keyTable[i][list[1]], alignment);
    }
  }

  void changeCellBold() {
    List<int> list = findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error changeCellBold");
      return ;
    }
    CellHelper.changeBold(keyTable[list[0]][list[1]]);
  }

  void changeCellItalic() {
    List<int> list = findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error changeCellItalic");
      return ;
    }
    CellHelper.changeItalic(keyTable[list[0]][list[1]]);
  }

  void changeCellStrike() {
    List<int> list = findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error changeCellStrike");
      return ;
    }
    CellHelper.changeStrike(keyTable[list[0]][list[1]]);
  }

  void changeCellCode() {
    List<int> list = findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error changeCellCode");
      return ;
    }
    CellHelper.changeCode(keyTable[list[0]][list[1]]);
  }

  void clearCellDeco() {
    List<int> list = findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error clearCellDeco");
      return ;
    }
    CellHelper.clearDeco(keyTable[list[0]][list[1]]);
  }

  void changeListing(int listing) {
    List<int> list = findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error changeListing");
      return ;
    }
    CellHelper.changeListing(keyTable[list[0]][list[1]], listing);
  }

  String makeMdData(){
    String mdData = "";
    for(int i = 0; i < keyTable.length; i++){
      mdData += "|";
      for(int j = 0; j < keyTable[i].length; j++){
        mdData += " ${CellHelper.getMDText(keyTable[i][j])}\t |";
      }
      mdData += "\n";
      if( i == 0 ){
        mdData += "|";
        for(int j = 0; j < keyTable[i].length; j++){
          int alignment = CellHelper.getAlignment(keyTable[i][j]);
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
    List<List> list = List.generate(rowLen, (i) => [CellHelper.getWidth(keyTable[i][colNum])+50, i]);
    list.sort((a, b) {
      if( a[0] >= b[0] ) return -1;
      return 1;
    });
    double maxWidth = max<double>(list[0][0], 120.0);
    for(int i = 0; i < rowLen; i++){
      CellHelper.setWidth(keyTable[i][colNum], maxWidth);
    }
  }

  void resizeTableHeight(int rowNum){
    List<List> list = List.generate(colLen, (i) => [CellHelper.getHeight(keyTable[rowNum][i]), i]);
    list.sort((a, b) {
      if( a[0] >= b[0] ) return -1;
      return 1;
    });
    double maxHeight = max<double>(list[0][0], 72.0);
    for(int i = 0; i < colLen; i++){
      CellHelper.setHeight(keyTable[rowNum][i], maxHeight);
    }
  }


  void endSelecting(Offset startOffset, Offset nowOffset){
    Offset s = Offset(0, 0);
    Offset e = Offset(0, 0);
    if( startOffset.dx < nowOffset.dx ){
      if( startOffset.dy < nowOffset.dy ){
        /*
        s            n.dx, s.dy
        s.dx, n.dy   n
         */
        s = startOffset;
        e = nowOffset;
      }
      else{
        /*
        s.dx, n.dy   n
        s            n.dx, s.dy
         */
        s = Offset(startOffset.dx, nowOffset.dy);
        e = Offset(nowOffset.dx, startOffset.dy);
      }
    }
    else{
      if( startOffset.dy < nowOffset.dy ){
        /*
        n.dx, s.dy   s
        n            s.dx, n.dy
         */
        s = Offset(nowOffset.dx, startOffset.dy);
        e = Offset(startOffset.dx, nowOffset.dy);
      }
      else{
        /*
        n            s.dx, n.dy
        n.dx, s.dy   s
         */
        s = nowOffset;
        e = startOffset;
      }
    }

    print("");
    print("s: $s, e: $e");
    print("rowLen: $rowLen, colLen: $colLen");
    List<double> w = [0.0];
    List<double> h = [0.0];

    for(int i = 0; i < rowLen; i++){
      List<List> list = List.generate(colLen, (index) => [CellHelper.getHeight(keyTable[i][index]), index]);
      list.sort((a, b) {
        if( a[0] >= b[0] ) return -1;
        return 1;
      });
      double maxHeight = max<double>(list[0][0], 72.0);
      h.add(h.last + maxHeight);
    }
    for(int j = 0; j < colLen; j++){
      List<List> list = List.generate(rowLen, (index) => [CellHelper.getWidth(keyTable[index][j])+50, index]);
      list.sort((a, b) {
        if( a[0] >= b[0] ) return -1;
        return 1;
      });
      double maxWidth = max<double>(list[0][0], 120.0);
      w.add(w.last + maxWidth);
    }

    print("w: $w, h: $h");
    List<List<int>> list = [];
    for(int i = 0; i < rowLen; i++){
      for(int j = 0; j < colLen; j++){
        print("${w[j]}, ${h[i]}");
        if( ((s.dx <= w[j] && w[j] <= e.dx) || (s.dx <= w[j+1] && w[j+1] <= e.dx))
            && ((s.dy <= h[i] && h[i] <= e.dy) || (s.dy <= h[i+1] && h[i+1] <= e.dy)) )
          list.add([i, j]);
        if( w[j] <= s.dx && e.dx <= w[j+1]
            && ((s.dy <= h[i] && h[i] <= e.dy) || (s.dy <= h[i+1] && h[i+1] <= e.dy)) )
          list.add([i, j]);
        if( ((s.dx <= w[j] && w[j] <= e.dx) || (s.dx <= w[j+1] && w[j+1] <= e.dx))
            && h[i] <= s.dy && e.dy <= h[i+1] )
          list.add([i, j]);
      }
    }

    print("result: $list");
    print("");

    for(int i = 0; i < list.length; i++){
      CellHelper.setFocusedColor(keyTable[list[i][0]][list[i][1]], 2);
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
    return MouseDragSelectable(
        child: Column(
          children: List.generate(
              rowLen, (i) => Row(
            children: List.generate(colLen, (j) => cellTable[i][j]),)),
        )
    );
  }

}