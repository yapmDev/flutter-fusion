/*
  author: yapmDev
  lastModifiedDate: 09/05/25
  repository: https://github.com/yapmDev/flutter_fusion
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// {@template status_bar_controller_description}
/// Designed for mobile platforms. Allows you to configure aspects of the status bar.
///
/// @Warning:
///
/// This widget is powered by the [SystemChrome] service class, therefore, widgets like [AppBar] and [SliverAppBar]
/// automatically override the style settings. Therefore, you should not use this API in
/// views where these widgets are already in use. However, styling can still be controlled via the
/// `systemOverlayStyle` property they provide.
/// {@endtemplate}
class StatusBarController extends StatelessWidget {

  /// An optional color resolver based on the current theme mode. If [null]
  /// then [Colors .transparent] will be apply.
  final Color? Function(bool isDarkMode)? statusBarColorResolver;

  /// Define how the status bar brightness behaves. By default the system sets a contrast to
  /// maintain accessibility, for example in light theme the status bar elements are dark. If
  /// `false`, the brightness of the elements would be the same as the current theme.
  final bool allowBrightnessContrast;

  /// Allows if the status bar can overlap the UI. `true` by default like the default system behavior.
  final bool allowOverlap;

  /// Describes different display configurations for both Android and iOS. These modes mimic Android-specific display
  /// setups. Flutter apps use `SystemUiMode.edgeToEdge` by default and setting any other will `NOT` work unless you
  /// perform the migration detailed in
  /// https://docs.flutter.dev/release/breaking-changes/default-systemuimode-edge-to-edge.
  // TODO("yapmDev")
  // - Download API 35 (android 15) x86 Google Play Image to test this.
  final SystemUiMode? systemUiMode;

  /// The system ui overlays used when [systemUiMode] has been set as [SystemUiMode.manual]. Please refer to this to
  /// fully understand how it works.
  final List<SystemUiOverlay>? overlays;

  /// The child of this widget. Normally the view itself.
  final Widget Function(double statusBarHeight) builder;

  /// {@macro status_bar_controller_description}
  const StatusBarController({
    super.key,
    required this.builder,
    this.statusBarColorResolver,
    this.allowBrightnessContrast = true,
    this.allowOverlap = true,
    this.systemUiMode,
    this.overlays
  }) : assert (
    (systemUiMode == null || systemUiMode != SystemUiMode.manual) ||
    (systemUiMode == SystemUiMode.manual && overlays != null),
    "When systemUiMode is set as manual, overlays needs to be specified (can be empty but not null)"
  );

  @override
  Widget build(BuildContext context) {

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final statusBarIconBrightness = allowBrightnessContrast
        ? (isDarkMode ? Brightness.light : Brightness.dark)
        : (isDarkMode ? Brightness.dark : Brightness.light);
    final statusBarBrightness = allowBrightnessContrast
        ? (isDarkMode ? Brightness.dark : Brightness.light)
        : (isDarkMode ? Brightness.light : Brightness.dark);
    SystemChrome.setEnabledSystemUIMode(systemUiMode ?? SystemUiMode.edgeToEdge, overlays: overlays);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: statusBarColorResolver?.call(isDarkMode) ?? Colors.transparent,
      statusBarIconBrightness: statusBarIconBrightness,
      statusBarBrightness: statusBarBrightness,
    ));
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Padding(
      padding: EdgeInsets.only(top: allowOverlap ? 0.0 : statusBarHeight),
      child: builder.call(statusBarHeight)
    );
  }
}