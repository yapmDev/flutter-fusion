/*
  author: yapmDev
  lastModifiedDate: 13/02/25
  repository: https://github.com/yapmDev/flutter_fusion
 */

import 'package:flutter/material.dart';

///Allows you to customize the views that interact with the keyboard based on its state
///(active or hidden).
class KeyboardLayoutBuilder extends StatefulWidget {

  /// Creates a KeyboardLayoutBuilder with the given [builder].
  ///
  /// @Warning
  ///
  /// If [keyboardOverlapping] is
  /// [false] and spacing is not handled properly it can cause an [OverflowError]. To avoid that :
  ///
  /// @See [SingleChildScrollView].
  const KeyboardLayoutBuilder({
    super.key,
    required this.builder,
    this.keyboardOverlapping = true
  });

  ///Represents the child of this widget. This function will be called whenever the keyboard state
  ///changes.
  final Widget Function(BuildContext context, bool isKeyboardVisible) builder;

  ///The default value is [true], which corresponds to the default keyboard overlap. If [false]
  ///then the [builder] will be forced to fill the area not covered by the keyboard.
  final bool keyboardOverlapping;

  @override
  State<KeyboardLayoutBuilder> createState() => _KeyboardLayoutBuilderState();
}

class _KeyboardLayoutBuilderState extends State<KeyboardLayoutBuilder> with WidgetsBindingObserver {
  bool _isKeyboardVisible = false;
  double _maxKeyboardHeight = 0.0;

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
    if(isVisible && bottomInset > _maxKeyboardHeight) _maxKeyboardHeight = bottomInset;
    if (isVisible != _isKeyboardVisible) setState(() => _isKeyboardVisible = isVisible);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: widget.keyboardOverlapping ? 0.0 :
          _isKeyboardVisible ? _maxKeyboardHeight : 0.0
      ),
      child: widget.builder(context, _isKeyboardVisible),
    );
  }
}