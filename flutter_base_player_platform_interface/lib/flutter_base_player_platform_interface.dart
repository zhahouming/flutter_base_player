import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// Universal video player for flutter
/// Support platform: Android, iOS, MacOS, Windows, Linux and Web
/// We use video_player for Android and iOS, video_player_macos for MacOS, dart_vlc for Windows and Linux
/// Support source: assets, file, network
/// Methods: init, play, pause, seek, setVolume, setPlaybackSpeed, setLooping
/// Value: aspectRatio, buffered, duration, hasError, errorMessage, playbackSpeed, position, size, volume
/// isBuffering, isInitialized, isLooping, isPlaying
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

  Future<void> assets(String path);
  Future<void> file(File file);
  Future<void> network(String url);

  void play();
  void initialize();
  void pause();
  void seek(Duration position);
  void setVolume(double volume);
  void setPlaybackSpeed(double speed);
  void setLooping(bool looping);

  double get aspectRatio;
  double get buffered;
  Duration get duration;
  bool get hasError;
  String? get errorMessage;
  double get playbackSpeed;
  Duration get position;
  Size get size;
  double get volume;
  bool get isBuffering;
  bool get isInitialized;
  bool get isLooping;
  bool get isPlaying;
  Widget builder(BuildContext context, [double? height, double? width]);
}
