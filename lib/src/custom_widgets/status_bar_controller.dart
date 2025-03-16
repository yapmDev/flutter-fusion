/*
  author: yapmDev
  lastModifiedDate: 5/03/25
  repository: https://github.com/yapmDev/flutter_fusion
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Designed for mobile platforms. Allows you to configure aspects of the status bar such as
/// overlay, so that the content of a view is not overlapped by the status bar. The color and
/// brightness will automatically adapt depending on the theme mode.
///
/// @Warning:
///
/// Widgets like [AppBar] and [SliverAppBar] automatically disable status bar overlay and their
/// style is set via the `systemOverlayStyle` property. So you should not use this API in views
/// where these widgets are already in use.
class StatusBarController extends StatelessWidget {

  /// An optional color resolver based on the current theme mode. If [null]
  /// then [Colors .transparent] will be apply.
  final Color? Function(bool isDarkMode)? statusBarColorResolver;

  /// Define how the status bar brightness behaves. By default the system sets a contrast to
  /// maintain accessibility, for example in light theme the status bar elements are dark. If
  /// `false`, the brightness of the elements would be the same as the current theme.
  final bool allowBrightnessContrast;

  /// Allows if the status bar can overlap the UI. `true` by default like the default system
  /// behavior.
  final bool allowOverlap;

  /// The child of this widget. Normally the view itself.
  final Widget child;

  ///Wraps any view in to customize the status bar behavior for that view in particular.
  const StatusBarController({
    super.key,
    this.statusBarColorResolver,
    this.allowBrightnessContrast = true,
    this.allowOverlap = true,
    required this.child,
  });

  @override


  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final statusBarIconBrightness = allowBrightnessContrast
        ? (isDarkMode ? Brightness.light : Brightness.dark)
        : (isDarkMode ? Brightness.dark : Brightness.light);

    final statusBarBrightness = allowBrightnessContrast
        ? (isDarkMode ? Brightness.dark : Brightness.light)
        : (isDarkMode ? Brightness.light : Brightness.dark);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: statusBarColorResolver?.call(isDarkMode) ?? Colors.transparent,
      statusBarIconBrightness: statusBarIconBrightness,
      statusBarBrightness: statusBarBrightness,
    ));

    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Padding(
      padding: EdgeInsets.only(top: allowOverlap ? 0.0 : statusBarHeight),
      child: child,
    );
  }
}