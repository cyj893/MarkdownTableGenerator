import 'package:flutter/material.dart';
import 'package:markdown_table_generator/menus/listing_btn.dart';
import 'package:markdown_table_generator/menus/clear_table_btn.dart';

import '../my_div.dart';
import 'read_csv_btn.dart';
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
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        verticalDiv(40),
        const RowBtn(),
        verticalDiv(40),
        const ColBtn(),
        verticalDiv(40),
        const AlignBtn(),
        verticalDiv(40),
        const TextDecoBtn(),
        verticalDiv(40),
        const ListingBtn(),
        verticalDiv(40),
        const ReadCsvBtn(),
        verticalDiv(40),
        const ClearTableBtn(),
        verticalDiv(40),
      ],
    );
  }

}
