/*
  author: yapmDev
  lastModifiedDate: 27/01/25
  repository: https://github.com/yapmDev/flutter_fusion
 */

import 'package:flutter/material.dart';

/// Displays a floating message with an optional action.
///
/// @Params:
///
/// [message] : The message will be shown (required).
///
/// [context] : Place in the widget tree where this toast is attached.
///
/// [decoration] : Can be used to customize the appearance of the toast container.
///
/// [duration] : Sets how long the toast will be visible (default is 2 seconds).
///
/// [leadingIcon] : Can be an optional icon displayed before the message.
///
/// [textStyle] : Can be used to customize the appearance of the message text.
///
/// [position] : The position on the screen where this toast will show up. This method works
/// by overlaying a custom container as if it were in a [Stack], that is why [Alignment] has control
/// of the position.
///
/// [margin] : Empty space to surround the toast.
///
/// [onAction] : An optional callback that is triggered when the TextButton is tapped.
///
/// [labelAction] : The name of the action itself.
///
/// @See [Builder], could be necessary to make sure the most inner context is
/// provided, specially when you use a specific theme with [ToastTheme].
void showToast({
  required BuildContext context,
  required String message,
  BoxDecoration? decoration,
  Duration duration = const Duration(seconds: 2),
  Icon? leadingIcon,
  TextStyle? textStyle,
  Alignment position = Alignment.bottomCenter,
  EdgeInsetsGeometry margin = const EdgeInsets.all(10.0),
  ToastCallback? onAction,
  String? actionLabel
}) {
  assert(onAction == null || actionLabel != null,
  "An action tag is required if you want to do some callback");
  ToastThemeData toastTheme = ToastTheme.of(context);
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Material(
      color: Colors.transparent,
      child: Align(
        alignment: position,
        child: Container(
          margin: margin,
          decoration: decoration ?? toastTheme.decoration,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: onAction != null ? MainAxisSize.max : MainAxisSize.min,
            children: [
              if (leadingIcon != null) leadingIcon,
              if (leadingIcon != null) const SizedBox(width: 24.0),
              Flexible(
                fit: onAction != null ? FlexFit.tight : FlexFit.loose,
                child: Text(
                  message,
                  style: textStyle ?? toastTheme.textStyle,
                ),
              ),
              if (onAction != null) TextButton(onPressed: onAction, child: Text(actionLabel!))
            ],
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry);

  Future.delayed(duration, () {
    overlayEntry.remove();
  });
}

/// Holds the theming data for toast messages.
@immutable
class ToastThemeData extends ThemeExtension<ToastThemeData> {
  /// The decoration for the toast container.
  final BoxDecoration? decoration;

  /// The text style for the toast message.
  final TextStyle? textStyle;

  /// Creates a [ToastThemeData] with the given [decoration] and [textStyle].
  const ToastThemeData({
    this.decoration,
    this.textStyle,
  });

  @override
  ToastThemeData copyWith({BoxDecoration? decoration, TextStyle? textStyle}) {
    return ToastThemeData(
      decoration: decoration ?? this.decoration,
      textStyle: textStyle ?? this.textStyle,
    );
  }

  @override
  ToastThemeData lerp(covariant ThemeExtension<ToastThemeData>? other, double t) {
    if (other is! ToastThemeData) return this;
    return ToastThemeData(
      decoration: BoxDecoration.lerp(decoration, other.decoration, t),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ToastThemeData &&
              runtimeType == other.runtimeType &&
              decoration == other.decoration &&
              textStyle == other.textStyle;

  @override
  int get hashCode => decoration.hashCode ^ textStyle.hashCode;
}

/// An inherited widget that provides [ToastThemeData] to its descendants.
class ToastTheme extends InheritedWidget {
  /// The [ToastThemeData] that is provided to the descendants.
  final ToastThemeData data;

  /// Creates a [ToastTheme] with the given [data] and [child].
  const ToastTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// Retrieves the nearest [ToastThemeData] up the widget tree.
  ///
  /// If no [ToastTheme] is found, the default [ToastThemeData] from the current
  /// [ThemeData] is returned.
  static ToastThemeData of(BuildContext context) {
    final ToastTheme? toastTheme = context.dependOnInheritedWidgetOfExactType<ToastTheme>();
    return toastTheme?.data ?? Theme.of(context).toastTheme;
  }

  @override
  bool updateShouldNotify(ToastTheme oldWidget) => data != oldWidget.data;
}

/// Extension on [ThemeData] to include [ToastThemeData].
extension ToastThemeExtension on ThemeData {
  /// Retrieves the [ToastThemeData] from the theme extensions.
  ///
  /// If no [ToastThemeData] is found, a default one is created.
  ToastThemeData get toastTheme {
    return extension<ToastThemeData>() ??
        ToastThemeData(
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.onSurface),
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            color: colorScheme.surface,
          ),
          textStyle: textTheme.bodyLarge,
        );
  }
}

typedef ToastCallback = void Function();