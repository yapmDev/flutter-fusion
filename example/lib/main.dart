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
      home: HomePage()
    );
  }
}

class HomePage extends StatelessWidget {

  HomePage({super.key});

  final controller = OverlayPortalController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () => showToast(
              leadingIcon: Icon(Icons.done_outline),
                context: context,
                durationInSeconds: 5,
                message: "Cliente Reportado",
                action: ToastAction(
                    display: Material(child: Text("Ir a Inicio")),
                    callback: () {}
                )
            ),
            child: Text("Show Toast"),
          )
        )
    );
  }
}