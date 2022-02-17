import 'package:flutter/material.dart';
import 'MyCell.dart';

class MyColumn extends StatefulWidget {

  MainAxisAlignment mainAxisAlignment;
  CrossAxisAlignment crossAxisAlignment;
  List<MyCell> children;

  MyColumn({
    Key? key,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    required this.children,
  }) : super(key: key);

  @override
  MyColumnState createState() => MyColumnState();

}

class MyColumnState extends State<MyColumn> {

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
      widget.children.insert(index, MyCell());
    });
  }

  void delCell(int index){
    setState(() {
      print("delete Cell \"${widget.children[index].getText()}\"");
      widget.children.removeAt(index);
    });
  }

  int getCellKey(int index){
    return widget.children[index].cellKey;
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
        children: widget.children,
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