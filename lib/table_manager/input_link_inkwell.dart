import 'package:flutter/material.dart';


class InputLinkInkWell extends StatefulWidget {
  final TextEditingController controller;
  final double width;
  final double verticalOffset;
  final Function onReturn;
  final Widget child;

  const InputLinkInkWell({
    Key? key,
    required this.controller,
    this.width = 100.0,
    this.verticalOffset = 5.0,
    required this.onReturn,
    required this.child,
  }) : super(key: key);

  @override
  InputLinkInkWellState createState() => InputLinkInkWellState();
}

class InputLinkInkWellState extends State<InputLinkInkWell> {

  OverlayEntry? _overlayEntry;
  bool _isShowing = false;
  Widget? _overlayWidget;

  @override
  void initState(){
    super.initState();

    _overlayWidget = makeOverlayWidget();
  }

  Widget makeOverlayWidget(){
    return Material(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.controller,
                decoration: const InputDecoration(
                    hintText: "Put Your Link"
                ),
              ),
            ),
            IconButton(
              splashRadius: 20,
              onPressed: () {
                _overlayEntry!.remove();
                _isShowing = false;
                widget.onReturn();
              },
              icon: const Icon(Icons.check_circle_outline_rounded, size: 20,),
            )
          ],
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject()! as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    return OverlayEntry(
        builder: (context) => Positioned(
          left: offset.dx,
          top: offset.dy + size.height + widget.verticalOffset,
          width: widget.width,
          child: _overlayWidget!,
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0x00000000),
      child: InkWell(
        onTap: () {
          if( _isShowing ) return ;
          _overlayEntry = _createOverlayEntry();
          Overlay.of(context)!.insert(_overlayEntry!);
          _isShowing = true;
        },
        child: widget.child,
      ),
    );
  }
}
