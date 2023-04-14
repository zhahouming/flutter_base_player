part of '../ezplayer.dart';

class PlayerOverlay extends StatefulWidget {
  final FlutterBasePlayer controller;
  const PlayerOverlay({Key? key, required this.controller}) : super(key: key);

  @override
  State<PlayerOverlay> createState() => _PlayerOverlayState();
}

class _PlayerOverlayState extends State<PlayerOverlay>
    with
        _BaseMixin,
        _OverlayTimerMixin,
        _LongPressMixin,
        _ProgressMixin,
        _DragBottomMixin,
        _DragLeftRightAreaMixin {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
