// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

part of '../ezplayer.dart';

mixin _DragBottomMixin on _BaseMixin, _ProgressMixin {
  bool dragBottom = false;
  double dragBottomDelta = 0;
  double dragBottomStart = 0;
  ChangeNotifier dragBottomStream = ChangeNotifier();
  ChangeNotifier dragBottomEndStream = ChangeNotifier();

  dragBottomUpdate() {
    dragBottomStream.notifyListeners();
  }

  dragBottomUpdateDelta() {
    dragBottomEndStream.notifyListeners();
  }

  onHorizontalDragStart(DragStartDetails detail) {
    dragBottom = true;
    dragBottomStart = detail.globalPosition.dx;
    dragBottomUpdate();
  }

  onHorizontalDragUpdate(DragUpdateDetails detail) {
    dragBottomDelta = detail.globalPosition.dx - dragBottomStart;
    dragBottomUpdate();
  }

  onHorizontalDragEnd(DragEndDetails detail) {
    dragBottom = false;
    dragBottomUpdateDelta();
  }

  onHorizontalDragCancel() {
    dragBottom = false;
    dragBottomStart = 0;
    dragBottomDelta = 0;
    dragBottomUpdate();
  }

  initDragBottom() {
    dragBottomStream.addListener(() {
      setState(() {
        seeking = dragBottom;
        int newSeconds = positionSeconds + dragBottomDelta.toInt();
        newSeconds = newSeconds >= 0 ? newSeconds : 0;
        newSeconds = newSeconds <= totalSeconds ? newSeconds : totalSeconds;
        newPositionTime = formatDuration(Duration(seconds: newSeconds));
      });
    });

    dragBottomEndStream.addListener(() {
      setState(() {
        seeking = dragBottom;
      });
      int newSeconds = positionSeconds + dragBottomDelta.toInt();
      newSeconds = newSeconds >= 0 ? newSeconds : 0;
      newSeconds = newSeconds <= totalSeconds ? newSeconds : totalSeconds;
      widget.controller.seek(Duration(seconds: newSeconds));
    });
  }
}
