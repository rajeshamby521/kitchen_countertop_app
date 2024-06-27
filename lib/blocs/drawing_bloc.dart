import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:dxf/dxf.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:kitchen_countertop_app/utils/app_strings.dart';
import 'package:path_provider/path_provider.dart';

import '../models/rectangle.dart';
import '../repositories/drawing_repository.dart';
import 'drawing_event.dart';
import 'drawing_state.dart';

class DrawingBloc extends Bloc<DrawingEvent, DrawingState> {
  final DrawingRepository drawingRepository;

  DrawingBloc(this.drawingRepository) : super(DrawingState(rectangles: [])) {
    on<StartDrawing>(_onStartDrawing);
    on<UpdateDrawing>(_onUpdateDrawing);
    on<FinishDrawing>(_onFinishDrawing);
    on<SetRectangleWidth>(_onSetRectangleWidth);
    on<SelectRectangle>(_onSelectRectangle);
    on<UpdateDrag>(_onUpdateDrag);
    on<FinishDrag>(_onFinishDrag);
    on<ClearDrawing>(_onClearDrawing);
    on<ExportToDxfDrawing>(_onExportToDxfDrawing);
  }

  void _onStartDrawing(StartDrawing event, Emitter<DrawingState> emit) {
    Rectangle? selectedRectangle = state.selectedRectangle = null;
    Offset? dragStartOffset = state.dragStartOffset = null;

    emit(state.copyWith(
        currentRectangle:
            Rectangle(event.start, event.start, state.rectangleWidth),
        selectedRectangle: selectedRectangle,
        dragStartOffset: dragStartOffset));
  }

  void _onUpdateDrawing(UpdateDrawing event, Emitter<DrawingState> emit) {
    if (state.currentRectangle != null) {
      double height = (event.end.dy - state.currentRectangle!.start.dy).abs();
      double endY = event.end.dy > state.currentRectangle!.start.dy
          ? state.currentRectangle!.start.dy + height
          : state.currentRectangle!.start.dy - height;
      double endX = event.end.dx > state.currentRectangle!.start.dx
          ? state.currentRectangle!.start.dx + state.rectangleWidth
          : state.currentRectangle!.start.dx - state.rectangleWidth;

      Offset potentialEnd = Offset(endX, endY);

      if (!drawingRepository.isOverlapping(state.currentRectangle!.start,
          potentialEnd, state.currentRectangle)) {
        state.currentRectangle!.end = potentialEnd;
        emit(state.copyWith(currentRectangle: state.currentRectangle));
      }
    }
  }

  void _onFinishDrawing(FinishDrawing event, Emitter<DrawingState> emit) {
    if (state.currentRectangle != null) {
      if (!drawingRepository.isOverlapping(state.currentRectangle!.start,
          state.currentRectangle!.end, state.currentRectangle)) {
        drawingRepository.addRectangle(state.currentRectangle!);
        emit(state.copyWith(
          rectangles: List.from(state.rectangles)..add(state.currentRectangle!),
        ));
        emit(state.copyWith(currentRectangle: null));
      } else {
        emit(state.copyWith(currentRectangle: null));
      }
    }
  }

  void _onSetRectangleWidth(
      SetRectangleWidth event, Emitter<DrawingState> emit) {
    emit(state.copyWith(rectangleWidth: event.width));
  }

  void _onSelectRectangle(SelectRectangle event, Emitter<DrawingState> emit) {
    emit(state.copyWith(
      selectedRectangle: null,
      dragStartOffset: event.dragStart,
    ));
    emit(state.copyWith(
      selectedRectangle: event.rectangle,
      dragStartOffset: event.dragStart,
    ));
  }

  void _onUpdateDrag(UpdateDrag event, Emitter<DrawingState> emit) {
    if (state.selectedRectangle != null && state.dragStartOffset != null) {
      Offset dragDelta = event.newOffset - state.dragStartOffset!;
      Offset potentialStart = state.selectedRectangle!.start + dragDelta;
      Offset potentialEnd = state.selectedRectangle!.end + dragDelta;

      if (!drawingRepository.isOverlapping(
          potentialStart, potentialEnd, state.selectedRectangle)) {
        state.selectedRectangle!.start = potentialStart;
        state.selectedRectangle!.end = potentialEnd;
        emit(state.copyWith(
          selectedRectangle: state.selectedRectangle,
          dragStartOffset: event.newOffset,
        ));
      }
    }
  }

  void _onFinishDrag(FinishDrag event, Emitter<DrawingState> emit) {
    emit(state.copyWith(
      selectedRectangle: null,
      dragStartOffset: null,
    ));
  }

  void _onClearDrawing(ClearDrawing event, Emitter<DrawingState> emit) {
    drawingRepository.clearRectangles();
    emit(state.copyWith(
      rectangles: [],
      currentRectangle: null,
      selectedRectangle: null,
      dragStartOffset: null,
    ));
  }

  _onExportToDxfDrawing(ExportToDxfDrawing event, Emitter<DrawingState> emit) {
    exportToDXF();
  }

  Future<void> exportToDXF() async {
    var dxf = DXF.create();

    for (var rect in state.rectangles) {
      var vertices = <List<double>>[];

      vertices.addAll([
        [rect.offset.dx, rect.offset.dy],
        [rect.offset.dx + rect.width, rect.offset.dy],
        [rect.offset.dx + rect.width, rect.offset.dy],
        [rect.offset.dx, rect.offset.dy],
        [rect.offset.dx, rect.offset.dy]
      ]);

      var polyline = AcDbPolyline(vertices: vertices, isClosed: false);
      dxf.addEntities(polyline);
    }


    print(dxf.dxfString);
    final dxfData = dxf.toString();

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/drawing.dxf';
    final file = File(path);
    await file.writeAsString(dxfData);

    final Email email = Email(
      body: AppStrings.dxfAttached,
      subject: AppStrings.dxfDrawing,
      recipients: [AppStrings.emailId],
      attachmentPaths: [path],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }
}
