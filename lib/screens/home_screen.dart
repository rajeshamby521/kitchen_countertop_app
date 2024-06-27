  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitchen_countertop_app/utils/app_strings.dart';
import '../blocs/drawing_bloc.dart';
import '../blocs/drawing_event.dart';
import '../widget/drawing_canvas.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawing App'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == AppStrings.exportFile) {
                context.read<DrawingBloc>().add(ExportToDxfDrawing());
              } else {
                double width =
                    value == AppStrings.newKitchenCountertop ? 255 : 300;
                context.read<DrawingBloc>().add(SetRectangleWidth(width));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: AppStrings.newKitchenCountertop,
                child: Text(AppStrings.newKitchenCountertop),
              ),
              const PopupMenuItem(
                value: AppStrings.newIsland,
                child: Text(AppStrings.newIsland),
              ),
              const PopupMenuItem(
                value: AppStrings.exportFile,
                child: Text(AppStrings.exportFile),
              ),
            ],
          )
        ],
      ),
      body: const DrawingCanvas(),
    );
  }
}
