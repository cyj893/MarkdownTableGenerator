import 'dart:typed_data';
import 'dart:convert' show utf8;
// ignore: import_of_legacy_library_into_null_safe
import 'package:cp949/cp949.dart' as cp949;

import 'package:flutter/material.dart';

class CsvConverter {

  static String convertBytesToString(Uint8List fileBytes){
    String ret = "";
    try{
      ret = utf8.decode(fileBytes);
      debugPrint("decode: UTF8");
    }
    catch (e) {
      ret = cp949.decode(fileBytes);
      debugPrint("decode: CP949");
    }
    return ret;
  }

  static List<List<String>> splitCSV(String csvStr){
    csvStr = csvStr.replaceAll('\r\n', '\n'); // convert CRLF to LF
    List<List<String>> list = [[]];
    int now = 0;
    for(int i = 0; i < csvStr.length; i++){
      if( csvStr[i] == '"' ){
        String s = "";
        int j = i+1;
        for( ; j < csvStr.length; j++){
          if( csvStr[j] == '"' ){
            j++;
            if( j >= csvStr.length ){
              debugPrint("splitCSV error");
              return [];
            }
            bool breakSign = false;
            switch (csvStr[j]) {
              case '"': // just "
                s += '"';
                break;
              case ',': // cell ending
                list[now].add(s);
                breakSign = true;
                break;
              case '\n':  // cell ending and line ending
                list[now].add(s);
                list.add([]);
                now++;
                breakSign = true;
                break;
              default:
                debugPrint("splitCSV Error");
                return [];
            }
            if( breakSign ) break;
          }
          else{
            s += csvStr[j];
          }
        }
        i = j;
      }
      else{
        String s = "";
        int j = i;
        for( ; j < csvStr.length; j++){
          bool breakSign = false;
          switch (csvStr[j]) {
            case '"':
              j++;
              if( j >= csvStr.length ){
                debugPrint("splitCSV Error");
                return [];
              }
              if( csvStr[j] == '"' ){ // just "
                s += '"';
              }
              else{
                debugPrint("splitCSV Error");
                return [];
              }
              break;
            case ',': // cell ending
              list[now].add(s);
              breakSign = true;
              break;
            case '\n':  // cell ending and line ending
              list[now].add(s);
              list.add([]);
              now++;
              breakSign = true;
              break;
            default:
              s += csvStr[j];
          }
          if( breakSign ) break;
        }
        i = j;
      }
    }
    if( list.last.isEmpty ) list.removeAt(list.length-1);
    return list;
  }


}