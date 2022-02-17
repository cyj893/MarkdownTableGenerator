import 'package:flutter/material.dart';
import 'MyCell.dart';

class MyColumn extends StatefulWidget {

  MainAxisAlignment mainAxisAlignment;
  CrossAxisAlignment crossAxisAlignment;
  int rowLen;

  MyColumn({
    Key? key,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    required this.rowLen,
  }) : super(key: key);

  @override
  MyColumnState createState() => MyColumnState();

}

class MyColumnState extends State<MyColumn> {

  List<MyCell> children = [];
  List<GlobalKey<MyCellState>> _myCellKeys = [];

  @override
  void initState(){
    super.initState();

    for(int i = 0; i < widget.rowLen; i++){
      addCell(i);
    }
  }

  void setAlignment(int alignment){
    setState(() {
      if( alignment == 0 ){
        widget.mainAxisAlignment = MainAxisAlignment.start;
        widget.crossAxisAlignment = CrossAxisAlignment.start;
      }
      else if( alignment == 1 ){
        widget.mainAxisAlignment = MainAxisAlignment.center;
        widget.crossAxisAlignment = CrossAxisAlignment.center;
      }
      else if( alignment == 2 ){
        widget.mainAxisAlignment = MainAxisAlignment.end;
        widget.crossAxisAlignment = CrossAxisAlignment.end;
      }
    });
  }

  void addCell(int index){
    setState(() {
      _myCellKeys.insert(index, GlobalKey());
      children.insert(index, MyCell(key: _myCellKeys[index],));
    });
  }

  void delCell(int index){
    setState(() {
      print("delete Cell \"${_myCellKeys[index].currentState!.getText()}\"");
      _myCellKeys.removeAt(index);
      children.removeAt(index);
    });
  }

  int getCellKey(int index){
    return _myCellKeys[index].currentState!.cellKey;
  }

  void changeCellBold(index){
    _myCellKeys[index].currentState!.changeBold();
  }

  void changeCellItalic(index){
    _myCellKeys[index].currentState!.changeItalic();
  }

  void changeCellCode(index){
    _myCellKeys[index].currentState!.changeCode();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: widget.crossAxisAlignment,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }


}

/*
import 'package:flutter/material.dart';
import 'MyCell.dart';

class MyColumn extends StatelessWidget {

  MainAxisAlignment mainAxisAlignment;
  CrossAxisAlignment crossAxisAlignment;
  List<MyCell> children;

  MyColumn({
    Key? key,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    required this.children,
  }) : super(key: key);

  void setAlignment(){
    mainAxisAlignment = MainAxisAlignment.start;
    crossAxisAlignment = CrossAxisAlignment.start;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

}

 */