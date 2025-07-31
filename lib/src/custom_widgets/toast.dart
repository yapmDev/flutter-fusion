/*
  author: yapmDev
  lastModifiedDate: 30/07/25
  repository: https://github.com/yapmDev/flutter_fusion
 */
import 'package:flutter/material.dart';

/// Displays a floating message with an optional leadingIcon and action.
///
/// Params:
///
/// [context] : Place in the widget tree where this toast is attached.
///
/// [message] : The message will be shown.
///
/// [decoration] : Can be used to customize the appearance of the toast container.
///
/// [durationInSeconds] : Sets how long the toast will be visible (in seconds).
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
/// [padding] : Empty space inside the toast.
///
/// [action] : Callback action (optional while autoClose is true, required otherwise). When called, toast will
/// be closed immediately (the closure is implicit, without depending on the body of the callback).
/// ```dart
/// // Simple action to close the toast.
/// action: ToastAction(
///    display: Icon(Icons.close_outlined),
///    callback: () {
///       // No body needed.
///    }
/// )
/// ```
/// [autoClose] : Causes it to close automatically after the set duration has elapsed. If false, an explicit action
/// is required.
///
/// For full customization across the entire app, See [ToastThemeData], [ToastTheme] and [ToastThemeExtension].
void showToast({
  required BuildContext context,
  required String message,
  Widget? leadingIcon,
  ToastAction? action,
  TextStyle? textStyle,
  BoxDecoration? decoration,
  int durationInSeconds = 2,
  Alignment position = Alignment.bottomCenter,
  EdgeInsetsGeometry margin = const EdgeInsets.all(12.0),
  EdgeInsetsGeometry padding = const EdgeInsets.all(12.0),
  double spacing = 12.0,
  bool autoClose = true
}) {
  assert(autoClose == true || (autoClose == false && action != null),
    "Because autoClose is false, you need an explicit action to close this toast. "
    "If you only need those without additional logic, you can leave an empty callback."
  );
  final toastTheme = ToastTheme.of(context);
  late final OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
      builder: (context) => SafeArea(
        child: Align(
            alignment: position,
            child: Container(
                margin: margin,
                padding: padding,
                decoration: decoration ?? toastTheme.decoration,
                child: Row(
                    spacing: spacing,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (leadingIcon != null) leadingIcon,
                      Flexible(child: Text(message, style: textStyle ?? toastTheme.textStyle)),
                      if(action != null ) GestureDetector(
                          onTap: () {
                            try {
                              action.callback.call();
                            } finally {
                              if (overlayEntry.mounted) overlayEntry.remove();
                            }
                          },
                          child: action.display
                      )
                    ]
                )
            )
        )
      )
  );
  Overlay.of(context).insert(overlayEntry);
  if(autoClose) {
    Future.delayed(Duration(seconds: durationInSeconds), () {
      if(overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}

/// Defines the data for an action used in [showToast].
class ToastAction {

  /// What should this action display.
  final Widget display;

  /// What should this action do when tapped.
  final VoidCallback callback;

  /// Creates an action to be used in [showToast].
  const ToastAction({required this.display, required this.callback});
}

/// Holds the theming data for toast messages.
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

  // Needed for ToastTheme comparison.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ToastThemeData &&
              runtimeType == other.runtimeType &&
              decoration == other.decoration &&
              textStyle == other.textStyle;

  // Needed for ToastTheme comparison.
  @override
  int get hashCode => decoration.hashCode ^ textStyle.hashCode;
}

/// Extension on [ThemeData] to set [ToastThemeData].
extension ToastThemeExtension on ThemeData {

  /// Retrieves the [ToastThemeData] from the theme extensions.
  ///
  /// If no [ToastThemeData] is found, a default one is created.
  ToastThemeData get toastTheme => extension<ToastThemeData>()
      ?? ToastThemeData(
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.onSurface),
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          color: colorScheme.surface,
        ),
        textStyle: textTheme.bodyLarge
      );
}

/// An inherited widget that provides [ToastThemeData] to its descendants.
class ToastTheme extends InheritedWidget {

  /// The [ToastThemeData] that is provided to the descendants.
  final ToastThemeData data;

  /// Creates a [ToastTheme] with the given [data] and [child].
  const ToastTheme({super.key, required this.data, required super.child});

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