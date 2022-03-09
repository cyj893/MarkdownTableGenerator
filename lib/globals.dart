
import 'package:flutter/material.dart';

const double btnSize = 50.0;

const double cellWidth = 120.0;
const double cellHeight = 72.0;

double widthMargin = 30;

const Duration animationDuration = Duration(milliseconds: 200);

const double scrollToClickDelta = 75;
const int scrollToClickFirstDelay = 200;
const int scrollToClickOtherDelay = 50;

final BoxDecoration sliderDecoration = BoxDecoration(
    color: Colors.blueGrey.withOpacity(0.2),
    borderRadius: const BorderRadius.all(Radius.circular(12.0))
);
final BoxDecoration sliderActiveDecoration = BoxDecoration(
    color: Colors.blueGrey.withOpacity(0.5),
    borderRadius: const BorderRadius.all(Radius.circular(12.0))
);