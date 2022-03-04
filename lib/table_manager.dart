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
  bool isSelecting = false;
  List<List<int>> selectedCells = [];

  int rowLen = 3;
  int colLen = 3;

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
    if( isSelecting ){
      int t = selectedCells[0][0];
      for(int i = 0; i < selectedCells.length; i++){
        for(int j = 0; j < keyTable.length; j++){
          CellHelper.changeAlignment(keyTable[j][selectedCells[i][1]], alignment);
        }
        if( selectedCells[i][0] != t ) break;
      }
      isSelecting = false;
      selectedCells = [];
      clearFocus();
      return ;
    }
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
    if( isSelecting ){
      for(int i = 0; i < selectedCells.length; i++){
        CellHelper.changeBold(keyTable[selectedCells[i][0]][selectedCells[i][1]]);
      }
      isSelecting = false;
      selectedCells = [];
      clearFocus();
      return ;
    }
    List<int> list = findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error changeCellBold");
      return ;
    }
    CellHelper.changeBold(keyTable[list[0]][list[1]]);
  }

  void changeCellItalic() {
    if( isSelecting ){
      for(int i = 0; i < selectedCells.length; i++){
        CellHelper.changeItalic(keyTable[selectedCells[i][0]][selectedCells[i][1]]);
      }
      isSelecting = false;
      selectedCells = [];
      clearFocus();
      return ;
    }
    List<int> list = findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error changeCellItalic");
      return ;
    }
    CellHelper.changeItalic(keyTable[list[0]][list[1]]);
  }

  void changeCellStrike() {
    if( isSelecting ){
      for(int i = 0; i < selectedCells.length; i++){
        CellHelper.changeStrike(keyTable[selectedCells[i][0]][selectedCells[i][1]]);
      }
      isSelecting = false;
      selectedCells = [];
      clearFocus();
      return ;
    }
    List<int> list = findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error changeCellStrike");
      return ;
    }
    CellHelper.changeStrike(keyTable[list[0]][list[1]]);
  }

  void changeCellCode() {
    if( isSelecting ){
      for(int i = 0; i < selectedCells.length; i++){
        CellHelper.changeCode(keyTable[selectedCells[i][0]][selectedCells[i][1]]);
      }
      isSelecting = false;
      selectedCells = [];
      clearFocus();
      return ;
    }
    List<int> list = findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error changeCellCode");
      return ;
    }
    CellHelper.changeCode(keyTable[list[0]][list[1]]);
  }

  void clearCellDeco() {
    if( isSelecting ){
      for(int i = 0; i < selectedCells.length; i++){
        CellHelper.clearDeco(keyTable[selectedCells[i][0]][selectedCells[i][1]]);
      }
      isSelecting = false;
      selectedCells = [];
      clearFocus();
      return ;
    }
    List<int> list = findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error clearCellDeco");
      return ;
    }
    CellHelper.clearDeco(keyTable[list[0]][list[1]]);
  }

  void changeListing(int listing) {
    if( isSelecting ){
      for(int i = 0; i < selectedCells.length; i++){
        CellHelper.changeListing(keyTable[selectedCells[i][0]][selectedCells[i][1]], listing);
      }
      isSelecting = false;
      selectedCells = [];
      clearFocus();
      return ;
    }
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

  void clearFocus(){
    for(int i = 0; i < rowLen; i++){
      for(int j = 0; j < colLen; j++){
        CellHelper.setFocusedColor(keyTable[i][j], 0);
      }
    }
  }

  void startSelecting(){
    clearFocus();
    calculateTableSize();
    isSelecting = true;
  }

  List<double> w = [0.0];
  List<double> h = [0.0];

  void calculateTableSize(){
    w = [0.0];
    h = [0.0];
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
  }

  List<Offset> switchOffsets(Offset a, Offset b){
    Offset s = const Offset(0, 0);
    Offset e = const Offset(0, 0);
    /*
        a            b.dx, a.dy
        a.dx, b.dy   b

        a.dx, b.dy   b
        a            b.dx, a.dy

        b.dx, a.dy   a
        b            a.dx, b.dy

        b            a.dx, b.dy
        b.dx, a.dy   a
    */
    if( a.dx < b.dx ){
      if( a.dy < b.dy ){
        s = a;
        e = b;
      }
      else{
        s = Offset(a.dx, b.dy);
        e = Offset(b.dx, a.dy);
      }
    }
    else{
      if( a.dy < b.dy ){
        s = Offset(b.dx, a.dy);
        e = Offset(a.dx, b.dy);
      }
      else{
        s = b;
        e = a;
      }
    }
    return [s, e];
  }

  void endSelecting(Offset startOffset, Offset nowOffset){
    List<Offset> switchedList = switchOffsets(startOffset, nowOffset);
    Offset s = switchedList[0];
    Offset e = switchedList[1];

    print("");
    print("s: $s, e: $e");
    print("rowLen: $rowLen, colLen: $colLen");
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

    selectedCells = list;
    print("result: $selectedCells");
    print("");

    for(int i = 0; i < list.length; i++){
      CellHelper.setFocusedColor(keyTable[list[i][0]][list[i][1]], 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Build 0");
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