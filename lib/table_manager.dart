import 'dart:math';

import 'package:flutter/material.dart';
import 'package:markdown_table_generator/width_provider.dart';
import 'package:provider/src/provider.dart';
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

  int rowLen = 0;
  int colLen = 3;
  bool isRowSelected = false;
  bool isColSelected = false;

  List<List<MyCell>> cellTable = [];
  List<List<GlobalKey<MyCellState>>> keyTable = [];

  @override
  void initState(){
    super.initState();

    for(int i = 0; i < 3; i++){
      print("insert");
      insertRow(i);
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

  void insertRow(int index){
    setState(() {
      keyTable.insert(index, List.generate(colLen, (i) => GlobalKey()));
      cellTable.insert(index, List.generate(colLen, (i) => MyCell(key: keyTable[index][i])));
      printKeyTable();
      rowLen++;
    });
  }

  void deleteRow(int index){
    setState(() {
      if( rowLen == 1 ) return ;
      keyTable.removeAt(index);
      cellTable.removeAt(index);
      printKeyTable();
      rowLen--;
    });
  }

  void insertColumn(int index){
    setState(() {
      for(int i = 0; i < rowLen; i++){
        keyTable[i].insert(index, GlobalKey());
        cellTable[i].insert(index, MyCell(key: keyTable[i][index]));
      }
      printKeyTable();
      colLen++;
    });
  }

  void deleteColumn(int index){
    setState(() {
      for(int i = 0; i < rowLen; i++){
        keyTable[i].removeAt(index);
        cellTable[i].removeAt(index);
      }
      printKeyTable();
      colLen--;
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

  @override
  Widget build(BuildContext context) {
    widthProvider = context.watch<WidthProvider>().isChanged;
    if( widthProvider ){
      List indexes = findFocusedCell();
      List<List> list = List.generate(keyTable.length, (i) => [keyTable[i][indexes[1]].currentState!.getWidth()+30, i]);
      list.sort((a, b) {
        if( a[0] >= b[0] ) return -1;
        return 1;
      });
      print(list);
      double maxWidth = max<double>(list[0][0], 100.0);
      for(int i = 0; i < keyTable.length; i++){
        keyTable[i][indexes[1]].currentState?.setWidth(maxWidth);
      }
      print("nowWidth: $maxWidth");
      context.read<WidthProvider>().endChanging();
    }
    return Column(
      children: List.generate(
          rowLen, (i) => Row(
            children: List.generate(colLen, (j) => cellTable[i][j]),)),
    );
  }

}