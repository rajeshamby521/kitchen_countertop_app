import 'package:flutter/material.dart';
import '../models/rectangle.dart';

class DrawingState {
  List<Rectangle> rectangles;
  Rectangle? currentRectangle;
  double rectangleWidth;
  Rectangle? selectedRectangle;
  Offset? dragStartOffset;

  DrawingState({
    required this.rectangles,
    this.currentRectangle,
    this.rectangleWidth = 255,
    this.selectedRectangle,
    this.dragStartOffset,
  });

  DrawingState copyWith({
    List<Rectangle>? rectangles,
    Rectangle? currentRectangle,
    double? rectangleWidth,
    Rectangle? selectedRectangle,
    Offset? dragStartOffset,
  }) {
    return DrawingState(
      rectangles: rectangles ?? this.rectangles,
      currentRectangle: currentRectangle ?? this.currentRectangle,
      rectangleWidth: rectangleWidth ?? this.rectangleWidth,
      selectedRectangle: selectedRectangle ?? this.selectedRectangle,
      dragStartOffset: dragStartOffset ?? this.dragStartOffset,
    );
  }
}
