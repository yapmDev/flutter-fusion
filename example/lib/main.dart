import 'package:flutter/material.dart';
import 'package:flutter_fusion/flutter_fusion.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StatusBarController(
        statusBarColorResolver: (_) => Colors.blue,
        allowBrightnessContrast: false,
        builder: (_) => Material(child: Text("HELLO WORLD")),
        allowOverlap: false,
      )
    );
  }
}