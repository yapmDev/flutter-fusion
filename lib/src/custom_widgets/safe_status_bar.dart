/*
  author: yapmDev
  lastModifiedDate: 28/01/25
  repository: https://github.com/yapmDev/flutter_fusion
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///Designed for mobile platforms. Allows the status bar to not overlap part of the app content,
///similar to [SafeArea] but with the difference that it provides transparency and dynamism
///with the theme to the status bar, giving consistency with modern apps.
///
/// Use:
///
/// Only once at the top level of your application like this:
/// ```dart
/// MaterialApp(
///   home: SafeStatusBar(
///     child: MyAppWidget(),
///     statusBarColorResolver:
///       (isDarkMode) => isDarkMode ? randomColor() : randomColor(),
///   ),
/// )
/// ```
/// Or even using [go_router] package
/// ```dart
/// MaterialApp.router(
///   builder: (context, child) => SafeStatusBar(child: child!),
///   routerConfig: appRouter,
/// )
/// ```
class SafeStatusBar extends StatelessWidget {
  /// Your main app content.
  final Widget child;

  ///An optional resolver based on the current themeMode. If [null] then [Colors.transparent] will
  ///be apply.
  final Color? Function(bool isDarkMode)? statusBarColorResolver;

  ///Creates a container for your app's content, saves top padding so it doesn't overlap
  ///the status bar, and gives it a transparent color by default and dynamic behavior over the
  ///current theme.
  const SafeStatusBar({
    super.key,
    required this.child,
    this.statusBarColorResolver
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: statusBarColorResolver?.call(isDarkMode) ?? Colors.transparent,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
    ));
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Material(
        child: Padding(
          padding: EdgeInsets.only(top: statusBarHeight),
          child: child,
        ),
      ),
    );
  }
}