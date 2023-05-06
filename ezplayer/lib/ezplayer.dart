// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

library ezplayer;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';
import 'package:extension_widget/extension_widget.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import './core/index.dart';
import './flutter_subtiltle_wrapper/index.dart';
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
part 'overlay/btns/speedup.dart';
part 'overlay/btns/video_boxfit.dart';
part 'overlay/btns/audio_track.dart';
part 'overlay/btns/subtitle_track.dart';
part 'overlay/btns/subtitle_external.dart';

part 'mixins/base.dart';
part 'mixins/overlay_timer.dart';
part 'mixins/drag_left_right_mixin.dart';
part 'mixins/drag_bottom_mixin.dart';
part 'mixins/longpress_mixin.dart';
part 'mixins/progress_mixin.dart';
part 'mixins/methods.dart';

enum ButtonPosition { left, right, bottomLeft, bottomRight }

class EzPlayer {
  static initialize() {
    FlutterBasePlayer.initialize();
  }

  bool showBackBtn = false;
  setShowBackBtn(bool visible) {
    showBackBtn = visible;
  }

  BuildContext? rootContext;
  List<OverlaySelectItem> menuBtns = [];
  List<EzplayerBtn> bottomLeftBtns = [];
  List<EzplayerBtn> bottomRightBtns = [];
  EzplayerBtn? leftBtn;
  EzplayerBtn? rightBtn;

  attachButton(EzplayerBtn btn, ButtonPosition position) {
    if (position == ButtonPosition.bottomLeft) {
      bottomLeftBtns.add(btn);
    }
    if (position == ButtonPosition.bottomRight) {
      bottomRightBtns.add(btn);
    }
    if (position == ButtonPosition.left) {
      leftBtn = btn;
    }
    if (position == ButtonPosition.right) {
      rightBtn = btn;
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
    aftterEnterFullscreen.dispose();
    aftterExitFullscreen.dispose();
    subtitleController?.detach();
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

  EzplayerSubtitleExternal? externalSubtitle;
  List<EzplayerSubtitleExternal> externalSubtitles = [];

  SubtitleController? subtitleController;
  EzplayerSubtitleStyle subtitleStyle = EzplayerSubtitleStyle();

  setSubtitle([String? content]) async {
    if (content == null) {
      subtitleController?.detach();
      subtitleController = null;
      externalSubtitle = null;
      return;
    }
    subtitleController = SubtitleController(
      subtitlesContent: content,
      subtitleDecoder: SubtitleDecoder.utf8,
      subtitleType: SubtitleType.srt,
    );
    subtitleController?.setTimeOffset(subtitleStyle.time);
  }

  bool fullscreen = false;

  ChangeNotifier aftterEnterFullscreen = ChangeNotifier();
  ChangeNotifier aftterExitFullscreen = ChangeNotifier();

  exitFullscreen(BuildContext context) {
    aftterExitFullscreen.notifyListeners();
    fullscreen = false;
    return Navigator.of(context).pop();
  }

  enterFullscreen(BuildContext context) {
    aftterEnterFullscreen.notifyListeners();
    fullscreen = true;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPlayer(
          this,
          bottomLeftBtns: bottomLeftBtns,
          bottomRightBtns: bottomRightBtns,
        ),
      ),
    );
  }

  Widget builder(
    BuildContext context, {
    BuildContext? rootContext,
    double? ratio,
    Color? color,
    bool isFullscreen = false,
    bool showControls = true,
  }) {
    fullscreen = isFullscreen;
    this.rootContext = rootContext;
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

            if (event.physicalKey == PhysicalKeyboardKey.escape && fullscreen) {
              exitFullscreen(context);
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
                        : box.maxWidth / (ratio ?? controller.aspectRatio),
                    width: isFullscreen
                        ? MediaQuery.of(context).size.width
                        : box.maxWidth,
                    backgroundColor: color ?? Colors.black,
                  )),
              notifier: controller.eventStream,
            ),
            if (showControls)
              ChangeNotifierBuilder(
                builder: (context) => SizedBox(
                  height: isFullscreen
                      ? MediaQuery.of(context).size.height
                      : box.maxWidth / (ratio ?? controller.aspectRatio),
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
            if (showControls)
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
