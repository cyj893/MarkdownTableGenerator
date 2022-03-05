import 'package:flutter/material.dart';
import 'package:markdown_table_generator/menus/listing_btn.dart';

import '../my_div.dart';
import 'row_btn.dart';
import 'col_btn.dart';
import 'align_btn.dart';
import 'text_deco_btn.dart';

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
