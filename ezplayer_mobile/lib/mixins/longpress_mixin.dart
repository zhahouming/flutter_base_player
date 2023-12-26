part of '../ezplayer.dart';

mixin _LongPressMixin on _BaseMixin {
  bool iSpeedUpMode = false;
  double speed = 2; // 2, 3, 4, 5

  onLongPressStart(LongPressStartDetails detail) {
    setState(() {
      iSpeedUpMode = true;
    });
    // Vibration.vibrate(duration: 40, amplitude: 108);
  }

  onLongPressMoveUpdate(
      LongPressMoveUpdateDetails detail, BuildContext context) {
    double dy = detail.localPosition.dy;
    double centerY = (context.size?.height ?? 0) / 2;
    double deltaY = dy - centerY;
    if (deltaY < -40) {
      setState(() {
        speed = 2;
      });
    }
    if (deltaY < 0 && deltaY >= -40) {
      setState(() {
        speed = 3;
      });
    }
    if (deltaY < 40 && deltaY >= 0) {
      setState(() {
        speed = 4;
      });
    }
    if (deltaY >= 40) {
      setState(() {
        speed = 5;
      });
    }
    widget.controller.setPlaybackSpeed(speed);
  }

  onLongPressEnd(LongPressEndDetails detail) {
    widget.controller.setPlaybackSpeed(1);
    setState(() {
      iSpeedUpMode = false;
    });
    // Vibration.vibrate(duration: 20, amplitude: 20);
  }
}
