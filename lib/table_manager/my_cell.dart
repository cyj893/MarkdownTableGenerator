import 'package:flutter/material.dart';

import 'package:markdown_table_generator/my_enums.dart';
import 'cell_key_generator.dart';
import 'key_table.dart';

class MyCell extends StatefulWidget {

  final double initialWidth;
  final double initialHeight;
  final FocusColor initialFocused;

  const MyCell({
    Key? key,
    this.initialWidth = 120.0,
    this.initialHeight = 72.0,
    this.initialFocused = FocusColor.none,
  }) : super(key: key);

  @override
  MyCellState createState() => MyCellState();

}

class MyCellState extends State<MyCell> {

  final KeyTable _keyTable = KeyTable();

  int cellKey = -1;

  double _width = 0;
  double _height = 0;
  double _beforeTextWidth = 0.0;
  double _textHeight = 0.0;
  int linesNum = 1;

  final TextEditingController _listingController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String unorderedListingStr = "●";
  String orderedListingStr = "1.";

  FocusColor _focused = FocusColor.none;
  Alignments _alignment = Alignments.center;
  int _fontWeight = 0;
  int _fontStyle = 0;
  int _strike = 0;
  int _codeColor = 0;
  Listings _listing = Listings.none;

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
        _keyTable.setFocusedCellKey(cellKey);
      }
    });
  }

  void setWidth(double width){
    if( _width == width ) return ;
    setState(() { _width = width; });
  }
  void setHeight(double height){
    if( _height == height ) return ;
    setState(() { _height = height; });
  }

  void setFocusedColor(FocusColor focused){
    if( _focused == focused ) return ;
    setState(() { _focused = focused; });
  }

  void changeAlignment(Alignments alignment){
    if( _alignment == alignment ) return ;
    setState(() { _alignment = alignment; });
  }

  void changeBold() => setState(() { _fontWeight = 1 - _fontWeight; });
  void changeItalic() => setState(() { _fontStyle = 1 - _fontStyle; });
  void changeStrike() => setState(() { _strike = 1 - _strike; });
  void changeCode() => setState(() { _codeColor = 1 - _codeColor; });

  void clearDeco(){
    if( _fontWeight == 0 && _fontStyle == 0 && _strike == 0 && _codeColor == 0 ) return ;
    setState(() {
      _fontWeight = 0;
      _fontStyle = 0;
      _strike = 0;
      _codeColor = 0;
    });
  }

  void changeListing(Listings listing){
    if( _listing == listing ) return ;
    _listing = listing;
    setState(() {
      _listingController.text = _listing == Listings.unordered
          ? unorderedListingStr
          : orderedListingStr;
    });
  }

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

  String makeListingHTML(){
    String ret = _listing == Listings.unordered ? "<ul>" : "<ol>";
    List<String> list = _controller.text.split('\n');
    for(int i = 0; i < list.length; i++){
      if( _codeColor == 1 ){  // code deco should be inside
        ret += "<li>`${list[i]}`</li>";
      }
      else{
        ret += "<li>${list[i]}</li>";
      }
    }
    ret += _listing == Listings.unordered ? "</ul>" : "</ol>";
    return ret;
  }

  String getMDText(){
    String ret = "";
    ret = _listing != Listings.none
        ? makeListingHTML()
        : _controller.text.replaceAll('\n', "<br>");
    if( ret == "" ) return ret;
    if( _listing == Listings.none && _codeColor == 1 ) ret = "`$ret`";
    if( _fontWeight == 1 ) ret = "**$ret**";
    if( _fontStyle == 1 ) ret = "_${ret}_";
    if( _strike == 1 ) ret = "~~$ret~~";
    return ret;
  }

  Alignments getAlignment() => _alignment;

  void addListing(int changedLinesNum){
    unorderedListingStr +=  "\n●";
    for(int i = linesNum+1; i <= changedLinesNum; i++){
      orderedListingStr +=  "\n$i.";
    }
  }

  void subListing(int changedLinesNum){
    int unorderedSubIndex = 2 * (linesNum - changedLinesNum);
    unorderedListingStr = unorderedListingStr.substring(0, unorderedListingStr.length - unorderedSubIndex);
    int orderedSubIndex = 0;
    for(int i = changedLinesNum+1; i <= linesNum; i++){
      orderedSubIndex += 2 + i.toString().length;
    }
    orderedListingStr = orderedListingStr.substring(0, orderedListingStr.length - orderedSubIndex);
  }

  void checkHeightChanged(String string){
    int changedLinesNum = '\n'.allMatches(string).length + 1;
    if( changedLinesNum == linesNum ) return ;
    if( changedLinesNum > linesNum ){
      addListing(changedLinesNum);
    }
    else{
      subListing(changedLinesNum);
    }
    _listingController.text = _listing == Listings.unordered
        ? unorderedListingStr
        : orderedListingStr;
    linesNum = changedLinesNum;
    List indexes = _keyTable.findFocusedCell();
    _keyTable.resizeTableHeight(indexes[0]);
  }

  void checkWidthChanged(String string){
    double nowTextWidth = getSize().width + 50;
    if( _beforeTextWidth == nowTextWidth ) return ;
    if( _beforeTextWidth <= widget.initialWidth && nowTextWidth <= widget.initialWidth ) return ;
    _beforeTextWidth = nowTextWidth;
    List indexes = _keyTable.findFocusedCell();
    _keyTable.resizeTableWidth(indexes[1]);
  }

  @override
  Widget build(BuildContext context) {
    _textHeight = getSize().height;
    return Container(
      decoration: BoxDecoration(
        color: _focusedColors[_focused.index],
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.all(10),
      width: _width,
      height: _height,
      alignment: Alignment.center,
      child: Row(
        children: [
          SizedBox(
            width: _listing != Listings.none ? 20 : 0,
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
                checkHeightChanged(string);
                checkWidthChanged(string);
              },
              textAlign: _alignments[_listing != Listings.none ? 0 : _alignment.index],
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