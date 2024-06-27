import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitchen_countertop_app/utils/app_strings.dart';
import 'repositories/drawing_repository.dart';
import 'screens/home_screen.dart';
import 'blocs/drawing_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DrawingBloc>(
          create: (context) => DrawingBloc(
            DrawingRepository(),
          ),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
