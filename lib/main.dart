import 'package:flutter/material.dart';
import 'package:markdown_table_generator/show_res.dart';
import 'package:markdown_table_generator/table_menu.dart';
import 'package:markdown_table_generator/width_provider.dart';
import 'package:provider/provider.dart';

import 'my_div.dart';
import 'table_helper.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WidthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '마크다운 표 생성기',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        canvasColor: Colors.white,
      ),
      home: const MyHomePage(),
    );
  }
}

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
        title: const Text("마크다운 표 생성기"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
