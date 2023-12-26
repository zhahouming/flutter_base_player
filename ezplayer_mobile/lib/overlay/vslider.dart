part of '../ezplayer.dart';

class VSlider extends StatelessWidget {
  final double percent;
  final IconData iconData;
  const VSlider({
    Key? key,
    required this.percent,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Div(
          style: DivStyle(
            height: percent * 100,
            backgroundColor: Colors.white60,
          ),
        )
            .alignment(Alignment.bottomCenter)
            .div(DivStyle(
              height: 100,
              width: 30,
              backgroundColor: Colors.grey.withOpacity(0.5),
            ))
            .clipRRect(all: 3),
        Icon(
          iconData,
          color: Colors.white70,
          size: 16,
        ).positioned(
          top: 8,
          left: 0,
          right: 0,
        ),
      ],
    ).div(DivStyle(alignment: Alignment.center));
  }
}
