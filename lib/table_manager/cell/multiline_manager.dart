import 'package:flutter/material.dart';

import 'package:markdown_table_generator/my_enums.dart';

class MultiLineManager {
  int _linesNum = 1;
  Listings _listing = Listings.none;
  double _width = 0.0;

  final TextEditingController _listingController = TextEditingController();

  String unorderedListingStr = "●";
  String orderedListingStr = "1.";

  void setListing(Listings listing){
    _listing = listing;
    setText();
  }
  Listings getListing() => _listing;

  void setWidth(double width) => _width = width;
  double getWidth() => _width;

  void setText(){
    _listingController.text = _listing == Listings.unordered
        ? unorderedListingStr
        : orderedListingStr;
  }
  String getText() => _listingController.text;

  void setLinesNum(int linesNum){
    _linesNum = linesNum;
  }
  int getLinesNum() => _linesNum;

  void addListing(int changedLinesNum){
    for(int i = _linesNum+1; i <= changedLinesNum; i++){
      unorderedListingStr +=  "\n●";
      orderedListingStr +=  "\n$i.";
    }
    setText();
  }

  void subListing(int changedLinesNum){
    int unorderedSubIndex = 2 * (_linesNum - changedLinesNum);
    unorderedListingStr = unorderedListingStr.substring(0, unorderedListingStr.length - unorderedSubIndex);
    int orderedSubIndex = 0;
    for(int i = changedLinesNum+1; i <= _linesNum; i++){
      orderedSubIndex += 2 + i.toString().length;
    }
    orderedListingStr = orderedListingStr.substring(0, orderedListingStr.length - orderedSubIndex);
    setText();
  }

  Widget makeListingField() => SizedBox(
      width: _listing != Listings.none ? _width + 10 : 0,
      child: TextField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: _listingController,
        enabled: false,
      )
  );

}