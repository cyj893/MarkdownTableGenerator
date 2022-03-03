import 'package:flutter/material.dart';

import '../table_helper.dart';

class ListingBtn extends StatefulWidget {

  const ListingBtn({
    Key? key,
  }) : super(key: key);

  @override
  ListingBtnState createState() => ListingBtnState();

}

class ListingBtnState extends State<ListingBtn> {

  int listing = 0;
  final List<Icon> icons = const [Icon(Icons.dehaze_rounded), Icon(Icons.format_list_bulleted_rounded), Icon(Icons.format_list_numbered_rounded)];

  TableHelper tableHelper = TableHelper();

  @override
  void initState(){
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        tooltip: "listing",
        onPressed: () {
          setState(() {
            listing = (listing+1) % 3;
            tableHelper.changeListing(listing);
          });
        },
        icon: icons[listing]
    );
  }

}