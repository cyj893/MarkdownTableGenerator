import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CellKeyGenerator.dart';
import 'MyCell.dart';
import 'MyColumn.dart';
import 'FocusedCell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '마크다운 표 생성기',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  List<GlobalKey<MyColumnState>> _myColumnKeys = [];
  int rowLen = 3;
  bool isRowSelected = false;
  bool isColSelected = false;

  List<List<int>> keyTable = [ [], [], [] ];

  @override
  void initState() {
    super.initState();

    for(int i = 0; i < 3; i++){
      insertColumn(i);
    }
  }

  List<int> findFocusedCell(){
    List<int> ret = [];
    int focusKey = FocusedCell().getKey();
    for(int i = 0; i < keyTable.length; i++){
      for(int j = 0; j < keyTable[i].length; j++){
        if( _myColumnKeys[j].currentState?.getCellKey(i) == focusKey ){
          ret = [i, j];
          break;
        }
      }
    }
    return ret;
  }

  void insertColumn(int index){
    for(int i = 0; i < rowLen; i++){
      keyTable[i].insert(index, CellKeyGenerator().nowKey()+i+1);
    }
    printKeyTable();
    _myColumnKeys.insert(index, GlobalKey());
    columns.insert(index, MyColumn(key: _myColumnKeys[index], children: List.generate(rowLen, (index) => MyCell()),));
  }

  void deleteColumn(int index){
    for(int i = 0; i < rowLen; i++){
      keyTable[i].removeAt(index);
    }
    printKeyTable();
    columns.removeAt(index);
    _myColumnKeys.removeAt(index);
  }

  void insertRow(int index){
    keyTable.insert(index, []);
    for(int i = 0; i < columns.length; i++){
      _myColumnKeys[i].currentState?.addCell(index);
      keyTable[index].add(CellKeyGenerator().nowKey());
    }
    printKeyTable();
    rowLen++;
  }

  void deleteRow(int index){
    if( rowLen == 1 ) return ;
    for(int i = 0; i < columns.length; i++){
      _myColumnKeys[i].currentState?.delCell(index);
    }
    keyTable.removeAt(index);
    printKeyTable();
    rowLen--;
  }

  void printKeyTable(){
    print("");
    for(int i = 0; i < keyTable.length; i++){
      print(keyTable[i]);
    }
    print("");
  }

  Widget makeRowBtn(){
    return AnimatedContainer(
        alignment: Alignment.centerLeft,
        duration: Duration(milliseconds: 200),
        width: isRowSelected ? 151 : 50,
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
                child: SizedBox(
                  width: 50,
                  child: Center(child: Text("Row", style: TextStyle(fontWeight: FontWeight.bold),),),
                ),
              ),
              SizedBox(
                width: 50,
                child: IconButton(
                    onPressed: () {
                      List<int> list = findFocusedCell();
                      if( list.isEmpty ){
                        print("Error");
                        return ;
                      }
                      insertRow(list[0]);
                    },
                    icon: const Icon(Icons.add_box_rounded)
                ),
              ),
              SizedBox(
                width: 50,
                child: IconButton(
                    onPressed: () {
                      List<int> list = findFocusedCell();
                      if( list.isEmpty ){
                        print("Error");
                        return ;
                      }
                      deleteRow(list[0]);
                    },
                    icon: const Icon(Icons.indeterminate_check_box_rounded)
                ),
              ),
              Container(
                height: 40,
                width: 1,
                color: Colors.grey[300],
              )
            ],
          ),
        )
    );
  }

  Widget makeColBtn(){
    return AnimatedContainer(
        alignment: Alignment.centerLeft,
        duration: Duration(milliseconds: 200),
        width: isColSelected ? 151 : 50,
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
                child: SizedBox(
                  width: 50,
                  child: Center(child: Text("Col", style: TextStyle(fontWeight: FontWeight.bold),),),
                ),
              ),
              SizedBox(
                width: 50,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        List<int> list = findFocusedCell();
                        if( list.isEmpty ){
                          print("Error");
                          return ;
                        }
                        insertColumn(list[1]);
                      });
                    },
                    icon: const Icon(Icons.add_box_rounded)
                ),
              ),
              SizedBox(
                width: 50,
                child: IconButton(
                    onPressed: () {
                      if( columns.length == 1 ) return ;
                      setState(() {
                        List<int> list = findFocusedCell();
                        if( list.isEmpty ){
                          print("Error");
                          return ;
                        }
                        deleteColumn(list[1]);
                      });
                    },
                    icon: const Icon(Icons.indeterminate_check_box_rounded)
                ),
              ),
              Container(
                height: 40,
                width: 1,
                color: Colors.grey[300],
              )
            ],
          ),
        )
    );
  }

  Widget makeMenu(){
    return Row(
      children: [
        makeRowBtn(),
        makeColBtn(),
        IconButton(
            onPressed: () {
              List<int> list = findFocusedCell();
              if( list.isEmpty ){
                print("Error");
                return ;
              }
              _myColumnKeys[list[1]].currentState?.setAlignment(0);
            },
            icon: Icon(Icons.format_align_left_rounded)),
        IconButton(
            onPressed: () {
              List<int> list = findFocusedCell();
              if( list.isEmpty ){
                print("Error");
                return ;
              }
              _myColumnKeys[list[1]].currentState?.setAlignment(1);
            },
            icon: Icon(Icons.format_align_center_rounded)),
        IconButton(
            onPressed: () {
              List<int> list = findFocusedCell();
              if( list.isEmpty ){
                print("Error");
                return ;
              }
              _myColumnKeys[list[1]].currentState?.setAlignment(2);
            },
            icon: Icon(Icons.format_align_right_rounded)),
        IconButton(
            onPressed: () {

            },
            icon: Icon(Icons.format_bold_rounded)),
        IconButton(
            onPressed: () {

            },
            icon: Icon(Icons.format_italic_rounded)),

      ],
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

  int countWidth(String s){
    int cnt = 0;
    print(s.codeUnits);
    for(int i = 0; i < s.length; i++){
      if( s[i].codeUnits[0] < 128 ) cnt++;
      else cnt += 2;
    }
    return cnt;
  }

  Widget makeCode(){
    return SelectableText('''
    12345678
| 123	   |
| 12△    |
| 가나다 |
| 가나   |
| 😀	   |
    ''', style: TextStyle(fontFamily: "D2Coding"),);
  }
  
  Widget makePreview(){
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("마크다운 표 생성기"),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              makeMenu(),
              makeEditor(),
              makeCode(),
              makePreview(),
            ],
          ),
        ),
      ),
    );
  }
}
