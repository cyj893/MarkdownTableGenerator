import 'package:flutter/material.dart';
import 'dart:math';

import 'package:markdown_table_generator/my_enums.dart';
import 'mouse_drag_selectable/mouse_drag_selectable.dart';
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

  List<double> w = [0.0];
  List<double> h = [0.0];

  @override
  void initState(){
    super.initState();

    for(int i = 0; i < 3; i++){
      _keyTable.table.insert(i, List.generate(_keyTable.colLen, (index) => GlobalKey()));
      cellTable.insert(i, List.generate(_keyTable.colLen, (j) => MyCell(key: _keyTable.table[i][j])));
    }
  }

  List<double> getWidthMaxList(){
    List<double> maxList = [];
    for(int i = 0; i < _keyTable.colLen; i++){
      double maxWidth = 120.0;
      for(int j = 0; j < _keyTable.rowLen; j++){
        maxWidth = max<double>(maxWidth, CellHelper.getWidth(_keyTable.table[j][i]) + 50);
      }
      maxList.add(maxWidth);
    }
    return maxList;
  }

  void insertRow(int location){
    List<int> pos = _keyTable.findFocusedCell();
    if( pos.isEmpty ){
      debugPrint("Error insertRow");
      return ;
    }
    List<double> maxList = getWidthMaxList();
    setState(() {
      _keyTable.table.insert(pos[0]+location, List.generate(_keyTable.colLen, (i) => GlobalKey()));
      cellTable.insert(pos[0]+location, List.generate(_keyTable.colLen, (j) {
        return MyCell(
          key: _keyTable.table[pos[0]+location][j],
          initialWidth: maxList[j],
          initialFocused: j == pos[1] ? FocusColor.around : FocusColor.none,
        );
      }));
      _keyTable.printKeyTable();
      _keyTable.rowLen++;
    });
  }

  void deleteRow(){
    if( _keyTable.rowLen == 1 ) return ;
    List<int> pos = _keyTable.findFocusedCell();
    if( pos.isEmpty ){
      debugPrint("Error deleteRow");
      return ;
    }
    setState(() {
      _keyTable.table.removeAt(pos[0]);
      cellTable.removeAt(pos[0]);
      _keyTable.printKeyTable();
      _keyTable.rowLen--;
      for(int i = 0; i < _keyTable.colLen; i++){
        _keyTable.resizeTableWidth(i);
      }
    });
  }

  List<double> getHeightMaxList(){
    List<double> maxList = [];
    for(int i = 0; i < _keyTable.rowLen; i++){
      double maxHeight = 72.0;
      for(int j = 0; j < _keyTable.colLen; j++){
        maxHeight = max<double>(maxHeight, CellHelper.getHeight(_keyTable.table[i][j]));
      }
      maxList.add(maxHeight);
    }
    return maxList;
  }

  void insertColumn(int location){
    List<int> pos = _keyTable.findFocusedCell();
    if( pos.isEmpty ){
      debugPrint("Error insertColumn");
      return ;
    }
    List<double> maxList = getHeightMaxList();
    setState(() {
      for(int i = 0; i < _keyTable.rowLen; i++){
        _keyTable.table[i].insert(pos[1]+location, GlobalKey());
        cellTable[i].insert(pos[1]+location, MyCell(
            key: _keyTable.table[i][pos[1]+location],
            initialHeight: maxList[i],
            initialFocused: i == pos[0] ? FocusColor.around : FocusColor.none,
        ));
      }
      _keyTable.printKeyTable();
      _keyTable.colLen++;
    });
  }

  void deleteColumn(){
    if( _keyTable.colLen == 1 ) return ;
    List<int> pos = _keyTable.findFocusedCell();
    if( pos.isEmpty ){
      debugPrint("Error deleteColumn");
      return ;
    }
    setState(() {
      for(int i = 0; i < _keyTable.rowLen; i++){
        _keyTable.table[i].removeAt(pos[1]);
        cellTable[i].removeAt(pos[1]);
      }
      _keyTable.printKeyTable();
      _keyTable.colLen--;
      for(int i = 0; i < _keyTable.rowLen; i++){
        _keyTable.resizeTableHeight(i);
      }
    });
  }

  void setAlignment(Alignments alignment){
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
    List<int> pos = _keyTable.findFocusedCell();
    if( pos.isEmpty ){
      debugPrint("Error setAlignment");
      return ;
    }
    for(int i = 0; i < _keyTable.rowLen; i++){
      CellHelper.changeAlignment(_keyTable.table[i][pos[1]], alignment);
    }
  }

  void changeCellDeco(Function func) {
    if( isSelecting ){
      for(int i = 0; i < selectedCells.length; i++){
        func(_keyTable.table[selectedCells[i][0]][selectedCells[i][1]]);
      }
      return ;
    }
    List<int> pos = _keyTable.findFocusedCell();
    if( pos.isEmpty ){
      debugPrint("Error changeCellDeco: $func");
      return ;
    }
    func(_keyTable.table[pos[0]][pos[1]]);
  }

  void changeListing(Listings listing) {
    if( isSelecting ){
      for(int i = 0; i < selectedCells.length; i++){
        CellHelper.changeListing(_keyTable.table[selectedCells[i][0]][selectedCells[i][1]], listing);
      }
      return ;
    }
    List<int> pos = _keyTable.findFocusedCell();
    if( pos.isEmpty ){
      debugPrint("Error changeListing");
      return ;
    }
    CellHelper.changeListing(_keyTable.table[pos[0]][pos[1]], listing);
  }


  void readFromCSV(String csvStr) {
    List<String> csvList = csvStr.split('\n');
    List<List<String>> cellStrings = List.generate(
        csvList.length, (i) => csvList[i].split(','));
    /*
    TODO: adjust the table or make new table

    */
    for(int i = 0; i < cellStrings.length; i++){
      for(int j = 0; j < cellStrings[i].length; j++){
        print(cellStrings[i][j]);
        CellHelper.setText(_keyTable.table[i][j], cellStrings[i][j]);
      }
    }
  }

  String makeTableHeader(){
    String header = "|";
    for(int j = 0; j < _keyTable.colLen; j++) {
      Alignments alignment = CellHelper.getAlignment(_keyTable.table[0][j]);
      switch (alignment) {
        case Alignments.left:
          header += " :-- |";
          break;
        case Alignments.center:
          header += " :--: |";
          break;
        case Alignments.right:
          header += " --: |";
          break;
        default:
          debugPrint("makeMdData Error");
      }
    }
    header += "\n";
    return header;
  }

  String makeMdData(){
    String mdData = "";
    for(int i = 0; i < _keyTable.rowLen; i++){
      mdData += "|";
      for(int j = 0; j < _keyTable.colLen; j++){
        mdData += " ${CellHelper.getMDText(_keyTable.table[i][j])}\t |";
      }
      mdData += "\n";
      if( i == 0 ) mdData += makeTableHeader();
    }
    return mdData;
  }

  void startSelecting(){
    _keyTable.clearFocus();
    calculateTableSize();
    isSelecting = true;
  }

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
    /*
        w[j]       w[j+1]
           #cell[i][j]
        h[i]       h[i+1]
    */
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
/*
a --------- b.dx,a.dy    a.dx,b.dy - b            b.dx,a.dy - a            b --------- a.dx,b.dy
|           |            |           |            |           |            |           |
a.dx,b.dy - b            a --------- b.dx,a.dy    b --------- a.dx,b.dy    b.dx,a.dy - a

return
s ---------
|           |
  --------- e
*/
    Offset s = const Offset(0, 0);
    Offset e = const Offset(0, 0);
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

  bool isCellInBox(Offset s, Offset e, int i, int j){
    bool isCellStartInBoxXAxis = s.dx <= w[j] && w[j] <= e.dx;
    bool isCellEndInBoxXAxis = s.dx <= w[j+1] && w[j+1] <= e.dx;
    bool isCellInBoxXAxis = isCellStartInBoxXAxis || isCellEndInBoxXAxis;

    bool isCellStartInBoxYAxis = s.dy <= h[i] && h[i] <= e.dy;
    bool isCellEndInBoxYAxis = s.dy <= h[i+1] && h[i+1] <= e.dy;
    bool isCellInBoxYAxis = isCellStartInBoxYAxis || isCellEndInBoxYAxis;

    bool isBoxInCellXAxis = w[j] <= s.dx && e.dx <= w[j+1];
    bool isBoxInCellYAxis = h[i] <= s.dy && e.dy <= h[i+1];

    bool isCommonCase = isCellInBoxXAxis && isCellInBoxYAxis;
    bool isBoxInColumn = isBoxInCellXAxis && isCellInBoxYAxis;
    bool isBoxInRow = isCellInBoxXAxis && isBoxInCellYAxis;
    bool isBoxInACell = isBoxInCellXAxis && isBoxInCellYAxis;

    return isCommonCase || isBoxInColumn || isBoxInRow || isBoxInACell;
  }

  void endSelecting(Offset startOffset, Offset nowOffset){
    List<Offset> switchedList = switchOffsets(startOffset, nowOffset);
    Offset start = switchedList[0];
    Offset end = switchedList[1];

    selectedCells = [];
    for(int i = 0; i < _keyTable.rowLen; i++){
      for(int j = 0; j < _keyTable.colLen; j++){
        if( isCellInBox(start, end, i, j) ) selectedCells.add([i, j]);
      }
    }

    for(int i = 0; i < selectedCells.length; i++){
      CellHelper.setFocusedColor(_keyTable.table[selectedCells[i][0]][selectedCells[i][1]], FocusColor.focused);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Build 0");
    return MouseDragSelectable(
        child: Column(
          children: List.generate(_keyTable.rowLen, (i) => Row(
            children: List.generate(_keyTable.colLen, (j) => cellTable[i][j]),
          )),
        )
    );
  }

}