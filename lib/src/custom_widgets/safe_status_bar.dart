import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///Designed for mobile platforms. Allows the status bar to not overlap part of the app content,
///similar to [SafeArea] but with the difference that it provides transparency and dynamism
///with the theme to the status bar, giving consistency with modern apps.
///
/// Use:
///
/// Wrap your home widget in [MaterialApp] like this:
/// ```dart
/// SafeStatusBar(
///   child: MyAppWidget(),
/// )
/// ```
class SafeStatusBar extends StatelessWidget {
  /// Your main app content.
  final Widget child;

  ///Creates a container for your app's content, saves top padding so it doesn't overlap
  ///the status bar, and gives it a transparent color and dynamic behavior over the current theme.
  const SafeStatusBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
    ));
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Material(
      child: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: child,
      ),
    );
  }
}