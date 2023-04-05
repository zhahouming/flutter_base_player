import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_base_player_platform_interface/flutter_base_player_platform_interface.dart';

export './change_notifier_builder.dart';
export './flutter_base_player_video_player.dart';
export './flutter_base_player_dart_vlc.dart';

class FlutterBasePlayer {
  FlutterBasePlayer();

  static FlutterBasePlayerPlatform get _platform {
    return FlutterBasePlayerPlatform.instance;
  }

  static initialize() {
    FlutterBasePlayerPlatform.instance.initialize();
  }

  Future<void> loadAssets(String path) {
    return _platform.assets(path);
  }

  Future<void> loadFile(File file) {
    return _platform.file(file);
  }

  Future<void> loadNetwork(String url) {
    return _platform.network(url);
  }

  play() {
    _platform.play();
  }

  pause() {
    _platform.pause();
  }

  void seek(Duration position) {
    _platform.seek(position);
  }

  void setLooping(bool looping) {
    _platform.setLooping(looping);
  }

  void setPlaybackSpeed(double speed) {
    _platform.setPlaybackSpeed(speed);
  }

  void setVolume(double volume) {
    _platform.setVolume(volume);
  }

  Widget builder(BuildContext context, {BoxFit? fit, double? ratio}) {
    return _platform.builder(context, fit, ratio);
  }

  // Returns [size.width] / [size.height].
  // Will return 1.0 if:
  // [isInitialized] is false
  // [size.width], or [size.height] is equal to 0.0
  // aspect ratio would be less than or equal to 0.0
  double get aspectRatio => _platform.aspectRatio;

  double get buffered => _platform.buffered;

  Duration get duration => _platform.duration;

  String? get errorMessage => _platform.errorMessage;

  bool get hasError => _platform.hasError;

  bool get isBuffering => _platform.isBuffering;

  bool get isInitialized => _platform.isInitialized;

  bool get isLooping => _platform.isLooping;

  bool get isPlaying => _platform.isPlaying;

  double get playbackSpeed => _platform.playbackSpeed;

  Duration get position => _platform.position;

  Size get size => _platform.size;

  double get volume => _platform.volume;

  ChangeNotifier get eventStream => _platform.eventStream;
}
