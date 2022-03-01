import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_table_generator/table_menu.dart';
import 'package:markdown_table_generator/width_provider.dart';
import 'package:provider/provider.dart';

import 'table_manager.dart';

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

  String mdData = "";

  TableManager? tableManager;
  GlobalKey<TableManagerState> tableKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    tableManager = TableManager(key: tableKey);
    mdData = '''
| 	 | 	 | 	 |
| :--: | :--: | :--: |
| 	 | 	 | 	 |
| 	 | 	 | 	 |
    ''';
  }

  Widget makeCode(){
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Colors.grey[50],
      ),
      child: Row(
        children: [
          SelectableText(mdData, style: const TextStyle(fontFamily: "D2Coding"),),
          Expanded(child: Container()),
        ],
      ),
    );
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
              TableMenu(tableKey: tableKey,),
              tableManager!,
              const SizedBox(height: 20,),
              Row(
                children: [
                  const Text("Result", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          mdData = tableKey.currentState?.makeMdData() ?? "";
                        });
                      },
                      icon: const Icon(Icons.refresh_rounded)),
                  IconButton(
                      onPressed: () {
                        debugPrint("copied");
                        debugPrint(mdData);
                        Clipboard.setData(ClipboardData(text: mdData));
                      },
                      icon: const Icon(Icons.file_copy_rounded)),
                ],
              ),
              const SizedBox(height: 10,),
              makeCode(),
            ],
          ),
        ),
      ),
    );
  }
}
