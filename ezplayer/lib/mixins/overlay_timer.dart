part of '../ezplayer.dart';

mixin _OverlayTimerMixin on _BaseMixin {
  bool hidebar = false;
  Timer? timer;

  togglePlay() {
    if (isPlaying) {
      widget.controller.pause();
      cancelTimer();
    } else {
      widget.controller.play();
      autoHide();
    }
  }

  toggleBar() {
    if (hidebar) return showBar();
    hideBar();
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
    cancelTimer();
    timer = Timer(const Duration(seconds: 3), () async {
      if (!hidebar) {
        hideBar();
      }
    });
  }

  cancelTimer() {
    if (timer != null) {
      timer!.cancel();
    }
  }

  initTimer() {
    timer = Timer(const Duration(seconds: 5), () async {
      if (!hidebar) {
        hideBar();
      }
    });
  }
}
