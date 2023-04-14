part of '../ezplayer.dart';

mixin _ProgressMixin on _BaseMixin {
  late SyyVideoProgressBarController pCtrl;

  double get positionPercent =>
      totalSeconds == 0 ? 0 : positionSeconds / totalSeconds;

  String get totalTime => formatDuration(Duration(seconds: totalSeconds));
  String get positionTime => formatDuration(Duration(seconds: positionSeconds));

  String newPositionTime = '';

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitHours = twoDigits(duration.inHours);
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }

  initProgress() {
    pCtrl = SyyVideoProgressBarController(
      bufferedPercent: 0,
      positionPercent: 0,
    );

    pCtrl.track.addListener(() {
      int seconds = (pCtrl.newPosition * totalSeconds).toInt();
      widget.controller.seek(Duration(seconds: seconds));
      setState(() {
        seeking = false;
      });
    });

    pCtrl.tracking.addListener(() {
      int seconds = (pCtrl.newTrackingPosition * totalSeconds).toInt();
      setState(() {
        seeking = true;
        newPositionTime = formatDuration(Duration(seconds: seconds));
      });
    });
  }

  syncPercent() {
    pCtrl.updateBuffered(bufferedPercent);
    pCtrl.updatePosition(positionPercent);
  }
}
