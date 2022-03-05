import 'package:flutter/material.dart';

import '../my_div.dart';
import '../table_manager/table_helper.dart';

class TextDecoBtn extends StatelessWidget {

  TextDecoBtn({
    Key? key,
  }) : super(key: key);

  final TableHelper tableHelper = TableHelper();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            tooltip: "bold",
            onPressed: () { tableHelper.changeCellBold(); },
            icon: const Icon(Icons.format_bold_rounded)),
        IconButton(
            tooltip: "italic",
            onPressed: () { tableHelper.changeCellItalic(); },
            icon: const Icon(Icons.format_italic_rounded)),
        IconButton(
            tooltip: "strikethrough",
            onPressed: () { tableHelper.changeCellStrike(); },
            icon: const Icon(Icons.strikethrough_s_rounded)),
        IconButton(
            tooltip: "code",
            onPressed: () { tableHelper.changeCellCode(); },
            icon: const Icon(Icons.code_rounded)),
        verticalDiv(10),
        IconButton(
            tooltip: "clear",
            onPressed: () { tableHelper.clearCellDeco(); },
            icon: const Icon(Icons.clear_rounded)),
      ],
    );
  }

}
