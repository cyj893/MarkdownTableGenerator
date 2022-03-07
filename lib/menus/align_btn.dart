import 'package:flutter/material.dart';

import 'package:markdown_table_generator/my_enums.dart';
import '../table_manager/table_helper.dart';

class AlignBtn extends StatelessWidget {

  const AlignBtn({
    Key? key,
  }) : super(key: key);

  Widget makeAlignBtn(Alignments alignment, Icon icon){
    return IconButton(
      tooltip: alignment.toString().split('.').last,
      onPressed: () { TableHelper().setAlignment(alignment); },
      icon: icon
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        makeAlignBtn(Alignments.left, const Icon(Icons.format_align_left_rounded)),
        makeAlignBtn(Alignments.center, const Icon(Icons.format_align_center_rounded)),
        makeAlignBtn(Alignments.right, const Icon(Icons.format_align_right_rounded)),
      ],
    );
  }

}
