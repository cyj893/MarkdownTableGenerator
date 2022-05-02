import 'package:flutter/material.dart';

import '../my_div.dart';
import '../table_manager/table_helper.dart';
import '../my_enums.dart';

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
            onPressed: () { TableHelper().changeCellDeco(CellDecoChange.bold); },
            icon: const Icon(Icons.format_bold_rounded)),
        IconButton(
            tooltip: "italic",
            onPressed: () { TableHelper().changeCellDeco(CellDecoChange.italic); },
            icon: const Icon(Icons.format_italic_rounded)),
        IconButton(
            tooltip: "strikethrough",
            onPressed: () { TableHelper().changeCellDeco(CellDecoChange.strike); },
            icon: const Icon(Icons.strikethrough_s_rounded)),
        IconButton(
            tooltip: "code",
            onPressed: () { TableHelper().changeCellDeco(CellDecoChange.code); },
            icon: const Icon(Icons.code_rounded)),
        verticalDiv(10),
        IconButton(
            tooltip: "clear",
            onPressed: () { TableHelper().changeCellDeco(CellDecoChange.clearAll); },
            icon: const Icon(Icons.clear_rounded)),
        verticalDiv(10),
        IconButton(
            tooltip: "link",
            onPressed: () { TableHelper().changeCellDeco(CellDecoChange.link); },
            icon: const Icon(Icons.link_rounded)),
      ],
    );
  }

}
