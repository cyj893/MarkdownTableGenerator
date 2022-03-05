import 'package:flutter/material.dart';

class MouseDragBox extends StatefulWidget {

  const MouseDragBox({Key? key}) : super(key: key);

  @override
  State<MouseDragBox> createState() => MouseDragBoxState();
}

class MouseDragBoxState extends State<MouseDragBox> {

  Offset startOffset = const Offset(0, 0);
  Offset nowOffset = const Offset(0, 0);

  void rePaint(Offset so, Offset no){
    setState(() {
      startOffset = so;
      nowOffset = no;
    });
  }

  @override
  Widget build(BuildContext context) {
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
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) {
    return (oldDelegate.startOffset != startOffset) || (oldDelegate.nowOffset != nowOffset);
  }
}