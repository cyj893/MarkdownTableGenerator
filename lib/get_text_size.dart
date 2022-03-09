import 'package:flutter/material.dart';

Size getTextSize(BuildContext context, String text, TextStyle textStyle){
  return (TextPainter(
      text: TextSpan(text: text, style: textStyle),
      maxLines: 1,
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      textDirection: TextDirection.ltr)
    ..layout())
      .size;
}