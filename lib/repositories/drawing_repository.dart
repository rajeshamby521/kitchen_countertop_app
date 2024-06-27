import 'package:flutter/material.dart';
import '../models/rectangle.dart';

class DrawingRepository {
  List<Rectangle> rectangles = [];

  void addRectangle(Rectangle rectangle) {
    rectangles.add(rectangle);
  }

  void updateRectangle(Rectangle oldRectangle, Rectangle newRectangle) {
    int index = rectangles.indexOf(oldRectangle);
    if (index != -1) {
      rectangles[index] = newRectangle;
    }
  }

  void clearRectangles() {
    rectangles.clear();
  }

  bool isOverlapping(Offset start, Offset end, Rectangle? currentRectangle) {
    double startX = start.dx;
    double endX = end.dx;
    double startY = start.dy;
    double endY = end.dy;

    // Adjust start and end points if drawing from bottom to top
    if (startY > endY) {
      double temp = startY;
      startY = endY;
      endY = temp;
    }

    for (var rect in rectangles) {
      if (rect != currentRectangle) {
        if (!(endX < rect.start.dx ||
            startX > rect.end.dx ||
            endY < rect.start.dy ||
            startY > rect.end.dy)) {
          return true; // Overlaps with another rectangle
        }
      }
    }
    return false; // No overlap detected
  }

}
