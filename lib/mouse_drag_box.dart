import 'package:flutter/material.dart';

class MouseDragBox extends StatefulWidget {

  MouseDragBox(
      {Key? key}
      ) : super(key: key);

  @override
  State<MouseDragBox> createState() => MouseDragBoxState();
}

class MouseDragBoxState extends State<MouseDragBox> {

  Offset startOffset = Offset(0, 0);
  Offset nowOffset = Offset(0, 0);

  void rePaint(Offset so, Offset no){
    setState(() {
      startOffset = so;
      nowOffset = no;
      print("rePaint");
      print("${so.dx}, ${so.dy}      ${no.dx}, ${no.dy}");
    });
  }

  @override
  Widget build(BuildContext context) {
    print("BUild 2");
    return RepaintBoundary(
      child: CustomPaint(
        painter: MyPainter(
            startOffset: startOffset,
            nowOffset: nowOffset,
            boxColor: Colors.deepPurpleAccent.withOpacity(0.1)
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {

  Offset startOffset;
  Offset nowOffset;
  Color boxColor;

  MyPainter({required this.startOffset, required this.nowOffset, required this.boxColor});

  @override
  void paint(Canvas canvas, Size size) {
    if( startOffset == nowOffset ) return ;
    Paint paint = Paint()
      ..color = boxColor;
    canvas.drawRect(Rect.fromPoints(startOffset, nowOffset), paint);
    print("paint");
    print("${startOffset.dx}, ${startOffset.dy}        ${nowOffset.dx}, ${nowOffset.dy}");
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) {
    print("shouldRepaint");
    print("${oldDelegate.startOffset.dx}, ${oldDelegate.startOffset.dy}        ${oldDelegate.nowOffset.dx}, ${oldDelegate.nowOffset.dy}");
    print("${startOffset.dx}, ${startOffset.dy}        ${nowOffset.dx}, ${nowOffset.dy}");
    return (oldDelegate.startOffset != startOffset) || (oldDelegate.nowOffset != nowOffset);
  }
}