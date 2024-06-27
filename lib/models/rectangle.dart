import 'package:flutter/material.dart';

class Rectangle {
  Offset start;
  Offset end;
  double width;
  Offset offset;

  Rectangle(this.start, this.end, this.width) : offset = Offset.zero;
}
