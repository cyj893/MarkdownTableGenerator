import 'package:flutter/material.dart';
import 'package:markdown_table_generator/width_provider.dart';
import 'package:provider/src/provider.dart';
import 'focused_cell.dart';
import 'cell_key_generator.dart';

class MyCell extends StatefulWidget {

  final double initialWidth;
  final int initialFocused;
  final Function function;

  const MyCell({
    Key? key,
    this.initialWidth = 100,
    this.initialFocused = 0,
    required this.function,
  }) : super(key: key);

  @override
  MyCellState createState() => MyCellState();

}

class MyCellState extends State<MyCell> {

  double _width = 100.0;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int cellKey = -1;
  int _focused = 0;
  int _alignment = 1;
  int _fontWeight = 0;
  int _fontStyle = 0;
  int _strike = 0;
  int _codeColor = 0;
  final List<Color> _focusedColors = [Colors.white, Colors.grey[200]!, Colors.grey[400]!];
  final List<TextAlign> _alignments = [TextAlign.left, TextAlign.center, TextAlign.right];
  final List<FontWeight> _fontWeights = [FontWeight.normal, FontWeight.bold];
  final List<FontStyle> _fontStyles = [FontStyle.normal, FontStyle.italic];
  final List<TextDecoration> _textDecorations = [TextDecoration.none, TextDecoration.lineThrough];
  final List<Color> _colors = [Colors.white.withOpacity(0.0), Colors.grey.withOpacity(0.3)];

  @override
  void initState(){
    super.initState();

    cellKey = CellKeyGenerator().generateKey();
    _width = widget.initialWidth;
    _focused = widget.initialFocused;
    _focusNode.addListener(() {
      if( _focusNode.hasFocus ){
        debugPrint("Focus on $cellKey: \"${_controller.text}\"");
        FocusedCell().setKey(cellKey);
        widget.function();
      }
    });
  }

  Size getTextSize(String text, TextStyle textStyle){
    return (TextPainter(
        text: TextSpan(text: text, style: textStyle),
        maxLines: 1,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        textDirection: TextDirection.ltr)
      ..layout())
        .size;
  }

  void setWidth(double width) => setState(() { _width = width; });
  double getWidth() => getTextSize(_controller.text, TextStyle(
    fontSize: 16,
    fontWeight: _fontWeights[_fontWeight],
    fontStyle: _fontStyles[_fontStyle],
    decoration: _textDecorations[_strike],
    backgroundColor: _colors[_codeColor],
  )).width;
  String getText() => _controller.text;

  String getMDText(){
    String ret = _controller.text;
    if( ret == "" ) return ret;
    if( _codeColor == 1 ) ret = "`$ret`";
    if( _fontWeight == 1 ) ret = "**$ret**";
    if( _fontStyle == 1 ) ret = "_${ret}_";
    if( _strike == 1 ) ret = "~~$ret~~";
    return ret;
  }
  int getAlignment() => _alignment;

  void setFocusedColor(int focused) => setState(() { _focused = focused; });
  void changeAlignment(int alignment) => setState(() { _alignment = alignment; });
  void changeBold() => setState(() { _fontWeight = 1 - _fontWeight; });
  void changeItalic() => setState(() { _fontStyle = 1 - _fontStyle; });
  void changeStrike() => setState(() { _strike = 1 - _strike; });
  void changeCode() => setState(() { _codeColor = 1 - _codeColor; });
  void clearDeco(){
    setState(() {
      _fontWeight = 0;
      _fontStyle = 0;
      _strike = 0;
      _codeColor = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _focusedColors[_focused],
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.all(10),
      width: _width,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: (string) {
          print(string);
          context.read<WidthProvider>().changeWidth(getWidth()+30);
        },
        textAlign: _alignments[_alignment],
        style: TextStyle(
          fontSize: 16,
          fontWeight: _fontWeights[_fontWeight],
          fontStyle: _fontStyles[_fontStyle],
          decoration: _textDecorations[_strike],
          backgroundColor: _colors[_codeColor],
        ),
      ),
    );
  }

}