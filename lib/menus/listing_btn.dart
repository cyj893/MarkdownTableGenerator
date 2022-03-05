import 'package:flutter/material.dart';

import 'package:markdown_table_generator/my_enums.dart';
import '../table_manager/table_helper.dart';

class ListingBtn extends StatelessWidget {

  ListingBtn({
    Key? key,
  }) : super(key: key);

  final TableHelper tableHelper = TableHelper();

  Widget makeListingBtn(Listings listing, Icon icon){
    return IconButton(
        tooltip: listing.toString().split('.').last,
        onPressed: () { tableHelper.changeListing(listing); },
        icon: icon
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        makeListingBtn(Listings.none, const Icon(Icons.notes_rounded)),
        makeListingBtn(Listings.unordered, const Icon(Icons.format_list_bulleted_rounded)),
        makeListingBtn(Listings.ordered, const Icon(Icons.format_list_numbered_rounded)),
      ],
    );
  }

}
