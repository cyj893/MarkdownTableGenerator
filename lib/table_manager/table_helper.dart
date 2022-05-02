import 'package:flutter/material.dart';
import 'package:markdown_table_generator/my_enums.dart';

import 'table_manager.dart';
import 'cell/cell_helper.dart';

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

  void clearTable() => tableKey.currentState!.clearTable();

  void insertRow(int location) => tableKey.currentState!.insertRow(location);
  void deleteRow() => tableKey.currentState!.deleteRow();
  void insertColumn(int location) => tableKey.currentState!.insertColumn(location);
  void deleteColumn() => tableKey.currentState!.deleteColumn();

  void setAlignment(Alignments alignment) => tableKey.currentState!.setAlignment(alignment);
  void changeCellDeco(CellDecoChange cellDecoChange) => tableKey.currentState!.changeCellDeco(cellDecoChange);
  void changeListing(Listings listing) => tableKey.currentState!.changeListing(listing);

  void readFromCSV(String csvStr) => tableKey.currentState!.readFromCSV(csvStr);

  String makeMdData() => tableKey.currentState?.makeMdData() ?? "";

  void startSelecting() => tableKey.currentState!.startSelecting();
  void endSelecting(Offset startOffset, Offset nowOffset) => tableKey.currentState!.endSelecting(startOffset, nowOffset);
  void setIsSelecting(bool b){
    tableKey.currentState!.isSelecting = b;
    tableKey.currentState!.selectedCells = [];
  }

}