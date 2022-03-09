import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';

import 'package:markdown_table_generator/globals.dart' as globals;
import 'package:markdown_table_generator/get_text_size.dart';
import 'table_manager/table_helper.dart';

class ShowRes extends StatefulWidget {

  const ShowRes({
    Key? key,
  }) : super(key: key);

  @override
  ShowResState createState() => ShowResState();

}

class ShowResState extends State<ShowRes> {

  TableHelper tableHelper = TableHelper();

  String mdData = "";

  final ScrollController horizontalScroll = ScrollController();
  final _textStyle = const TextStyle(fontFamily: "D2Coding");

  @override
  void initState() {
    super.initState();

    mdData =
'''
| 	 | 	 | 	 |
| :--: | :--: | :--: |
| 	 | 	 | 	 |
| 	 | 	 | 	 |
''';

  }

  Widget resMenu(){
    return Row(
      children: [
        const Text("Result", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        IconButton(
            tooltip: "refresh",
            onPressed: () { setState((){ mdData = tableHelper.makeMdData(); }); },
            icon: const Icon(Icons.refresh_rounded)),
        IconButton(
            tooltip: "copy",
            onPressed: () { debugPrint("copied"); Clipboard.setData(ClipboardData(text: mdData)); },
            icon: const Icon(Icons.file_copy_rounded)),
      ],
    );
  }

  Widget showRes(){
    int dataLength = '\n'.allMatches(mdData).length + 1;
    double height = getTextSize(context, mdData, _textStyle).height * dataLength + 30;
    return Container(
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.grey[50],
      ),
      child: AdaptiveScrollbar(
        position: ScrollbarPosition.bottom,
        controller: horizontalScroll,
        width: 10,
        scrollToClickDelta: globals.scrollToClickDelta,
        scrollToClickFirstDelay: globals.scrollToClickFirstDelay,
        scrollToClickOtherDelay: globals.scrollToClickOtherDelay,
        sliderDecoration: globals.sliderDecoration,
        sliderActiveDecoration: globals.sliderActiveDecoration,
        underColor: Colors.transparent,
        child: SingleChildScrollView(
          controller: horizontalScroll,
          scrollDirection: Axis.horizontal,
          child: SelectableText(mdData, style: _textStyle,),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        resMenu(),
        const SizedBox(height: 10,),
        showRes(),
      ],
    );
  }

}