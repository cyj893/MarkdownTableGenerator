import 'package:flutter/material.dart';

import 'package:markdown_table_generator/globals.dart' as globals;
import '../my_div.dart';
import '../table_manager/table_helper.dart';

class ColBtn extends StatefulWidget {

  const ColBtn({
    Key? key,
  }) : super(key: key);

  @override
  ColBtnState createState() => ColBtnState();

}

class ColBtnState extends State<ColBtn> {

  bool isColSelected = false;

  TableHelper tableHelper = TableHelper();

  @override
  void initState(){
    super.initState();

  }

  Widget addLeftColBtn(){
    return InkWell(
      onTap: () { tableHelper.insertColumn(0); },
      child: SizedBox(
        width: globals.btnSize,
        child: Stack(
          children: const [
            Positioned(
              bottom: 12.5,
              right: 17.5,
              width: 25,
              height: 25,
              child: Icon(Icons.add_box_rounded, size: 25,),
            ),
            Positioned(
              bottom: 15,
              right: 2.5,
              width: 20,
              height: 20,
              child: Icon(Icons.arrow_left_rounded, size: 20,),
            ),
          ],
        ),
      ),
    );
  }

  Widget addRightColBtn(){
    return InkWell(
      onTap: () { tableHelper.insertColumn(1); },
      child: SizedBox(
        width: globals.btnSize,
        child: Stack(
          children: const [
            Positioned(
              bottom: 15,
              left: 2.5,
              width: 20,
              height: 20,
              child: Icon(Icons.arrow_right_rounded, size: 20,),
            ),
            Positioned(
              bottom: 12.5,
              left: 17.5,
              width: 25,
              height: 25,
              child: Icon(Icons.add_box_rounded, size: 25,),
            ),
          ],
        ),
      ),
    );
  }

  Widget makeColBtn(){
    return AnimatedContainer(
        alignment: Alignment.centerLeft,
        duration: globals.animationDuration,
        width: isColSelected ? globals.btnSize*4+3 : globals.btnSize,
        height: globals.btnSize,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              InkWell(
                onTap: () { setState((){ isColSelected = !isColSelected; }); },
                child: const SizedBox(
                  width: globals.btnSize,
                  child: Center(child: Text("Col", style: TextStyle(fontWeight: FontWeight.bold),),),
                ),
              ),
              verticalDiv(10),
              Tooltip(message: "add to the left", child: addLeftColBtn(),),
              verticalDiv(10),
              Tooltip(message: "add to the right", child: addRightColBtn(),),
              verticalDiv(10),
              SizedBox(
                width: globals.btnSize,
                child: IconButton(
                  tooltip: "delete",
                  onPressed: () { tableHelper.deleteColumn(); },
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
    return makeColBtn();
  }

}