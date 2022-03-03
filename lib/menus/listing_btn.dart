import 'package:flutter/material.dart';

import '../table_helper.dart';

class ListingBtn extends StatelessWidget {

  ListingBtn({
    Key? key,
  }) : super(key: key);

  final TableHelper tableHelper = TableHelper();

  Widget makeListingBtn(int listing, String listingString, Icon icon){
    return IconButton(
        tooltip: listingString,
        onPressed: () { tableHelper.changeListing(listing); },
        icon: icon
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        makeListingBtn(0, "no listing", const Icon(Icons.notes_rounded)),
        makeListingBtn(1, "unordered listing", const Icon(Icons.format_list_bulleted_rounded)),
        makeListingBtn(2, "ordered listing", const Icon(Icons.format_list_numbered_rounded)),
      ],
    );
  }

}
