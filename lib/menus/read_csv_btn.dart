import 'package:flutter/material.dart';
import 'package:markdown_table_generator/table_manager/key_table.dart';

import '../file_drag_and_drop.dart';

class ReadCsvBtn extends StatelessWidget {

  const ReadCsvBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        tooltip: "upload csv",
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: const FileDragAndDrop(),
                  actions: [
                    TextButton(
                        onPressed: () {
                          KeyTable().resizeTable();
                          Navigator.of(context).pop();
                        },
                        child: const Text("close"),
                    ),
                  ],
                );
              });
        },
        icon: const Icon(Icons.upload_file)
    );
  }

}
