import 'package:flutter/material.dart';

/// A customizable widget that displays a horizontal stack of circular elements,
/// where each circle can overlap the previous or next based on the overlay direction.
///
/// The content inside each circle is provided by a builder function. This allows for
/// full flexibility in what each circular item displays (e.g., images, avatars, icons, etc.).
///
/// The widget supports left-to-right and right-to-left overlaying, controlling which
/// item visually appears on top.
///
/// Example usage:
/// ```dart
/// CircleStack(
///   count: 4,
///   radius: 20,
///   offset: 8,
///   overlayDirection: OverlayDirection.rightToLeft,
///   prototypeBuilder: (index) => Image.asset('assets/avatar_$index.png'),
/// )
/// ```
class CircleStack extends StatelessWidget {

  /// Total number of circular items to render.
  final int count;

  /// Radius of each circle. The final size per circle is `radius * 2`.
  final double radius;

  /// The amount of visible spacing between the centers of consecutive circles.
  /// A higher offset means more overlap.
  final double offset;

  /// A builder function that returns the widget to display inside each circular item.
  /// The widget is automatically clipped to a circular shape.
  final Widget Function(int index) prototypeBuilder;

  /// Defines the direction of the overlay. When [OverlayDirection.rightToLeft],
  /// the first circle appears on top of the subsequent ones.
  /// When [OverlayDirection.leftToRight], the last circle appears on top.
  final OverlayDirection overlayDirection;

  /// Creates a new [CircleStack] widget.
  ///
  /// The [count], [radius], [offset], and [prototypeBuilder] parameters are required.
  /// The [overlayDirection] defaults to [OverlayDirection.rightToLeft].
  const CircleStack({
    super.key,
    required this.count,
    required this.radius,
    required this.offset,
    required this.prototypeBuilder,
    this.overlayDirection = OverlayDirection.rightToLeft,
  });

  @override
  Widget build(BuildContext context) {
    final double diameter = radius * 2;
    final double totalWidth = diameter + (count - 1) * (diameter - offset);
    final isHorizontalDirection = overlayDirection == OverlayDirection.rightToLeft
        || overlayDirection == OverlayDirection.leftToRight;
    return SizedBox(
        width: isHorizontalDirection ? totalWidth : diameter,
        height: isHorizontalDirection ? diameter : totalWidth,
        child: Stack(
            children: List.generate(count, (index) {
              final double position = index * (diameter - offset);
              return Positioned(
                  top: overlayDirection == OverlayDirection.topToBottom ? position : null,
                  bottom: overlayDirection == OverlayDirection.bottomToTop ? position : null,
                  left: overlayDirection == OverlayDirection.leftToRight ? position : null,
                  right: overlayDirection == OverlayDirection.rightToLeft ? position : null,
                  child: ClipOval(
                      child: SizedBox(
                          width: diameter,
                          height: diameter,
                          child: prototypeBuilder(index)
                      )
                  )
              );
            })
        )
    );
  }
}

/// Defines the visual stacking order of circular items in a [CircleStack].
enum OverlayDirection {
  /// Items overlay from left to right. The last item appears on top.
  leftToRight,

  /// Items overlay from right to left. The first item appears on top.
  rightToLeft,

  /// Items overlay from top to bottom. The last item appears on top.
  topToBottom,

  /// Items overlay from bottom to top. The last item appears on top.
  bottomToTop
}