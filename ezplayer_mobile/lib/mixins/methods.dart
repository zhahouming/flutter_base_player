part of '../ezplayer.dart';

enum SyyVideoState {
  loading,
  loaded,
  error,
  playing,
  pause,
  prestop,
  stop,
}

mixin _MethodsMixin
    on
        _BaseMixin,
        _OverlayTimerMixin,
        _LongPressMixin,
        _ProgressMixin,
        _DragBottomMixin,
        _DragLeftRightAreaMixin {
  bool subtitleInited = false;

  final ChangeNotifier destoryOldCtrl = ChangeNotifier();
  final ChangeNotifier syncNewCtrl = ChangeNotifier();
  final ChangeNotifier onStateChange = ChangeNotifier();

  disposeMethods() {
    syncNewCtrl.dispose();
    destoryOldCtrl.dispose();
    onStateChange.dispose();
    super.dispose();
  }
}
