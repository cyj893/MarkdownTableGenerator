import 'package:flutter/material.dart';

import 'package:markdown_table_generator/globals.dart' as globals;
import 'package:markdown_table_generator/my_enums.dart';
import 'package:markdown_table_generator/get_text_size.dart';
import 'input_link_inkwell.dart';
import 'cell_key_generator.dart';
import '../key_table.dart';

class MyCell extends StatefulWidget {

  final String initialText;
  final double initialWidth;
  final double initialHeight;
  final FocusColor initialFocused;

  const MyCell({
    Key? key,
    this.initialText = "",
    this.initialWidth = globals.cellWidth,
    this.initialHeight = globals.cellHeight,
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
  double _listingWidth = 0.0;
  int linesNum = 1;

  final TextEditingController _listingController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String unorderedListingStr = "●";
  String orderedListingStr = "1.";

  FocusColor _focused = FocusColor.none;
  Alignments _alignment = Alignments.center;
  int _fontWeight = 0;
  int _fontStyle = 0;
  int _strike = 0;
  int _codeColor = 0;
  int _isLink = 0;
  Listings _listing = Listings.none;

  final List<Color> _focusedColors = [Colors.white, Colors.blue[50]!.withOpacity(0.3), Colors.blue[50]!];
  final List<TextAlign> _alignments = [TextAlign.left, TextAlign.center, TextAlign.right];
  final List<FontWeight> _fontWeights = [FontWeight.normal, FontWeight.bold];
  final List<FontStyle> _fontStyles = [FontStyle.normal, FontStyle.italic];
  final List<TextDecoration> _textDecorations = [TextDecoration.none, TextDecoration.lineThrough];
  final List<Color> _backgroundColors = [Colors.white.withOpacity(0.0), Colors.grey.withOpacity(0.3)];
  final List<Color> _textColors = [Colors.black87, Colors.blueAccent];

  @override
  void initState(){
    super.initState();

    cellKey = CellKeyGenerator().generateKey();
    _textController.text = widget.initialText;
    checkHeightChanged(widget.initialText);
    _width = widget.initialWidth;
    _height = widget.initialHeight;
    _focused = widget.initialFocused;
    _focusNode.addListener(() {
      if( _focusNode.hasFocus ){
        debugPrint("Focus on $cellKey: \"${_textController.text}\"");
        _keyTable.setFocusedCellKey(cellKey);
      }
    });
  }

  void setText(String text){
    debugPrint("set $cellKey: $text");
    _textController.text = text;
    checkHeightChanged(text);
    checkWidthChanged(text);
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
  void changeLink() => setState(() { _isLink = 1 - _isLink; });

  void clearDeco(){
    if( _fontWeight == 0 && _fontStyle == 0 && _strike == 0 && _codeColor == 0 && _isLink == 0 ) return ;
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



  TextStyle _makeTextStyle() => TextStyle(
    fontSize: 16,
    fontWeight: _fontWeights[_fontWeight],
    fontStyle: _fontStyles[_fontStyle],
    decoration: _textDecorations[_strike],
    backgroundColor: _backgroundColors[_codeColor],
    color: _textColors[_isLink],
  );

  Size getSize() => getTextSize(context, _textController.text, _makeTextStyle());

  double getHeight() => _textHeight * linesNum + 50;

  String makeListingHTML(){
    String ret = _listing == Listings.unordered ? "<ul>" : "<ol>";
    List<String> list = _textController.text.split('\n');
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
        : _textController.text.replaceAll('\n', "<br>");
    if( ret == "" ) return ret;
    if( _listing == Listings.none && _codeColor == 1 ) ret = "`$ret`";
    if( _fontWeight == 1 ) ret = "**$ret**";
    if( _fontStyle == 1 ) ret = "_${ret}_";
    if( _strike == 1 ) ret = "~~$ret~~";
    if( _isLink == 1 ) ret = "[$ret](${_linkController.text})";
    return ret;
  }

  Alignments getAlignment() => _alignment;

  void addListing(int changedLinesNum){
    for(int i = linesNum+1; i <= changedLinesNum; i++){
      unorderedListingStr +=  "\n●";
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
  }

  void checkWidthChanged(String string){
    double nowTextWidth = getSize().width + globals.widthMargin;
    if( _beforeTextWidth == nowTextWidth ) return ;
    if( _beforeTextWidth <= widget.initialWidth && nowTextWidth <= widget.initialWidth ) return ;
    _beforeTextWidth = nowTextWidth;
  }

  Widget makeListingField() => SizedBox(
      width: _listing != Listings.none ? _listingWidth + 10 : 0,
      child: TextField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: _listingController,
        enabled: false,
      )
  );

  Widget makeTextField() => TextField(
    keyboardType: TextInputType.multiline,
    maxLines: null,
    controller: _textController,
    focusNode: _focusNode,
    onChanged: (string) {
      debugPrint("string: $string");
      if( string.contains('\t') ){
        _keyTable.inputFromCopy(string);
        return ;
      }
      checkHeightChanged(string);
      checkWidthChanged(string);
      List indexes = _keyTable.findFocusedCell();
      _keyTable.resizeTableHeight(indexes[0]);
      _keyTable.resizeTableWidth(indexes[1]);
    },
    textAlign: _alignments[_listing != Listings.none ? 0 : _alignment.index],
    style: _makeTextStyle(),
  );

  Container buildCell(){
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
          makeListingField(),
          Expanded(child: makeTextField()),
        ],
      ),
    );
  }

  Widget makeLinkBtn(){
    return _isLink == 0
        ? const SizedBox.shrink()
        : Positioned.fill(
          child:Align(
            alignment: Alignment.topRight,
            child: InputLinkInkWell(
              controller: _linkController,
              width: 200,
              onReturn: () { debugPrint("Return: ${_linkController.text}"); },
              child: const SizedBox(
                width: 20,
                height: 20,
                child: Icon(Icons.link_rounded, size: 16, color: Colors.grey,),
              ),
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    _textHeight = getSize().height;
    _listingWidth = getTextSize(context, "00.", _makeTextStyle()).width;
    globals.widthMargin = _listingWidth + 40;
    return Stack(
      children: [
        buildCell(),
        makeLinkBtn(),
      ],
    );
  }

}