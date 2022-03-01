import 'package:flutter/material.dart';

import '../table_helper.dart';

class AlignBtn extends StatelessWidget {

  AlignBtn({
    Key? key,
  }) : super(key: key);

  final TableHelper tableHelper = TableHelper();

  Widget makeAlignBtn(int alignment, Icon icon){
    return IconButton(
        onPressed: () { tableHelper.setAlignment(alignment); },
        icon: icon
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        makeAlignBtn(0, const Icon(Icons.format_align_left_rounded)),
        makeAlignBtn(1, const Icon(Icons.format_align_center_rounded)),
        makeAlignBtn(2, const Icon(Icons.format_align_right_rounded)),
      ],
    );
  }

}
