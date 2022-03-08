import 'package:flutter/material.dart';
import 'package:markdown_table_generator/table_manager/table_helper.dart';

class ClearTableBtn extends StatelessWidget {

  const ClearTableBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        tooltip: "clear table",
        onPressed: () {
          TableHelper().clearTable();
        },
        icon: const Icon(Icons.view_comfortable_rounded)
    );
  }

}
