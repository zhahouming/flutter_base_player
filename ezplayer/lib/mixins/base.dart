part of '../ezplayer.dart';

mixin _BaseMixin on State<PlayerOverlay> {
  bool isPlaying = false;
  bool seeking = false;
  bool settingLight = false;
  bool settingVolume = false;
  double lightPercent = 0;
  double volumePercent = 0;
  Duration? currentPosition;

  Duration playedTime = const Duration(seconds: 0);
  int totalSeconds = 0;
  int positionSeconds = 0;
  double bufferedPercent = 0;

  syncDurationState() {
    setState(() {
      isPlaying = widget.controller.isPlaying;
      playedTime = widget.controller.position;
      totalSeconds = widget.controller.duration.inSeconds;
      positionSeconds = widget.controller.position.inSeconds;
      try {
        bufferedPercent = widget.controller.buffered;
      } catch (err) {
        // ignore: avoid_print
        print('bufferedPercent error: $err');
      }
    });
  }
}
