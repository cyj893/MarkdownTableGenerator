import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'table_helper.dart';

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
            onPressed: () { setState((){ mdData = tableHelper.makeMdData(); }); },
            icon: const Icon(Icons.refresh_rounded)),
        IconButton(
            onPressed: () { debugPrint("copied"); Clipboard.setData(ClipboardData(text: mdData)); },
            icon: const Icon(Icons.file_copy_rounded)),
      ],
    );
  }

  Widget showRes(){
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Colors.grey[50],
      ),
      child: Row(
        children: [
          SelectableText(mdData, style: const TextStyle(fontFamily: "D2Coding"),),
          Expanded(child: Container()),
        ],
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