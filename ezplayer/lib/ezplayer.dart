// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

library ezplayer;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';
import 'package:extension_widget/extension_widget.dart';
import 'package:flutter_base_player/flutter_base_player.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:date_format/date_format.dart';

import 'fullscreen.dart';

part 'utils.dart';
part 'overlay/index.dart';
part 'overlay/progress_bar.dart';
part 'overlay/external.dart';
part 'overlay/float_toolbar.dart';
part 'overlay/seeking_overlay.dart';
part 'overlay/speedup_overlay.dart';
part 'overlay/topbar.dart';
part 'overlay/custom_tab_indicator.dart';
part 'overlay/vslider.dart';
part 'overlay/bottombar.dart';
part 'overlay/btns/ezplayer_btn.dart';
part 'overlay/btns/speedup.dart';
part 'overlay/btns/video_boxfit.dart';
part 'overlay/btns/audio_track.dart';
part 'overlay/btns/subtitle_track.dart';

part 'mixins/base.dart';
part 'mixins/overlay_timer.dart';
part 'mixins/drag_left_right_mixin.dart';
part 'mixins/drag_bottom_mixin.dart';
part 'mixins/longpress_mixin.dart';
part 'mixins/progress_mixin.dart';
part 'mixins/methods.dart';

enum ButtonPosition { left, right }

class EzPlayer {
  List<OverlaySelectItem> menuBtns = [];
  List<EzplayerTextBtn> bottomLeftBtns = [];
  List<EzplayerTextBtn> bottomRightBtns = [];

  attachButton(EzplayerTextBtn btn, ButtonPosition position) {
    if (position == ButtonPosition.left) {
      bottomLeftBtns.add(btn);
    }
    if (position == ButtonPosition.right) {
      bottomRightBtns.add(btn);
    }
  }

  attachMenu(OverlaySelectItem btn) {
    menuBtns.add(btn);
  }

  FlutterBasePlayer controller = FlutterBasePlayer();
  String? videoName;

  bool isShowOverlay = false;
  Widget Function(BuildContext context)? overlayBuilder;
  Alignment overlayAlignment = Alignment.center;

  BoxFit cutStyle = BoxFit.contain;

  setCutStyle(BoxFit fit) {
    cutStyle = fit;
    controller.eventStream.notifyListeners();
  }

  dispose() {
    controller.dispose();
  }

  setVideoName(String name) {
    videoName = name;
  }

  showOverlay({
    required Widget Function(BuildContext context) builder,
    Alignment alignment = Alignment.center,
  }) {
    isShowOverlay = true;
    overlayBuilder = builder;
    overlayAlignment = alignment;
    controller.eventStream.notifyListeners();
  }

  hideOverlay() {
    isShowOverlay = false;
    overlayBuilder = null;
    controller.eventStream.notifyListeners();
  }

  EzplayerBtn ezplayerBtn(String btnText, List<OverlaySelectItem> options,
      [String? title]) {
    return EzplayerBtn(
      ezplayer: this,
      btnText: btnText,
      options: options,
      title: title,
    );
  }

  Widget builder(
    BuildContext context, {
    double? ratio,
    Color? color,
    bool isFullscreen = false,
  }) {
    return LayoutBuilder(builder: (context, box) {
      return RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (RawKeyEvent event) {
          if (event.runtimeType == RawKeyDownEvent) {
            if (event.physicalKey == PhysicalKeyboardKey.space) {
              if (controller.isPlaying) {
                controller.pause();
              } else {
                controller.play();
              }
            }

            if (event.physicalKey == PhysicalKeyboardKey.arrowRight) {
              controller
                  .seek(Duration(seconds: controller.position.inSeconds + 10));
            }

            if (event.physicalKey == PhysicalKeyboardKey.arrowLeft) {
              controller
                  .seek(Duration(seconds: controller.position.inSeconds - 10));
            }
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            ChangeNotifierBuilder(
              builder: (context) => controller
                  .builder(context, fit: cutStyle, ratio: ratio, color: color)
                  .div(DivStyle(
                    height: isFullscreen
                        ? MediaQuery.of(context).size.height
                        : box.maxWidth / controller.aspectRatio,
                    width: isFullscreen
                        ? MediaQuery.of(context).size.width
                        : box.maxWidth,
                    backgroundColor: color ?? Colors.black,
                  )),
              notifier: controller.eventStream,
            ),
            ChangeNotifierBuilder(
              builder: (context) => SizedBox(
                height: isFullscreen
                    ? MediaQuery.of(context).size.height
                    : box.maxWidth / controller.aspectRatio,
                width: isFullscreen
                    ? MediaQuery.of(context).size.width
                    : box.maxWidth,
                child: PlayerOverlay(
                  controller: controller,
                  ezplayer: this,
                  isFullscreen: isFullscreen,
                ),
              ),
              notifier: controller.eventStream,
            ),
            ChangeNotifierBuilder(
              builder: (context) => AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                right: 0,
                top: 0,
                bottom: 0,
                left: isShowOverlay ? 0 : MediaQuery.of(context).size.width,
                child: Div(
                  style: DivStyle(
                    width: MediaQuery.of(context).size.width,
                    // backgroundColor: Colors.black12
                  ),
                  child: overlayBuilder == null
                      ? const Div()
                      : overlayBuilder!(context).alignment(overlayAlignment),
                ).gestures(onTap: hideOverlay),
              ),
              notifier: controller.eventStream,
            ),
          ],
        ),
      );
    });
  }
}
