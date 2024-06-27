import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/drawing_bloc.dart';
import '../blocs/drawing_event.dart';
import '../blocs/drawing_state.dart';
import '../models/rectangle.dart';

class DrawingCanvas extends StatelessWidget {
  const DrawingCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawingBloc, DrawingState>(
      builder: (context, state) {
        print("currentRectangle-->${state.currentRectangle}");
        print("selectedRectangle-->${state.selectedRectangle}");
        return GestureDetector(
          onPanStart: (details) {

            Rectangle? hitRectangle =
                _hitTest(state.rectangles, details.localPosition);
            if (hitRectangle != null) {
              context
                  .read<DrawingBloc>()
                  .add(SelectRectangle(hitRectangle, details.localPosition));
            } else {
              context
                  .read<DrawingBloc>()
                  .add(StartDrawing(details.localPosition));
            }
          },
          onPanUpdate: (details) {
            if (state.selectedRectangle != null) {
              context
                  .read<DrawingBloc>()
                  .add(UpdateDrag(details.localPosition));
            } else {
              context
                  .read<DrawingBloc>()
                  .add(UpdateDrawing(details.localPosition));
            }
          },
          onPanEnd: (details) {
            if (state.currentRectangle != null) {
              context.read<DrawingBloc>().add(FinishDrawing());
            } else {
              context.read<DrawingBloc>().add(FinishDrag());
            }
          },
          child: CustomPaint(
            size: Size.infinite,
            painter: DrawingPainter(state.rectangles, state.currentRectangle),
          ),
        );
      },
    );
  }

  Rectangle? _hitTest(List<Rectangle> rectangles, Offset position) {
    for (var rectangle in rectangles) {
      if ((position.dx >= rectangle.start.dx &&
              position.dx <= rectangle.end.dx) &&
          (position.dy >= rectangle.start.dy &&
              position.dy <= rectangle.end.dy)) {
        return rectangle;
      }
    }
    return null;
  }
}

class DrawingPainter extends CustomPainter {
  final List<Rectangle> rectangles;
  final Rectangle? currentRectangle;

  DrawingPainter(this.rectangles, this.currentRectangle);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.fill;

    for (var rectangle in rectangles) {
      _drawRectangleWithDimensions(canvas, rectangle, paint);
    }

    if (currentRectangle != null) {
      _drawRectangleWithDimensions(canvas, currentRectangle!, paint);
    }
  }

  void _drawRectangleWithDimensions(
      Canvas canvas, Rectangle rectangle, Paint paint) {
    final rect = Rect.fromPoints(rectangle.start, rectangle.end);
    canvas.drawRect(rect, paint);

    _drawText(canvas, 'W: ${((rect.width)/10).abs().toStringAsFixed(2)} in',
        rect.bottomCenter);
    _drawText(canvas, 'H: ${((rect.height)/10).abs().toStringAsFixed(2)} in',
        rect.centerLeft,
        vertical: true);
  }

  void _drawText(Canvas canvas, String text, Offset position,
      {bool vertical = false}) {
    final textPainter = TextPainter(
      textAlign: TextAlign.right,
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: text,
        style: const TextStyle(color: Colors.black, fontSize: 14),
      ),
    );

    textPainter.layout();

    if (vertical) {
      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.rotate(-1.5708); // Rotate -90 degrees in radians
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();
    } else {
      textPainter.paint(canvas, position);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
