import 'package:flutter/material.dart';

import '../my_div.dart';
import '../table_manager/table_helper.dart';

class TextDecoBtn extends StatelessWidget {

  const TextDecoBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            tooltip: "bold",
            onPressed: () { TableHelper().changeCellBold(); },
            icon: const Icon(Icons.format_bold_rounded)),
        IconButton(
            tooltip: "italic",
            onPressed: () { TableHelper().changeCellItalic(); },
            icon: const Icon(Icons.format_italic_rounded)),
        IconButton(
            tooltip: "strikethrough",
            onPressed: () { TableHelper().changeCellStrike(); },
            icon: const Icon(Icons.strikethrough_s_rounded)),
        IconButton(
            tooltip: "code",
            onPressed: () { TableHelper().changeCellCode(); },
            icon: const Icon(Icons.code_rounded)),
        verticalDiv(10),
        IconButton(
            tooltip: "link",
            onPressed: () { TableHelper().changeCellLink(); },
            icon: const Icon(Icons.link_rounded)),
        verticalDiv(10),
        IconButton(
            tooltip: "clear",
            onPressed: () { TableHelper().clearCellDeco(); },
            icon: const Icon(Icons.clear_rounded)),
      ],
    );
  }

}
