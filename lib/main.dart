import 'package:flutter/material.dart';
import 'package:tarea_6/screens/home.dart';

void main() async {
  await actualizarDatos();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Clima()
    );
  }
}
