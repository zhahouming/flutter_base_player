import 'package:flutter/widgets.dart';

import 'package:flutter_base_player_platform_interface/flutter_base_player_platform_interface.dart';

export './flutter_base_player_video_player.dart';
export './flutter_base_player_dart_vlc.dart';
// export 'src/device_info_plus_linux.dart';
// export 'src/device_info_plus_windows.dart';

class FlutterBasePlayer {
  FlutterBasePlayer();

  static FlutterBasePlayerPlatform get _platform {
    return FlutterBasePlayerPlatform.instance;
  }

  static initialize() {
    FlutterBasePlayerPlatform.instance.initialize();
  }

  setUrl(String url) {
    return _platform.init(url);
  }

  play() {
    _platform.play();
  }

  Widget builder(BuildContext context) {
    return _platform.builder(context);
  }
}
