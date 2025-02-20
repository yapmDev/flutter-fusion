/*
  author: yapmDev
  lastModifiedDate: 20/02/25
  repository: https://github.com/yapmDev/flutter_fusion
 */

import 'package:flutter/material.dart';

///Allows you to customize the views bellow in the hierarchy that interact with the keyboard based
/// on its state (active or hidden).
class KeyboardLayoutBuilder extends StatefulWidget {

  /// Creates a KeyboardLayoutBuilder with the given [builder].
  ///
  /// @Warnings
  ///
  /// - If [allowOverlap] is [false] and spacing is not handled properly it can cause an
  /// [OverflowError].
  ///
  /// - To this works properly remember set [Scaffold.resizeToAvoidBottomInset] to [false] if you
  /// are using it. This solution is a better way to handle that.
  ///
  /// @Usage Tip
  ///
  /// If the structure is a little more complex, avoid repeated calls to this constructor or
  /// parameter passing by globally listening to the keyboard state.
  ///
  /// Note that there is no [KLB] that wraps this view directly.
  /// ```dart
  /// return Material(
  ///   child: ValueListenableBuilder(
  ///     //child: ImmutableChild() widget whose state does not depend on keyboard visibility,
  ///     valueListenable: KeyboardController.isKeyboardVisible,
  ///     builder: (context, isVisible, immutableChild) => Column(
  ///       children: [
  ///         //immutableChild!
  ///         Text(isVisible ? "Visible" : "Not Visible"),
  ///         TextField(),
  ///       ]`,
  ///     ),
  ///   ),
  /// );
  /// ```
  /// @See [ValueListenableBuilder] for a better understanding.
  const KeyboardLayoutBuilder({
    super.key,
    required this.builder,
    this.allowOverlap = true,
    this.curve = Curves.easeOut,
    this.animationDuration = const Duration(milliseconds: 200),
    this.backgroundColor
  });

  ///Represents the child of this widget. This function will be called whenever the keyboard state
  ///changes.
  final Widget Function(BuildContext context, bool isKeyboardVisible) builder;

  ///The default value is [true], which corresponds to the default keyboard overlap. If [false]
  ///then the [builder] will be forced to fill the area not covered by the keyboard.
  final bool allowOverlap;

  /// Curve of the padding animation.
  final Curve curve;

  /// Duration of the padding animation when the keyboard appears or disappears.
  final Duration animationDuration;

  /// Color used to fill the space left by the keyboard when it disappears, as the padding that was
  /// pushing the UI up is not immediately removed.
  ///
  /// If [null] defaults to [Theme.of(context).scaffoldBackgroundColor].
  ///
  /// Use the same background color as your current view to prevent the KLB background color from
  /// flashing when the keyboard is closed.
  final Color? backgroundColor;

  @override
  State<KeyboardLayoutBuilder> createState() => _KeyboardLayoutBuilderState();
}

class _KeyboardLayoutBuilderState extends State<KeyboardLayoutBuilder> with WidgetsBindingObserver {
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    _checkKeyboardState();
    super.didChangeMetrics();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _checkKeyboardState() {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isVisible = bottomInset > 0;
    if (isVisible != _isKeyboardVisible) {
      setState(() => _isKeyboardVisible = isVisible);
      KeyboardController.isKeyboardVisible.value = isVisible;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return AnimatedContainer(
      color: widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      curve: widget.curve,
      duration: widget.animationDuration,
      padding: EdgeInsets.only(
        bottom: widget.allowOverlap ? 0.0 : bottomInset,
      ),
      child: widget.builder(context, _isKeyboardVisible),
    );
  }
}

///Manages the global state of the keyboard, providing a [ValueNotifier] to monitor its visibility.
class KeyboardController {

  ///Notify whether the keyboard is visible or not through the hierarchy.
  static final ValueNotifier<bool> isKeyboardVisible = ValueNotifier(false);
}