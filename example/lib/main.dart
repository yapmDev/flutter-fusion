import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        allowOverlap: false,
        systemUiMode: SystemUiMode.manual,
        overlays: [SystemUiOverlay.top],
        builder: (_) => Scaffold(
          body: Text("HELLO WORLD")
        ),
      )
    );
  }
}