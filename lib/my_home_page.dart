import 'package:flutter/material.dart';

import 'file_drag_and_drop.dart';
import 'my_div.dart';
import 'table_manager/table_helper.dart';
import 'menus/table_menu.dart';
import 'show_res.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TableHelper tableHelper = TableHelper();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("마크다운 표 생성기", style: TextStyle(fontFamily: "D2Coding"),),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FileDragAndDrop(),
              const TableMenu(),
              horizontalDiv(MediaQuery.of(context).size.width),
              const SizedBox(height: 10,),
              tableHelper.tableManager!,
              const SizedBox(height: 10,),
              const ShowRes(),
            ],
          ),
        ),
      ),
    );
  }
}
