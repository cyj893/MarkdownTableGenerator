import 'package:flutter/material.dart';
import 'package:markdown_table_generator/my_enums.dart';

import 'table_manager.dart';
import 'cell_helper.dart';

class TableHelper {
  static final TableHelper _tableHelperInstance = TableHelper._internal();
  TableHelper._internal(){
    tableManager = TableManager(key: tableKey);
  }
  factory TableHelper() {
    return _tableHelperInstance;
  }

  TableManager? tableManager;
  GlobalKey<TableManagerState> tableKey = GlobalKey();

  void insertRow(int location) => tableKey.currentState!.insertRow(location);
  void deleteRow() => tableKey.currentState!.deleteRow();
  void insertColumn(int location) => tableKey.currentState!.insertColumn(location);
  void deleteColumn() => tableKey.currentState!.deleteColumn();

  void setAlignment(Alignments alignment) => tableKey.currentState!.setAlignment(alignment);
  void changeCellBold() => tableKey.currentState!.changeCellDeco(CellHelper.changeBold);
  void changeCellItalic() => tableKey.currentState!.changeCellDeco(CellHelper.changeItalic);
  void changeCellStrike() => tableKey.currentState!.changeCellDeco(CellHelper.changeStrike);
  void changeCellCode() => tableKey.currentState!.changeCellDeco(CellHelper.changeCode);
  void clearCellDeco() => tableKey.currentState!.changeCellDeco(CellHelper.clearDeco);
  void changeListing(Listings listing) => tableKey.currentState!.changeListing(listing);

  String makeMdData() => tableKey.currentState?.makeMdData() ?? "";

  void startSelecting() => tableKey.currentState!.startSelecting();
  void endSelecting(Offset startOffset, Offset nowOffset) => tableKey.currentState!.endSelecting(startOffset, nowOffset);
  void setIsSelecting(bool b){
    tableKey.currentState!.isSelecting = b;
    tableKey.currentState!.selectedCells = [];
  }

}