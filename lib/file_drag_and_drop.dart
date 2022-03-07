import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cp949/cp949.dart' as cp949;

import 'table_manager/table_helper.dart';

class FileDragAndDrop extends StatefulWidget {
  const FileDragAndDrop({Key? key}) : super(key: key);

  @override
  FileDragAndDropState createState() => FileDragAndDropState();
}

class FileDragAndDropState extends State<FileDragAndDrop> {
  final List<XFile> _list = [];

  final TableHelper tableHelper = TableHelper();

  bool _dragging = false;

  Color uploadingColor = Colors.blue[100]!;
  Color defaultColor = Colors.grey[400]!;

  Container makeDropZone(){
    Color color = _dragging ? uploadingColor : defaultColor;
    return Container(
      height: 200,
      width: 400,
      decoration: BoxDecoration(
        border: Border.all(width: 5, color: color,),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("Drop Your ", style: TextStyle(color: color, fontSize: 20,),),
              Text(".csv File", style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 20,),),
              Icon(Icons.insert_drive_file_rounded, color: color,),
              Text(" Here", style: TextStyle(color: color, fontSize: 20,),),
            ],
          ),
          InkWell(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['csv'],
              );
              if (result != null && result.files.isNotEmpty) {
                final fileBytes = result.files.first.bytes!.buffer.asUint8List();
                final fileName = result.files.first.name;
                debugPrint("Read $fileName");
                String csvStr = "";
                try{
                  csvStr = utf8.decode(fileBytes);
                  debugPrint("decode: UTF8");
                }
                catch (e) {
                  debugPrint("decode: CP949");
                  csvStr = cp949.decode(fileBytes);
                }
                debugPrint(csvStr);
                tableHelper.readFromCSV(csvStr);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("or ", style: TextStyle(color: color,),),
                Text("Find and Upload", style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 20,),),
                Icon(Icons.upload_rounded, color: color,),
              ],
            ),
          ),
          Text("(Supporting Encoding: UTF-8, CP949(EUC-KR))", style: TextStyle(color: color,),),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (detail) async {
        setState(() {
          _list.addAll(detail.files);
        });
        debugPrint('onDragDone:');
        for(final file in detail.files){
          if (file != null) {
            final fileBytes = await file.readAsBytes();
            String csvStr = "";
            try{
              csvStr = utf8.decode(fileBytes);
              debugPrint("decode: UTF8");
            }
            catch (e) {
              debugPrint("decode: CP949");
              csvStr = cp949.decode(fileBytes);
            }
            debugPrint(csvStr);
            tableHelper.readFromCSV(csvStr);
          }
        }
      },
      onDragEntered: (detail) {
        setState(() {
          debugPrint('onDragEntered:');
          _dragging = true;
        });
      },
      onDragExited: (detail) {
        debugPrint('onDragExited:');
        setState(() {
          _dragging = false;
        });
      },
      child: makeDropZone(),
    );
  }
}