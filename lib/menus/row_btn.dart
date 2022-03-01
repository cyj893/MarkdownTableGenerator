import 'package:flutter/material.dart';

import '../my_div.dart';
import '../table_helper.dart';

class RowBtn extends StatefulWidget {

  const RowBtn({
    Key? key,
  }) : super(key: key);

  @override
  RowBtnState createState() => RowBtnState();

}

class RowBtnState extends State<RowBtn> {

  bool isRowSelected = false;

  TableHelper tableHelper = TableHelper();

  @override
  void initState(){
    super.initState();

  }

  Widget addUpRowBtn(){
    return InkWell(
      onTap: () { tableHelper.insertRow(0); },
      child: SizedBox(
        width: 50,
        child: Stack(
          children: const [
            Positioned(
              bottom: 15,
              right: 12.5,
              width: 25,
              height: 25,
              child: Icon(Icons.add_box_rounded, size: 25,),
            ),
            Positioned(
              bottom: 0,
              right: 15,
              width: 20,
              height: 20,
              child: Icon(Icons.arrow_drop_up_rounded, size: 20,),
            ),
          ],
        ),
      ),
    );
  }

  Widget addBottomRowBtn(){
    return InkWell(
      onTap: () { tableHelper.insertRow(1); },
      child: SizedBox(
        width: 50,
        child: Stack(
          children: const [
            Positioned(
              top: 5,
              right: 15,
              width: 20,
              height: 20,
              child: Icon(Icons.arrow_drop_down_rounded, size: 20,),
            ),
            Positioned(
              bottom: 5,
              right: 12.5,
              width: 25,
              height: 25,
              child: Icon(Icons.add_box_rounded, size: 25,),
            ),
          ],
        ),
      ),
    );
  }

  Widget makeRowBtn(){
    return AnimatedContainer(
        alignment: Alignment.centerLeft,
        duration: const Duration(milliseconds: 200),
        width: isRowSelected ? 203 : 50,
        height: 50,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              InkWell(
                onTap: () { setState((){ isRowSelected = !isRowSelected; }); },
                child: const SizedBox(
                  width: 50,
                  child: Center(child: Text("Row", style: TextStyle(fontWeight: FontWeight.bold),),),
                ),
              ),
              verticalDiv(10),
              addUpRowBtn(),
              verticalDiv(10),
              addBottomRowBtn(),
              verticalDiv(10),
              SizedBox(
                width: 50,
                child: IconButton(
                    onPressed: () { tableHelper.deleteRow(); },
                    icon: const Icon(Icons.indeterminate_check_box_rounded)
                ),
              ),
            ],
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return makeRowBtn();
  }

}