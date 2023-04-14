// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

part of '../ezplayer.dart';

mixin _DragLeftRightAreaMixin on _BaseMixin {
  bool dragLeft = false;
  bool dragRight = false;
  double dragLeftDelta = 0;
  double dragLeftStart = 0;
  double dragRightDelta = 0;
  double dragRightStart = 0;
  ChangeNotifier dragLeftStream = ChangeNotifier();
  ChangeNotifier dragLeftEndStream = ChangeNotifier();
  ChangeNotifier dragRightStream = ChangeNotifier();
  ChangeNotifier dragRightEndStream = ChangeNotifier();
  double rawVolume = 0;
  double newVolume = 0;
  double rawBrightness = 0;
  double newBrightness = 0;

  dragLeftUpdate() {
    dragLeftStream.notifyListeners();
  }

  dragLeftUpdateDelta() {
    dragLeftEndStream.notifyListeners();
  }

  dragRightUpdate() {
    dragRightStream.notifyListeners();
  }

  dragRightUpdateDelta() {
    dragRightEndStream.notifyListeners();
  }

  onVerticalDragStart(DragStartDetails detail) async {
    if (detail.localPosition.dx < MediaQuery.of(context).size.width * 0.5) {
      dragLeft = true;
      dragRight = false;
      dragLeftStart = detail.globalPosition.dy;
      try {
        rawBrightness = await ScreenBrightness().current;
      } catch (err) {
        // ignore: avoid_print
        print('ScreenBrightness get rawBrightness error: $err');
      }
      dragLeftUpdate();
    } else {
      dragLeft = false;
      dragRight = true;
      dragRightStart = detail.globalPosition.dy;
      try {
        rawVolume = await VolumeController().getVolume();
      } catch (err) {
        // ignore: avoid_print
        print('VolumeController getVolume error: $err');
      }
      dragRightUpdate();
    }
  }

  onVerticalDragUpdate(DragUpdateDetails detail) {
    if (dragLeft) {
      dragLeftDelta = dragLeftStart - detail.globalPosition.dy;
      newBrightness = dragLeftDelta / 150;
      newBrightness = newBrightness + rawBrightness;
      newBrightness = newBrightness >= 0 ? newBrightness : 0;
      newBrightness = newBrightness <= 1 ? newBrightness : 1;
      ScreenBrightness().setScreenBrightness(newBrightness);
      dragLeftUpdate();
    } else {
      dragRightDelta = dragRightStart - detail.globalPosition.dy;
      newVolume = dragRightDelta / 150;
      newVolume = newVolume + rawVolume;
      newVolume = newVolume >= 0 ? newVolume : 0;
      newVolume = newVolume <= 1 ? newVolume : 1;
      VolumeController().setVolume(newVolume, showSystemUI: false);
      dragRightUpdate();
    }
  }

  onVerticalDragEnd(DragEndDetails detail) {
    dragLeft = false;
    dragRight = false;
    dragLeftUpdateDelta();
    dragRightUpdateDelta();
  }

  onVerticalDragCancel() {
    if (dragLeft) {
      dragLeft = false;
      dragLeftStart = 0;
      dragLeftDelta = 0;
      dragLeftUpdate();
    } else {
      dragRight = false;
      dragRightStart = 0;
      dragRightDelta = 0;
      dragRightUpdate();
    }
  }

  initDragTB() async {
    dragLeftStream.addListener(() {
      setState(() {
        settingLight = dragLeft;
        lightPercent = newBrightness;
      });
    });

    dragLeftEndStream.addListener(() {
      setState(() {
        settingLight = dragLeft;
      });
    });

    dragRightStream.addListener(() async {
      setState(() {
        settingVolume = dragRight;
        volumePercent = newVolume;
      });
    });

    dragRightEndStream.addListener(() {
      setState(() {
        settingVolume = dragRight;
      });
    });

    try {
      // rawVolume = await VolumeController().getVolume();
      // rawBrightness = await ScreenBrightness().current;
    } catch (e) {
      // ignore: avoid_print
      print('initDragTB error: $e');
    }
  }
}
