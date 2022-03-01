import 'package:flutter/material.dart';

import 'table_helper.dart';

class TableMenu extends StatefulWidget {

  const TableMenu({
    Key? key,
  }) : super(key: key);

  @override
  TableMenuState createState() => TableMenuState();

}

class TableMenuState extends State<TableMenu> {

  bool isRowSelected = false;
  bool isColSelected = false;

  TableHelper tableHelper = TableHelper();
  
  @override
  void initState(){
    super.initState();

  }

  Widget myDiv(double height) => Container(height: height, width: 1, color: Colors.grey[300]);

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
                onTap: () {
                  setState(() {
                    isRowSelected = !isRowSelected;
                  });
                },
                child: const SizedBox(
                  width: 50,
                  child: Center(child: Text("Row", style: TextStyle(fontWeight: FontWeight.bold),),),
                ),
              ),
              myDiv(10),
              InkWell(
                onTap: () {
                  tableHelper.insertRow(0);
                },
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
              ),
              myDiv(10),
              InkWell(
                onTap: () {
                  tableHelper.insertRow(1);
                },
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
              ),
              myDiv(10),
              SizedBox(
                width: 50,
                child: IconButton(
                    onPressed: () {
                      tableHelper.deleteRow();
                    },
                    icon: const Icon(Icons.indeterminate_check_box_rounded)
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget makeColBtn(){
    return AnimatedContainer(
        alignment: Alignment.centerLeft,
        duration: const Duration(milliseconds: 200),
        width: isColSelected ? 203 : 50,
        height: 50,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isColSelected = !isColSelected;
                  });
                },
                child: const SizedBox(
                  width: 50,
                  child: Center(child: Text("Col", style: TextStyle(fontWeight: FontWeight.bold),),),
                ),
              ),
              myDiv(10),
              InkWell(
                onTap: () {
                  setState(() {
                    tableHelper.insertColumn(0);
                  });
                },
                child: SizedBox(
                  width: 50,
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
              ),
              myDiv(10),
              InkWell(
                onTap: () {
                  setState(() {
                    tableHelper.insertColumn(1);
                  });
                },
                child: SizedBox(
                  width: 50,
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
              ),
              myDiv(10),
              SizedBox(
                width: 50,
                child: IconButton(
                    onPressed: () {
                      tableHelper.deleteColumn();
                    },
                    icon: const Icon(Icons.indeterminate_check_box_rounded)
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget makeAlignBtn(int alignment, Icon icon){
    return IconButton(
        onPressed: () { tableHelper.setAlignment(alignment); },
        icon: icon
    );
  }

  Widget makeMenu(){
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          makeRowBtn(),
          myDiv(40),
          makeColBtn(),
          myDiv(40),
          makeAlignBtn(0, const Icon(Icons.format_align_left_rounded)),
          makeAlignBtn(1, const Icon(Icons.format_align_center_rounded)),
          makeAlignBtn(2, const Icon(Icons.format_align_right_rounded)),
          myDiv(40),
          IconButton(
              onPressed: () { tableHelper.changeCellBold(); },
              icon: const Icon(Icons.format_bold_rounded)),
          IconButton(
              onPressed: () { tableHelper.changeCellItalic(); },
              icon: const Icon(Icons.format_italic_rounded)),
          IconButton(
              onPressed: () { tableHelper.changeCellStrike(); },
              icon: const Icon(Icons.strikethrough_s_rounded)),
          IconButton(
              onPressed: () { tableHelper.changeCellCode(); },
              icon: const Icon(Icons.code_rounded)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return makeMenu();
  }

}