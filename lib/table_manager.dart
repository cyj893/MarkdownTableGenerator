import 'package:flutter/material.dart';
import 'package:markdown_table_generator/mouse_drag_selectable.dart';
import 'dart:math';

import 'cell_helper.dart';
import 'key_table.dart';
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

  List<List<MyCell>> cellTable = [];
  final KeyTable _keyTable = KeyTable();

  @override
  void initState(){
    super.initState();

    for(int i = 0; i < 3; i++){
      _keyTable.table.insert(i, List.generate(_keyTable.colLen, (index) => GlobalKey()));
      cellTable.insert(i, List.generate(_keyTable.colLen, (j) => MyCell(key: _keyTable.table[i][j])));
    }
  }

  void insertRow(int location){
    List<int> list = _keyTable.findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error insertRow");
      return ;
    }

    List<double> maxList = [];
    for(int i = 0; i < _keyTable.colLen; i++){
      double maxWidth = 120.0;
      for(int j = 0; j < _keyTable.rowLen; j++){
        maxWidth = max<double>(maxWidth, CellHelper.getWidth(_keyTable.table[j][i]) + 50);
      }
      maxList.add(maxWidth);
    }
    setState(() {
      _keyTable.table.insert(list[0]+location, List.generate(_keyTable.colLen, (i) => GlobalKey()));
      cellTable.insert(list[0]+location, List.generate(_keyTable.colLen, (j) {
        return MyCell(
          key: _keyTable.table[list[0]+location][j],
          initialWidth: maxList[j],
          initialFocused: j == list[1] ? 1 : 0,
        );
      }));
      _keyTable.printKeyTable();
      _keyTable.rowLen++;
    });
  }

  void deleteRow(){
    List<int> list = _keyTable.findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error deleteRow");
      return ;
    }

    if( _keyTable.rowLen == 1 ) return ;
    setState(() {
      _keyTable.table.removeAt(list[0]);
      cellTable.removeAt(list[0]);
      _keyTable.printKeyTable();
      _keyTable.rowLen--;

      for(int i = 0; i < _keyTable.colLen; i++){
        _keyTable.resizeTableWidth(i);
      }
    });
  }

  void insertColumn(int location){
    List<int> list = _keyTable.findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error insertColumn");
      return ;
    }

    List<double> maxList = [];
    for(int i = 0; i < _keyTable.rowLen; i++){
      double maxHeight = 72.0;
      for(int j = 0; j < _keyTable.colLen; j++){
        maxHeight = max<double>(maxHeight, CellHelper.getHeight(_keyTable.table[i][j]));
      }
      maxList.add(maxHeight);
    }
    setState(() {
      for(int i = 0; i < _keyTable.rowLen; i++){
        _keyTable.table[i].insert(list[1]+location, GlobalKey());
        cellTable[i].insert(list[1]+location, MyCell(
            key: _keyTable.table[i][list[1]+location],
            initialHeight: maxList[i],
            initialFocused: i == list[0] ? 1 : 0,
        ));
      }
      _keyTable.printKeyTable();
      _keyTable.colLen++;
    });
  }

  void deleteColumn(){
    List<int> list = _keyTable.findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error deleteColumn");
      return ;
    }

    if( _keyTable.colLen == 1 ) return ;
    setState(() {
      for(int i = 0; i < _keyTable.rowLen; i++){
        _keyTable.table[i].removeAt(list[1]);
        cellTable[i].removeAt(list[1]);
      }
      _keyTable.printKeyTable();
      _keyTable.colLen--;

      for(int i = 0; i < _keyTable.rowLen; i++){
        _keyTable.resizeTableHeight(i);
      }
    });
  }

  void setAlignment(int alignment){
    if( isSelecting ){
      int t = selectedCells[0][0];
      for(int i = 0; i < selectedCells.length; i++){
        for(int j = 0; j < _keyTable.table.length; j++){
          CellHelper.changeAlignment(_keyTable.table[j][selectedCells[i][1]], alignment);
        }
        if( selectedCells[i][0] != t ) break;
      }
      return ;
    }
    List<int> list = _keyTable.findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error setAlignment");
      return ;
    }
    for(int i = 0; i < _keyTable.rowLen; i++){
      CellHelper.changeAlignment(_keyTable.table[i][list[1]], alignment);
    }
  }

  void changeCellDeco(Function f) {
    if( isSelecting ){
      for(int i = 0; i < selectedCells.length; i++){
        f(_keyTable.table[selectedCells[i][0]][selectedCells[i][1]]);
      }
      return ;
    }
    List<int> list = _keyTable.findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error changeCellDeco: $f");
      return ;
    }
    f(_keyTable.table[list[0]][list[1]]);
  }

  void changeListing(int listing) {
    if( isSelecting ){
      for(int i = 0; i < selectedCells.length; i++){
        CellHelper.changeListing(_keyTable.table[selectedCells[i][0]][selectedCells[i][1]], listing);
      }
      return ;
    }
    List<int> list = _keyTable.findFocusedCell();
    if( list.isEmpty ){
      debugPrint("Error changeListing");
      return ;
    }
    CellHelper.changeListing(_keyTable.table[list[0]][list[1]], listing);
  }

  String makeMdData(){
    String mdData = "";
    for(int i = 0; i < _keyTable.rowLen; i++){
      mdData += "|";
      for(int j = 0; j < _keyTable.colLen; j++){
        mdData += " ${CellHelper.getMDText(_keyTable.table[i][j])}\t |";
      }
      mdData += "\n";
      if( i == 0 ){
        mdData += "|";
        for(int j = 0; j < _keyTable.table[i].length; j++){
          int alignment = CellHelper.getAlignment(_keyTable.table[i][j]);
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

  void startSelecting(){
    _keyTable.clearFocus();
    calculateTableSize();
    isSelecting = true;
  }

  List<double> w = [0.0];
  List<double> h = [0.0];

  void calculateTableSize(){
    w = [0.0];
    h = [0.0];
    for(int i = 0; i < _keyTable.rowLen; i++){
      List<List> list = List.generate(_keyTable.colLen, (index) => [CellHelper.getHeight(_keyTable.table[i][index]), index]);
      list.sort((a, b) {
        if( a[0] >= b[0] ) return -1;
        return 1;
      });
      double maxHeight = max<double>(list[0][0], 72.0);
      h.add(h.last + maxHeight);
    }
    for(int j = 0; j < _keyTable.colLen; j++){
      List<List> list = List.generate(_keyTable.rowLen, (index) => [CellHelper.getWidth(_keyTable.table[index][j])+50, index]);
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

    List<List<int>> list = [];
    for(int i = 0; i < _keyTable.rowLen; i++){
      for(int j = 0; j < _keyTable.colLen; j++){
        if( ((s.dx <= w[j] && w[j] <= e.dx) || (s.dx <= w[j+1] && w[j+1] <= e.dx))
            && ((s.dy <= h[i] && h[i] <= e.dy) || (s.dy <= h[i+1] && h[i+1] <= e.dy)) ){
          list.add([i, j]);
        } // common cases
        else if( w[j] <= s.dx && e.dx <= w[j+1]
            && ((s.dy <= h[i] && h[i] <= e.dy) || (s.dy <= h[i+1] && h[i+1] <= e.dy)) ){
          list.add([i, j]);
        } // box cells in column
        else if( ((s.dx <= w[j] && w[j] <= e.dx) || (s.dx <= w[j+1] && w[j+1] <= e.dx))
            && h[i] <= s.dy && e.dy <= h[i+1] ){
          list.add([i, j]);
        } // box cells in row
        else if( w[j] <= s.dx && e.dx <= w[j+1] && h[i] <= s.dy && e.dy <= h[i+1] ){
          list.add([i, j]);
        } // box in cell
      }
    }

    selectedCells = list;
    for(int i = 0; i < list.length; i++){
      CellHelper.setFocusedColor(_keyTable.table[list[i][0]][list[i][1]], 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Build 0");
    return MouseDragSelectable(
        child: Column(
          children: List.generate(
              _keyTable.rowLen, (i) => Row(
            children: List.generate(_keyTable.colLen, (j) => cellTable[i][j]),)),
        )
    );
  }

}