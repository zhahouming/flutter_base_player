import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// Universal video player for flutter
/// Support platform: Android, iOS, MacOS, Windows, Linux and Web
/// We use video_player for Android and iOS, video_player_macos for MacOS, dart_vlc for Windows and Linux
/// Support source: assets, file, network
/// Methods: init, play, pause, seek, setVolume, setPlaybackSpeed, setLooping, requestFullScreen, exitFullScreen
/// Value: aspectRatio, buffered, duration, hasError, errorMessage, playbackSpeed, position, size, volume
/// isBuffering, isInitialized, isLooping, isPlaying, isFullScreen
/// Factory function: assets, file, url
/// Init parameters: initialDuration
abstract class FlutterBasePlayerPlatform extends PlatformInterface {
  FlutterBasePlayerPlatform() : super(token: _token);

  static final Object _token = Object();

  static late FlutterBasePlayerPlatform _instance;

  static FlutterBasePlayerPlatform get instance => _instance;

  static set instance(FlutterBasePlayerPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  FlutterBasePlayerPlatform assets();
  FlutterBasePlayerPlatform file();
  FlutterBasePlayerPlatform network();

  Future<void> init(String url);
  void play();
  void pause();
  void seek();
  void setVolume();
  void setPlaybackSpeed();
  void setLooping();
  void requestFullScreen();
  void exitFullScreen();

  double get aspectRatio;
  double get buffered;
  Duration get duration;
  bool get hasError;
  String get errorMessage;
  double get playbackSpeed;
  Duration get position;
  double get size;
  double get volume;
  bool get isBuffering;
  bool get isInitialized;
  bool get isLooping;
  bool get isPlaying;
  bool get isFullScreen;
  Widget builder(BuildContext context);
}
