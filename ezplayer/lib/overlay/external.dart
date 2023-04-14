part of '../ezplayer.dart';

class SyyVideoTextBtn extends StatelessWidget {
  final String text;
  final Color color;
  final void Function() onPressed;
  const SyyVideoTextBtn({
    Key? key,
    required this.text,
    required this.onPressed,
    color,
  })  : color = color ?? Colors.white,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(color: color, fontSize: 12))
        .div(SyyBoxStyle(alignment: Alignment.center, height: 40, width: 40))
        .ink(onPressed, radius: 40);
  }
}

class SyyVideoIconBtn extends StatelessWidget {
  final IconData iconData;
  final Color color;
  final void Function() onPressed;

  const SyyVideoIconBtn({
    Key? key,
    required this.iconData,
    required this.onPressed,
    color,
  })  : color = color ?? Colors.white,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(iconData, color: color)
        .div(SyyBoxStyle(alignment: Alignment.center, height: 40, width: 40))
        .ink(onPressed, radius: 40);
  }
}
