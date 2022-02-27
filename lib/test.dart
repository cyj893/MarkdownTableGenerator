import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cell_key_generator.dart';
import 'my_cell.dart';
import 'my_column.dart';
import 'test.dart';

class testPage extends StatefulWidget {
  const testPage({Key? key}) : super(key: key);

  @override
  State<testPage> createState() => testPageS();
}

class testPageS extends State<testPage> {

  List<MC> columns = [];
  int rowLen = 3;
  int colLen = 3;
  bool isRowSelected = false;
  bool isColSelected = false;

  List<List<int>> keyTable = [
    [1, 4, 7],
    [2, 5, 8],
    [3, 6, 9]
  ];

  @override
  void initState() {
    super.initState();

    for(int i = 0; i < 3; i++){
      columns.add(MC());
    }

  }

  void printKeyTable(){
    print("");
    for(int i = 0; i < keyTable.length; i++){
      print(keyTable[i]);
    }
    print("");
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
                        columns.insert(1, MC());
                      });
                    },
                    icon: const Icon(Icons.add_box_rounded)
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
        makeColBtn(),
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

class MC extends StatefulWidget {

  final MCS _MCS = MCS();

  MC({
    Key? key,
  }) : super(key: key);
/*
  @override
  MCS createState() => _MCS;
  */

  @override
  MCS createState() => _MCS;

  setAlignment() => _MCS.setAlignment();

}

class MCS extends State<MC> {

  void setAlignment(){
    ;
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(" !! ");
  }

}


/*


                  print(_myColumnKeys[0].currentState!.context.size?.width);



  int countWidth(String s){
    int cnt = 0;
    for(int i = 0; i < s.length; i++){
      if( s[i].codeUnits[0] < 128 ) cnt++;
      else cnt += 2;
    }
    return cnt;
  }


  List<String> MDs = [];
  void makeMD4(){
    MDs = [];
    for(int i = 0; i < columns.length; i++){
      int maxWidth = 0;
      for(int j = 0; j < rowLen; j++){
        String s = _myColumnKeys[i].currentState?.getCellMD(j) ?? "";
        if( i == 0 ) MDs.add("|");
        MDs[j] = "${MDs[j]} $s";
        int cntWidth = countWidth(s);
        maxWidth = maxWidth > cntWidth ? maxWidth : cntWidth;
      }
      for(int j = 0; j < rowLen; j++){
        int cntWidth = countWidth(_myColumnKeys[i].currentState?.getCellMD(j) ?? "");
        print("${MDs[j]} $cntWidth $maxWidth");
        if( maxWidth - cntWidth < 4 ) MDs[j] = "${MDs[j]}\t |";
        else MDs[j] = "${MDs[j]}\t\t |";
      }
    }
    print(MDs);
  }






  https://pub.dev/packages/simple_markdown_editor/versions/0.1.6
  https://www.tablesgenerator.com/markdown_tables
 */