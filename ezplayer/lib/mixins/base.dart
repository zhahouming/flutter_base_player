part of '../ezplayer.dart';

mixin _BaseMixin on State<PlayerOverlay> {
  bool get isPlaying => widget.controller.isPlaying;
  bool seeking = false;
  bool settingLight = false;
  bool settingVolume = false;
  double lightPercent = 0;
  double volumePercent = 0;
  Duration? currentPosition;

  Duration get playedTime => widget.controller.position;
  int get totalSeconds => widget.controller.duration.inSeconds;
  int get positionSeconds => widget.controller.position.inSeconds;
  double get bufferedPercent => widget.controller.buffered;
}
