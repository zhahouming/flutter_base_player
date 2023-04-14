part of '../extension_widget.dart';

class Ink extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;
  final Function()? onLongPressed;
  final Function()? onDoubleTap;
  final double radius;

  const Ink({
    Key? key,
    required this.child,
    this.onPressed,
    this.onLongPressed,
    this.onDoubleTap,
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
