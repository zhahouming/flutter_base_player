part of '../extension_widget.dart';

class EzInk extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;
  final Function()? onLongPressed;
  final Function()? onDoubleTap;
  final void Function(TapDownDetails)? onTapDown;
  final void Function(TapUpDetails)? onTapUp;
  final void Function()? onTapCancel;
  final void Function()? onSecondaryTap;
  final void Function(TapUpDetails)? onSecondaryTapUp;
  final void Function(TapDownDetails)? onSecondaryTapDown;
  final void Function()? onSecondaryTapCancel;
  final void Function(bool)? onHighlightChanged;
  final void Function(bool)? onHover;
  final double radius;

  const EzInk({
    Key? key,
    required this.child,
    this.onPressed,
    this.onLongPressed,
    this.onDoubleTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onSecondaryTap,
    this.onSecondaryTapUp,
    this.onSecondaryTapDown,
    this.onSecondaryTapCancel,
    this.onHighlightChanged,
    this.onHover,
    this.radius = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        highlightColor: Colors.transparent,
        onTap: onPressed,
        onLongPress: onLongPressed,
        onDoubleTap: onDoubleTap,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: child,
      ),
    );
  }
}
