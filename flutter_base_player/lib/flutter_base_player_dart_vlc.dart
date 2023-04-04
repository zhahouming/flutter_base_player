import 'dart:async';
import 'dart:io';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_base_player_platform_interface/flutter_base_player_platform_interface.dart';
import 'package:dart_vlc/dart_vlc.dart';

class FlutterBasePlayerDartVlcPlayer extends FlutterBasePlayerPlatform {
  static void registerWith() {
    FlutterBasePlayerPlatform.instance = FlutterBasePlayerDartVlcPlayer();
  }

  late Player _controller;

  @override
  // TODO: implement aspectRatio
  double get aspectRatio => throw UnimplementedError();

  @override
  // TODO: implement buffered
  double get buffered => throw UnimplementedError();

  @override
  // TODO: implement duration
  Duration get duration => throw UnimplementedError();

  @override
  // TODO: implement errorMessage
  String get errorMessage => throw UnimplementedError();

  @override
  // TODO: implement hasError
  bool get hasError => throw UnimplementedError();

  @override
  // TODO: implement isBuffering
  bool get isBuffering => throw UnimplementedError();

  @override
  // TODO: implement isFullScreen
  bool get isFullScreen => throw UnimplementedError();

  @override
  // TODO: implement isInitialized
  bool get isInitialized => throw UnimplementedError();

  @override
  // TODO: implement isLooping
  bool get isLooping => throw UnimplementedError();

  @override
  // TODO: implement isPlaying
  bool get isPlaying => throw UnimplementedError();

  @override
  // TODO: implement playbackSpeed
  double get playbackSpeed => throw UnimplementedError();

  @override
  // TODO: implement position
  Duration get position => throw UnimplementedError();

  @override
  // TODO: implement size
  double get size => throw UnimplementedError();

  @override
  // TODO: implement volume
  double get volume => throw UnimplementedError();

  @override
  FlutterBasePlayerPlatform assets() {
    // TODO: implement assets
    throw UnimplementedError();
  }

  @override
  void exitFullScreen() {
    // TODO: implement exitFullScreen
  }

  @override
  FlutterBasePlayerPlatform file() {
    // TODO: implement file
    throw UnimplementedError();
  }

  @override
  Future<void> init(String url) {
    _controller = Player(id: 0);
    _controller.open(
      Media.network(url),
      autoStart: true, // default
    );
    return Future.value();
  }

  @override
  FlutterBasePlayerPlatform network() {
    // TODO: implement network
    throw UnimplementedError();
  }
  @override
  void initialize() {
    if (Platform.isWindows || Platform.isLinux) {
      DartVLC.initialize();
    }
  }

  @override
  void pause() {
    // TODO: implement pause
  }

  @override
  void play() {
    _controller.play();
  }

  @override
  void requestFullScreen() {
    // TODO: implement requestFullScreen
  }

  @override
  void seek() {
    // TODO: implement seek
  }

  @override
  void setLooping() {
    // TODO: implement setLooping
  }

  @override
  void setPlaybackSpeed() {
    // TODO: implement setPlaybackSpeed
  }

  @override
  void setVolume() {
    // TODO: implement setVolume
  }

  @override
  Widget builder(BuildContext context) {
    return Video(
      player: _controller,
      // width: 640,
      // height: 360,
      showControls: true,
    );
  }
}
