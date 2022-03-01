import 'package:flutter/material.dart';

import 'table_manager.dart';

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

  void setAlignment(int alignment) => tableKey.currentState!.setAlignment(alignment);
  void changeCellBold() => tableKey.currentState!.changeCellBold();
  void changeCellItalic() => tableKey.currentState!.changeCellItalic();
  void changeCellStrike() => tableKey.currentState!.changeCellStrike();
  void changeCellCode() => tableKey.currentState!.changeCellCode();
  void clearCellDeco() => tableKey.currentState!.clearCellDeco();

  String makeMdData() => tableKey.currentState?.makeMdData() ?? "";

}