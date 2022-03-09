import 'package:flutter/material.dart';
import 'package:markdown_table_generator/description_container.dart';

import 'my_div.dart';
import 'table_manager/table_helper.dart';
import 'menus/table_menu.dart';
import 'show_res.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {

  TableHelper tableHelper = TableHelper();

  var _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance!.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = newValue;
      });
    }
  }

  final ScrollController horizontalScroll = ScrollController();
  final ScrollController verticalScroll = ScrollController();
  final double width = 20;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("마크다운 표 생성기", style: TextStyle(fontFamily: "D2Coding"),),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const TableMenu(),
                      horizontalDiv(MediaQuery.of(context).size.width),
                      const SizedBox(height: 10,),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 500,
                        child: tableHelper.tableManager!,
                      ),
                      const SizedBox(height: 10,),
                      horizontalDiv(MediaQuery.of(context).size.width),
                      const ShowRes(),
                      const SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
            ),
            _isKeyboardVisible? const SizedBox.shrink() : const DescriptionContainer(),
          ],
        ),
      ),
    );
  }
}
