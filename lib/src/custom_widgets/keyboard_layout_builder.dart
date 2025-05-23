/*
  author: yapmDev
  lastModifiedDate: 23/05/25
  repository: https://github.com/yapmDev/flutter_fusion
 */

import 'package:flutter/material.dart';

/// A layout builder for views which interact with keyboard.
class KeyboardLayoutBuilder extends StatefulWidget {

  /// Creates custom and reactive views based on the keyboard state (active or hidden). Leaving
  /// important content visible at your choice when the keyboard is being displayed.
  ///
  /// @Warnings
  ///
  /// - If you are using a [Scaffold] set `resizeToAvoidBottomInset` to `false`. This solution is a
  /// better way to handle that.
  ///
  /// - If [allowOverlap] is [false] and spacing is not handled properly it can cause an
  /// `OverflowError`. In that case you probably also need a scrollable widget.
  const KeyboardLayoutBuilder({
    super.key,
    required this.builder,
    this.allowOverlap = true,
    this.curve = Curves.easeOut,
    this.animationDuration = const Duration(milliseconds: 200),
    this.backgroundColor
  });

  /// Represents the child of this widget. This function will be called whenever the keyboard state
  /// changes.
  final Widget Function(BuildContext context, bool isKeyboardVisible) builder;

  /// The default value is [true], which corresponds to the default keyboard overlap. If [false]
  /// then the [builder] will be forced to fill the area not covered by the keyboard.
  final bool allowOverlap;

  /// Useful only if [allowOverlap] is `false`.
  ///
  /// Curve of the padding animation.
  final Curve curve;

  /// Useful only if [allowOverlap] is `false`.
  ///
  /// Duration of the padding animation when the keyboard appears or disappears.
  final Duration animationDuration;

  /// Useful only if [allowOverlap] is `false`.
  ///
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
  double _bottomInset = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkKeyboardState());
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
      setState(() {
        _isKeyboardVisible = isVisible;
        _bottomInset = bottomInset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: EdgeInsets.only(bottom: _isKeyboardVisible ? _bottomInset : 0.0),
      curve: widget.curve,
      duration: widget.animationDuration,
      color: widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: widget.builder(context, _isKeyboardVisible),
    );
  }
}