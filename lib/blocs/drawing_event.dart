import 'package:flutter/material.dart';
import '../models/rectangle.dart';

abstract class DrawingEvent {}

class StartDrawing extends DrawingEvent {
  final Offset start;

  StartDrawing(this.start);
}

class UpdateDrawing extends DrawingEvent {
  final Offset end;

  UpdateDrawing(this.end);
}

class FinishDrawing extends DrawingEvent {}

class SetRectangleWidth extends DrawingEvent {
  final double width;

  SetRectangleWidth(this.width);
}

class SelectRectangle extends DrawingEvent {
  final Rectangle rectangle;
  final Offset dragStart;

  SelectRectangle(this.rectangle, this.dragStart);
}

class UpdateDrag extends DrawingEvent {
  final Offset newOffset;

  UpdateDrag(this.newOffset);
}

class FinishDrag extends DrawingEvent {}

class ClearDrawing extends DrawingEvent {}

class ExportToDxfDrawing extends DrawingEvent {}
