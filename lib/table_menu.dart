import 'package:flutter/material.dart';
import 'package:markdown_table_generator/menus/listing_btn.dart';

import 'my_div.dart';
import 'menus/row_btn.dart';
import 'menus/col_btn.dart';
import 'menus/align_btn.dart';
import 'menus/text_deco_btn.dart';

class TableMenu extends StatelessWidget {

  const TableMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          verticalDiv(40),
          const RowBtn(),
          verticalDiv(40),
          const ColBtn(),
          verticalDiv(40),
          AlignBtn(),
          verticalDiv(40),
          TextDecoBtn(),
          verticalDiv(40),
          ListingBtn(),
          verticalDiv(40),
        ],
      ),
    );
  }

}
