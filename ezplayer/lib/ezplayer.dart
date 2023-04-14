library ezplayer;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_base_player/flutter_base_player.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:volume_controller/volume_controller.dart';
import 'fullscreen.dart';

part 'overlay/index.dart';
part 'overlay/progress_bar.dart';
part 'overlay/bottombar.dart';
part 'overlay/external.dart';
part 'overlay/float_toolbar.dart';
part 'overlay/seeking_overlay.dart';
part 'overlay/speedup_overlay.dart';
part 'overlay/topbar.dart';

part 'mixins/base.dart';
part 'mixins/overlay_timer.dart';
part 'mixins/drag_left_right_mixin.dart';
part 'mixins/drag_bottom_mixin.dart';
part 'mixins/longpress_mixin.dart';
part 'mixins/progress_mixin.dart';

class EzPlayer {
  FlutterBasePlayer controller = FlutterBasePlayer();

  dispose() {
    controller.dispose();
  }

  Widget builder(
    BuildContext context, {
    BoxFit? fit,
    double? ratio,
    Color? color,
  }) {
    return Stack(
      children: [
        controller.builder(context, fit: fit, ratio: ratio, color: color),
        PlayerOverlay(controller: controller)
      ],
    );
  }
}
