import 'package:flutter/material.dart';

import 'package:markdown_table_generator/my_enums.dart';
import '../table_helper.dart';

class AlignBtn extends StatelessWidget {

  AlignBtn({
    Key? key,
  }) : super(key: key);

  final TableHelper tableHelper = TableHelper();

  Widget makeAlignBtn(Alignments alignment, Icon icon){
    return IconButton(
      tooltip: alignment.toString().split('.').last,
      onPressed: () { tableHelper.setAlignment(alignment); },
      icon: icon
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        makeAlignBtn(Alignments.left, const Icon(Icons.format_align_left_rounded)),
        makeAlignBtn(Alignments.center, const Icon(Icons.format_align_center_rounded)),
        makeAlignBtn(Alignments.right, const Icon(Icons.format_align_right_rounded)),
      ],
    );
  }

}
