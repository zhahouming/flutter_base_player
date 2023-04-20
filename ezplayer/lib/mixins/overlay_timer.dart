part of '../ezplayer.dart';

mixin _OverlayTimerMixin on _BaseMixin {
  bool hidebar = false;
  Timer? timer;

  togglePlay() {
    if (isPlaying) {
      widget.controller.pause();
      timer?.cancel();
    } else {
      widget.controller.play();
      autoHide();
    }
  }

  toggleBar() {
    if (hidebar) return showBar();
    hideBar();
  }

  onDoubleTap() {
    if (widget.ezplayer.fullscreen) {
      widget.ezplayer.exitFullscreen(context);
    } else {
      widget.ezplayer.enterFullscreen(context);
    }
  }

  showBar() {
    setState(() {
      hidebar = false;
    });
    autoHide();
  }

  hideBar() {
    setState(() {
      hidebar = true;
    });
  }

  autoHide() {
    timer?.cancel();
    timer = Timer(const Duration(seconds: 5), () async {
      if (!isPlaying) return;
      if (!hidebar) {
        if (mounted) hideBar();
      }
    });
  }

  initTimer() {
    timer = Timer(const Duration(seconds: 5), () async {
      if (!hidebar) {
        if (mounted) hideBar();
      }
    });
  }
}
