import 'package:flutter/material.dart';
import 'focused_cell.dart';
import 'cell_key_generator.dart';

class MyCell extends StatefulWidget {

  const MyCell({
    Key? key,
  }) : super(key: key);

  @override
  MyCellState createState() => MyCellState();

}

class MyCellState extends State<MyCell> {

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int cellKey = CellKeyGenerator().generateKey();
  int _fontWeight = 0;
  int _fontStyle = 0;
  int _strike = 0;
  int _color = 0;
  final List<FontWeight> _fontWeights = [FontWeight.normal, FontWeight.bold];
  final List<FontStyle> _fontStyles = [FontStyle.normal, FontStyle.italic];
  final List<TextDecoration> _textDecorations = [TextDecoration.none, TextDecoration.lineThrough];
  final List<Color> _colors = [Colors.white.withOpacity(0.0), Colors.grey.withOpacity(0.3)];

  @override
  void initState(){
    super.initState();

    _focusNode.addListener(() {
      if( _focusNode.hasFocus ){
        debugPrint("Focus on $cellKey: \"${_controller.text}\"");
        FocusedCell().setKey(cellKey);
      }
    });
  }

  String getText() => _controller.text;

  String getMDText(){
    String ret = _controller.text;
    if( ret == "" ) return ret;
    if( _color == 1 ) ret = "`$ret`";
    if( _fontWeight == 1 ) ret = "**$ret**";
    if( _fontStyle == 1 ) ret = "_${ret}_";
    if( _strike == 1 ) ret = "~~$ret~~";
    return ret;
  }

  void changeBold() => setState(() { _fontWeight = 1 - _fontWeight; });
  void changeItalic() => setState(() { _fontStyle = 1 - _fontStyle; });
  void changeStrike() => setState(() { _strike = 1 - _strike; });
  void changeCode() => setState(() { _color = 1 - _color; });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      constraints: const BoxConstraints(minWidth: 100),
      child: IntrinsicWidth(
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            style: TextStyle(
              fontWeight: _fontWeights[_fontWeight],
              fontStyle: _fontStyles[_fontStyle],
              decoration: _textDecorations[_strike],
              backgroundColor: _colors[_color],
            ),
          )
      ),
    );
  }

}