import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:device_orientation/device_orientation.dart';

import 'ezplayer.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  final EzPlayer player;
  final List<Widget> bottomLeftBtns;
  final List<Widget> bottomRightBtns;

  const FullScreenVideoPlayer(
    this.player, {
    Key? key,
    List<Widget>? bottomLeftBtns,
    List<Widget>? bottomRightBtns,
  })  : bottomLeftBtns = bottomLeftBtns ?? const [],
        bottomRightBtns = bottomRightBtns ?? const [],
        super(key: key);

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    // deviceOrientation$.listen((orientation) {
    //   // if (!mounted) return;
    //   debug(['orientation', orientation]);
    //   if (orientation == DeviceOrientation.landscapeLeft) {
    //     SystemChrome.setPreferredOrientations([
    //       DeviceOrientation.landscapeRight,
    //     ]);
    //   } else if (orientation == DeviceOrientation.landscapeRight) {
    //     SystemChrome.setPreferredOrientations([
    //       DeviceOrientation.landscapeLeft,
    //     ]);
    //   }
    // });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.player.builder(context, isFullscreen: true),
    );
  }
}
