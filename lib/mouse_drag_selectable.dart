import 'package:flutter/material.dart';
import 'package:markdown_table_generator/table_helper.dart';

import 'mouse_drag_box.dart';

class MouseDragSelectable extends StatelessWidget {

  Widget child;

  MouseDragSelectable(
      {Key? key, required this.child}
      ) : super(key: key);

  Offset startOffset = const Offset(0, 0);
  Offset nowOffset = const Offset(0, 0);

  GlobalKey<MouseDragBoxState> drKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    print("BUild 1");
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        startOffset = Offset(details.localPosition.dx, details.localPosition.dy);
        print("onTapDown: x: ${startOffset.dx}, y: ${startOffset.dy}");
        drKey.currentState?.rePaint(startOffset, startOffset);
      },
      onLongPressStart: (LongPressStartDetails details) {
        startOffset = Offset(details.localPosition.dx, details.localPosition.dy);
        print("onLongPressStart: x: ${startOffset.dx}, y: ${startOffset.dy}");
        drKey.currentState?.rePaint(startOffset, startOffset);
        TableHelper().startSelecting();
      },
      onLongPressMoveUpdate: (LongPressMoveUpdateDetails details){
        nowOffset = Offset(details.localPosition.dx, details.localPosition.dy);
        print("onLongPressMoveUpdate: x: ${nowOffset.dx}, y: ${nowOffset.dy}");
        drKey.currentState?.rePaint(startOffset, nowOffset);
      },
      onLongPressEnd: (LongPressEndDetails details){
        print("onLongPressEnd: x: ${details.localPosition.dx}, y: ${details.localPosition.dy}");
        TableHelper().endSelecting(startOffset, nowOffset);
        startOffset = const Offset(0, 0);
        drKey.currentState?.rePaint(startOffset, startOffset);
      },
      child: Stack(
        children: [
          child,
          MouseDragBox(key: drKey),
        ],
      ),
    );
  }

}
