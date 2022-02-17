import 'package:flutter/material.dart';
import 'FocusedCell.dart';
import 'CellKeyGenerator.dart';

class MyCell extends StatelessWidget {

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int cellKey = CellKeyGenerator().getKey();
  bool init = false;

  MyCell({
    Key? key,
  }) : super(key: key);

  String getText(){
    return _controller.text;
  }

  @override
  Widget build(BuildContext context) {
    if( !init ){
      _focusNode.addListener(() {
        if( _focusNode.hasFocus ){
          print("Focus on \"${_controller.text}\"");
          FocusedCell().setKey(cellKey);
        }
      });
    }
    init = true;
    return Container(
      padding: EdgeInsets.all(10),
      constraints: BoxConstraints(minWidth: 100),
      child: IntrinsicWidth(
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
          )
      ),
    );
  }

}
