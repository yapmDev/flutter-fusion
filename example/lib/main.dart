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
            // onPressed: controller.toggle,
            onPressed: () => showToast(
                context: context,
                leadingIcon: Icon(Icons.warning_amber_outlined),
                // message: "Hello from overlay, this is intentionally a bigger message body",
                message: "Hello from overlay",
                action: ToastAction(
                    display: Icon(Icons.close_outlined),
                    callback: () {}
                ),
                autoClose: false
            ),
            child: Text("Press Me"),
          )
        )
    );
  }
}