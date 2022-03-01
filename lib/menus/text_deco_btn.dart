import 'package:flutter/material.dart';

import '../my_div.dart';
import '../table_helper.dart';

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
            onPressed: () { tableHelper.changeCellBold(); },
            icon: const Icon(Icons.format_bold_rounded)),
        IconButton(
            onPressed: () { tableHelper.changeCellItalic(); },
            icon: const Icon(Icons.format_italic_rounded)),
        IconButton(
            onPressed: () { tableHelper.changeCellStrike(); },
            icon: const Icon(Icons.strikethrough_s_rounded)),
        IconButton(
            onPressed: () { tableHelper.changeCellCode(); },
            icon: const Icon(Icons.code_rounded)),
        verticalDiv(10),
        IconButton(
            onPressed: () { tableHelper.clearCellDeco(); },
            icon: const Icon(Icons.clear_rounded)),
      ],
    );
  }

}
