import 'package:flutter/material.dart';
import 'my_cell.dart';

class MyColumn extends StatefulWidget {

  final int rowLen;

  const MyColumn({
    Key? key,
    required this.rowLen,
  }) : super(key: key);

  @override
  MyColumnState createState() => MyColumnState();

}

class MyColumnState extends State<MyColumn> {

  List<MyCell> children = [];
  final List<GlobalKey<MyCellState>> _myCellKeys = [];
  int _alignment = 1;
  final List<List> _alignments = [[MainAxisAlignment.start, CrossAxisAlignment.start],
                                  [MainAxisAlignment.center, CrossAxisAlignment.center],
                                  [MainAxisAlignment.end, CrossAxisAlignment.end]];

  @override
  void initState(){
    super.initState();

    for(int i = 0; i < widget.rowLen; i++){
      insertCell(i);
    }
  }

  int getCellKey(int index) => _myCellKeys[index].currentState!.cellKey;
  int getAlignment() => _alignment;
  String getCellMD(int index) => _myCellKeys[index].currentState!.getMDText();

  void setAlignment(int alignment) => setState(() { _alignment = alignment; });
  void changeCellBold(index) => _myCellKeys[index].currentState!.changeBold();
  void changeCellItalic(index) => _myCellKeys[index].currentState!.changeItalic();
  void changeCellStrike(index) => _myCellKeys[index].currentState!.changeStrike();
  void changeCellCode(index) => _myCellKeys[index].currentState!.changeCode();

  void insertCell(int index){
    setState(() {
      _myCellKeys.insert(index, GlobalKey());
      children.insert(index, MyCell(key: _myCellKeys[index],));
    });
  }

  void delCell(int index){
    setState(() {
      debugPrint("delete Cell \"${_myCellKeys[index].currentState!.getText()}\"");
      _myCellKeys.removeAt(index);
      children.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        mainAxisAlignment: _alignments[_alignment][0],
        crossAxisAlignment: _alignments[_alignment][1],
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

}
