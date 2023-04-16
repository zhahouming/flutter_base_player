part of '../ezplayer.dart';

class SpeedUpOverlay extends StatelessWidget {
  final double speed;
  const SpeedUpOverlay({
    Key? key,
    required this.speed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color defaultColor = Colors.grey.withOpacity(0.1);
    Color activeColor = Colors.grey.withOpacity(0.5);
    return Wrap(
      direction: Axis.horizontal,
      children: [
        const Text(
          '2倍速',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ).div(DivStyle(
          alignment: Alignment.center,
          height: 40,
          backgroundColor: speed == 2 ? activeColor : defaultColor,
        )),
        const Text(
          '3倍速',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ).div(DivStyle(
          alignment: Alignment.center,
          height: 40,
          backgroundColor: speed == 3 ? activeColor : defaultColor,
        )),
        const Text(
          '4倍速',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ).div(DivStyle(
          alignment: Alignment.center,
          height: 40,
          backgroundColor: speed == 4 ? activeColor : defaultColor,
        )),
        const Text(
          '5倍速',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ).div(DivStyle(
          alignment: Alignment.center,
          height: 40,
          backgroundColor: speed == 5 ? activeColor : defaultColor,
        )),
      ],
    )
        .clipRRect(all: 20)
        .div(DivStyle(
          width: 100,
        ))
        .div(DivStyle(
          alignment: Alignment.center,
        ));
  }
}
