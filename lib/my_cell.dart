import 'package:flutter/material.dart';
import 'package:markdown_table_generator/cell_size_provider.dart';
import 'package:provider/provider.dart';
import 'focused_cell.dart';
import 'cell_key_generator.dart';

class MyCell extends StatefulWidget {

  final double initialWidth;
  final double initialHeight;
  final int initialFocused;
  final Function function;

  const MyCell({
    Key? key,
    this.initialWidth = 120.0,
    this.initialHeight = 72.0,
    this.initialFocused = 0,
    required this.function,
  }) : super(key: key);

  @override
  MyCellState createState() => MyCellState();

}

class MyCellState extends State<MyCell> {

  double _width = 0;
  double _height = 0;
  double _beforeTextWidth = 0.0;
  double _textHeight = 0.0;
  int linesNum = 1;
  final TextEditingController _listingController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int cellKey = -1;
  int _focused = 0;
  int _alignment = 1;
  int _fontWeight = 0;
  int _fontStyle = 0;
  int _strike = 0;
  int _codeColor = 0;
  int _listing = 0;
  final List<Color> _focusedColors = [Colors.white, Colors.blue[50]!.withOpacity(0.3), Colors.blue[50]!];
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
    _height = widget.initialHeight;
    _focused = widget.initialFocused;
    _focusNode.addListener(() {
      if( _focusNode.hasFocus ){
        debugPrint("Focus on $cellKey: \"${_controller.text}\"");
        FocusedCell().setKey(cellKey);
        widget.function();
      }
    });

  }

  void setWidth(double width) => setState(() { _width = width; });
  void setHeight(double height) => setState(() { _height = height; });

  int getKeyNum() => cellKey;

  Size getTextSize(String text, TextStyle textStyle){
    return (TextPainter(
        text: TextSpan(text: text, style: textStyle),
        maxLines: 1,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        textDirection: TextDirection.ltr)
      ..layout())
        .size;
  }

  Size getSize() => getTextSize(_controller.text, TextStyle(
    fontSize: 16,
    fontWeight: _fontWeights[_fontWeight],
    fontStyle: _fontStyles[_fontStyle],
    decoration: _textDecorations[_strike],
    backgroundColor: _colors[_codeColor],
  ));

  double getHeight() => _textHeight * linesNum + 50;

  String getText() => _controller.text;

  String getMDText(){
    if( _listing == 0 ){
      String ret = _controller.text.replaceAll('\n', "<br>");

      if( ret == "" ) return ret;
      if( _codeColor == 1 ) ret = "`$ret`";
      if( _fontWeight == 1 ) ret = "**$ret**";
      if( _fontStyle == 1 ) ret = "_${ret}_";
      if( _strike == 1 ) ret = "~~$ret~~";
      return ret;
    }
    String ret = _listing == 1 ? "<ul>" : "<ol>";
    List<String> list = _controller.text.split('\n');
    for(int i = 0; i < list.length; i++){
      ret += "<li>${list[i]}</li>";
    }
    ret += _listing == 1 ? "</ul>" : "</ol>";
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
  void changeListing(int listing){
    setState(() {
      _listing = listing;
      if( listing == 1 ){
        String str = "●";
        for(int i = 1; i < linesNum; i++){
          str += "\n●";
        }
        _listingController.text = str;
      }
      else if( listing == 2 ){
        String str = "1.";
        for(int i = 1; i < linesNum; i++){
          str += "\n${i+1}.";
        }
        _listingController.text = str;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _textHeight = getSize().height;
    return Container(
      decoration: BoxDecoration(
        color: _focusedColors[_focused],
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.all(10),
      width: _width,
      height: _height,
      alignment: Alignment.center,
      child: Row(
        children: [
          SizedBox(
            width: _listing > 0 ? 20 : 0,
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: _listingController,
              enabled: false,
            )
          ),
          Expanded(
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: _controller,
              focusNode: _focusNode,
              onChanged: (string) {
                debugPrint("string: $string");
                int nowLinesNum = '\n'.allMatches(string).length + 1;
                if( nowLinesNum > linesNum ){
                  linesNum = nowLinesNum;
                  _listingController.text += _listing == 2 ? "\n$linesNum." : "\n●";
                  context.read<CellSizeProvider>().changeHeight();
                }
                else if( nowLinesNum < linesNum ){
                  linesNum = nowLinesNum;
                  context.read<CellSizeProvider>().changeHeight();
                }
                double nowTextWidth = getSize().width+50;
                if( _beforeTextWidth <= widget.initialWidth && nowTextWidth <= widget.initialWidth ) return ;
                if( _beforeTextWidth == nowTextWidth ) return ;
                _beforeTextWidth = nowTextWidth;
                context.read<CellSizeProvider>().changeWidth();
              },
              textAlign: _alignments[_listing > 0 ? 0 : _alignment],
              style: TextStyle(
                fontSize: 16,
                fontWeight: _fontWeights[_fontWeight],
                fontStyle: _fontStyles[_fontStyle],
                decoration: _textDecorations[_strike],
                backgroundColor: _colors[_codeColor],
              ),
            )
          )
        ],
      ),
    );
  }

}