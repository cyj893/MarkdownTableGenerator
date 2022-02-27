import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_table_generator/width_provider.dart';
import 'package:provider/provider.dart';

import 'cell_key_generator.dart';
import 'my_column.dart';
import 'focused_cell.dart';
import 'table_manager.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WidthProvider()),
      ],
      child: MyApp(),
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

  List<MyColumn> columns = [];
  final List<GlobalKey<MyColumnState>> _myColumnKeys = [];
  int rowLen = 3;
  bool isRowSelected = false;
  bool isColSelected = false;

  List<List<int>> keyTable = [ [], [], [] ];
  String mdData = "";

  TableManager? tableManager;
  GlobalKey<TableManagerState> tableKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    tableManager = TableManager(key: tableKey);
  }

  Widget myDiv(double height) => Container(height: height, width: 1, color: Colors.grey[300]);

  Widget makeRowBtn(){
    return AnimatedContainer(
        alignment: Alignment.centerLeft,
        duration: const Duration(milliseconds: 200),
        width: isRowSelected ? 203 : 50,
        height: 50,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isRowSelected = !isRowSelected;
                  });
                },
                child: const SizedBox(
                  width: 50,
                  child: Center(child: Text("Row", style: TextStyle(fontWeight: FontWeight.bold),),),
                ),
              ),
              myDiv(10),
              InkWell(
                onTap: () {
                  List<int> list = tableKey.currentState!.findFocusedCell();
                  if( list.isEmpty ){
                    debugPrint("Error");
                    return ;
                  }
                  tableKey.currentState!.insertRow(list[0]);
                },
                child: SizedBox(
                  width: 50,
                  child: Stack(
                    children: const [
                      Positioned(
                        bottom: 15,
                        right: 12.5,
                        width: 25,
                        height: 25,
                        child: Icon(Icons.add_box_rounded, size: 25,),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 15,
                        width: 20,
                        height: 20,
                        child: Icon(Icons.arrow_drop_up_rounded, size: 20,),
                      ),
                    ],
                  ),
                ),
              ),
              myDiv(10),
              InkWell(
                onTap: () {
                  List<int> list = tableKey.currentState!.findFocusedCell();
                  if( list.isEmpty ){
                    debugPrint("Error");
                    return ;
                  }
                  tableKey.currentState!.insertRow(list[0]+1);
                },
                child: SizedBox(
                  width: 50,
                  child: Stack(
                    children: const [
                      Positioned(
                        top: 5,
                        right: 15,
                        width: 20,
                        height: 20,
                        child: Icon(Icons.arrow_drop_down_rounded, size: 20,),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 12.5,
                        width: 25,
                        height: 25,
                        child: Icon(Icons.add_box_rounded, size: 25,),
                      ),
                    ],
                  ),
                ),
              ),
              myDiv(10),
              SizedBox(
                width: 50,
                child: IconButton(
                    onPressed: () {
                      List<int> list = tableKey.currentState!.findFocusedCell();
                      if( list.isEmpty ){
                        debugPrint("Error");
                        return ;
                      }
                      tableKey.currentState!.deleteRow(list[0]);
                    },
                    icon: const Icon(Icons.indeterminate_check_box_rounded)
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget makeColBtn(){
    return AnimatedContainer(
        alignment: Alignment.centerLeft,
        duration: const Duration(milliseconds: 200),
        width: isColSelected ? 203 : 50,
        height: 50,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isColSelected = !isColSelected;
                  });
                },
                child: const SizedBox(
                  width: 50,
                  child: Center(child: Text("Col", style: TextStyle(fontWeight: FontWeight.bold),),),
                ),
              ),
              myDiv(10),
              InkWell(
                onTap: () {
                  setState(() {
                    List<int> list = tableKey.currentState!.findFocusedCell();
                    if( list.isEmpty ){
                      debugPrint("Error");
                      return ;
                    }
                    tableKey.currentState!.insertColumn(list[1]);
                  });
                },
                child: SizedBox(
                  width: 50,
                  child: Stack(
                    children: const [
                      Positioned(
                        bottom: 12.5,
                        right: 17.5,
                        width: 25,
                        height: 25,
                        child: Icon(Icons.add_box_rounded, size: 25,),
                      ),
                      Positioned(
                        bottom: 15,
                        right: 2.5,
                        width: 20,
                        height: 20,
                        child: Icon(Icons.arrow_left_rounded, size: 20,),
                      ),
                    ],
                  ),
                ),
              ),
              myDiv(10),
              InkWell(
                onTap: () {
                  setState(() {
                    List<int> list = tableKey.currentState!.findFocusedCell();
                    if( list.isEmpty ){
                      debugPrint("Error");
                      return ;
                    }
                    tableKey.currentState!.insertColumn(list[1]+1);
                  });
                },
                child: SizedBox(
                  width: 50,
                  child: Stack(
                    children: const [
                      Positioned(
                        bottom: 15,
                        left: 2.5,
                        width: 20,
                        height: 20,
                        child: Icon(Icons.arrow_right_rounded, size: 20,),
                      ),
                      Positioned(
                        bottom: 12.5,
                        left: 17.5,
                        width: 25,
                        height: 25,
                        child: Icon(Icons.add_box_rounded, size: 25,),
                      ),
                    ],
                  ),
                ),
              ),
              myDiv(10),
              SizedBox(
                width: 50,
                child: IconButton(
                    onPressed: () {
                      if( columns.length == 1 ) return ;
                      setState(() {
                        List<int> list = tableKey.currentState!.findFocusedCell();
                        if( list.isEmpty ){
                          debugPrint("Error");
                          return ;
                        }
                        tableKey.currentState!.deleteColumn(list[1]);
                      });
                    },
                    icon: const Icon(Icons.indeterminate_check_box_rounded)
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget makeAlignBtn(int alignment, Icon icon){
    return IconButton(
        onPressed: () {
          List<int> list = tableKey.currentState!.findFocusedCell();
          if( list.isEmpty ){
            debugPrint("Error");
            return ;
          }
          _myColumnKeys[list[1]].currentState?.setAlignment(alignment);
        },
        icon: icon);
  }

  Widget makeMenu(){
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          makeRowBtn(),
          myDiv(40),
          makeColBtn(),
          myDiv(40),
          makeAlignBtn(0, const Icon(Icons.format_align_left_rounded)),
          makeAlignBtn(1, const Icon(Icons.format_align_center_rounded)),
          makeAlignBtn(2, const Icon(Icons.format_align_right_rounded)),
          myDiv(40),
          IconButton(
              onPressed: () {
                List<int> list = tableKey.currentState!.findFocusedCell();
                if( list.isEmpty ){
                  debugPrint("Error");
                  return ;
                }
                _myColumnKeys[list[1]].currentState?.changeCellBold(list[0]);
              },
              icon: const Icon(Icons.format_bold_rounded)),
          IconButton(
              onPressed: () {
                List<int> list = tableKey.currentState!.findFocusedCell();
                if( list.isEmpty ){
                  debugPrint("Error");
                  return ;
                }
                _myColumnKeys[list[1]].currentState?.changeCellItalic(list[0]);
              },
              icon: const Icon(Icons.format_italic_rounded)),
          IconButton(
              onPressed: () {
                List<int> list = tableKey.currentState!.findFocusedCell();
                if( list.isEmpty ){
                  debugPrint("Error");
                  return ;
                }
                _myColumnKeys[list[1]].currentState?.changeCellStrike(list[0]);
              },
              icon: const Icon(Icons.strikethrough_s_rounded)),
          IconButton(
              onPressed: () {
                List<int> list = tableKey.currentState!.findFocusedCell();
                if( list.isEmpty ){
                  debugPrint("Error");
                  return ;
                }
                _myColumnKeys[list[1]].currentState?.changeCellCode(list[0]);
              },
              icon: const Icon(Icons.code_rounded)),
        ],
      ),
    );
  }

  Widget makeEditor(){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: columns,
      ),
    );
  }

  void makeMdData(){
    mdData = "";
    for(int i = 0; i < keyTable.length; i++){
      mdData += "|";
      for(int j = 0; j < keyTable[i].length; j++){
        mdData += " ${_myColumnKeys[j].currentState?.getCellMD(i) ?? ""}\t |";
      }
      mdData += "\n";
      if( i == 0 ){
        mdData += "|";
        for(int j = 0; j < keyTable[i].length; j++){
          int alignment = _myColumnKeys[j].currentState?.getAlignment() ?? 1;
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
  }

  Widget makeCode(){
    makeMdData();
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
              makeMenu(),
              tableManager!,
              const SizedBox(height: 20,),
              Row(
                children: [
                  const Text("Result", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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
