import 'package:flutter/material.dart';
import 'FocusedCell.dart';
import 'CellKeyGenerator.dart';

class MyCell extends StatefulWidget {

  MyCell({
    Key? key,
  }) : super(key: key);

  @override
  MyCellState createState() => MyCellState();

}

class MyCellState extends State<MyCell> {

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int cellKey = CellKeyGenerator().getKey();
  int _fontWeight = 0;
  int _fontStyle = 0;
  int _color = 0;
  List<FontWeight> _fontWeights = [FontWeight.normal, FontWeight.bold];
  List<FontStyle> _fontStyles = [FontStyle.normal, FontStyle.italic];
  List<Color> _colors = [Colors.white, Colors.grey[200]!];

  @override
  void initState(){
    super.initState();

    _focusNode.addListener(() {
      if( _focusNode.hasFocus ){
        print("Focus on \"${_controller.text}\"");
        FocusedCell().setKey(cellKey);
      }
    });
  }

  String getText(){
    return _controller.text;
  }

  void changeBold(){
    setState(() {
      _fontWeight = 1 - _fontWeight;
    });
  }

  void changeItalic(){
    setState(() {
      _fontStyle = 1 - _fontStyle;
    });
  }

  void changeCode(){
    setState(() {
      _color = 1 - _color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      constraints: BoxConstraints(minWidth: 100),
      child: IntrinsicWidth(
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            style: TextStyle(
              fontWeight: _fontWeights[_fontWeight],
              fontStyle: _fontStyles[_fontStyle],
              backgroundColor: _colors[_color],
            ),
          )
      ),
    );
  }

}