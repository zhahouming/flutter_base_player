import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:flutter_base_player_platform_interface/flutter_base_player_platform_interface.dart';

export './change_notifier_builder.dart';
export './flutter_base_player_media_kit.dart';
export 'package:flutter_base_player_platform_interface/flutter_base_player_platform_interface.dart'
    show BaseTrack;

class FlutterBasePlayer {
  late FlutterBasePlayerPlatform _platform;
  FlutterBasePlayer() {
    _platform = FlutterBasePlayerPlatform.instance();
  }
  static initialize() {
    FlutterBasePlayerPlatform.instance().initialize();
  }

  // static FlutterBasePlayerPlatform get _platform {
  //   return FlutterBasePlayerPlatform.instance();
  // }

  FlutterBasePlayerPlatform? player;
  String filename = '';

  /// assets path example: assets://path/to/your/file.mp4
  Future<void> loadAssets(String path) {
    filename = basename(path);
    return _platform.assets(path);
  }

  Future<void> loadFile(File file) {
    filename = basename(file.path);
    return _platform.file(file);
  }

  /// url example: https://www.example.com/sample.mp4
  /// rtsp://www.example.com/live
  Future<void> loadNetwork(String url, [String? headers]) {
    filename = basename(url);
    return _platform.network(url);
  }

  dispose() {
    _platform.dispose();
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

  void replay() {
    _platform.replay();
  }

  Widget builder(BuildContext context,
      {BoxFit? fit, double? ratio, Color? color}) {
    return _platform.builder(context, fit, ratio, color);
  }

  // Returns [size.width] / [size.height].
  // Will return 1.0 if:
  // [isInitialized] is false
  // [size.width], or [size.height] is equal to 0.0
  // aspect ratio would be less than or equal to 0.0
  double get aspectRatio => _platform.aspectRatio;

  double get buffered => _platform.buffered;

  bool get completed => _platform.completed;

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

  ChangeNotifier get precompleteStream => _platform.precompleteStream;

  BaseTrack? get audioTrack => _platform.audioTrack;

  List<BaseTrack?> get audioTracks => _platform.audioTracks;

  void setAudioTrack(BaseTrack track) {
    _platform.setAudioTrack(track);
  }

  void setSubtitleTrack(BaseTrack track) {
    _platform.setSubtitleTrack(track);
  }

  void setVideoTrack(BaseTrack track) {
    _platform.setVideoTrack(track);
  }

  BaseTrack? get subtitleTrack => _platform.subtitleTrack;

  List<BaseTrack?> get subtitleTracks => _platform.subtitleTracks;

  BaseTrack? get videoTrack => _platform.videoTrack;

  List<BaseTrack?> get videoTracks => _platform.videoTracks;
}
