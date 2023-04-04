import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_base_player_platform_interface/flutter_base_player_platform_interface.dart';
import 'package:dart_vlc/dart_vlc.dart';

class FlutterBasePlayerDartVlcPlayer extends FlutterBasePlayerPlatform {
  static void registerWith() {
    FlutterBasePlayerPlatform.instance = FlutterBasePlayerDartVlcPlayer();
  }

  late Player _controller;
  bool _isInitialized = false;
  bool _isLooping = false;
  bool _isBuffering = false;

  // Returns [size.width] / [size.height].
  // Will return 1.0 if:
  // [isInitialized] is false
  // [size.width], or [size.height] is equal to 0.0
  // aspect ratio would be less than or equal to 0.0
  @override
  double get aspectRatio =>
      _controller.videoDimensions.width / _controller.videoDimensions.height;

  @override
  // TODO: implement buffered
  double get buffered => throw UnimplementedError();

  @override
  Duration get duration =>
      _controller.position.duration ?? const Duration(seconds: 0);

  @override
  String get errorMessage => _controller.error.toString();

  @override
  bool get hasError => _controller.error.isNotEmpty;

  @override
  // TODO: implement isBuffering
  bool get isBuffering => _isBuffering;

  @override
  bool get isInitialized => _isInitialized;

  @override
  bool get isLooping => _isLooping;

  @override
  bool get isPlaying => _controller.playback.isPlaying;

  @override
  double get playbackSpeed => _controller.general.rate;

  @override
  Duration get position =>
      _controller.position.duration ?? const Duration(seconds: 0);

  @override
  Size get size => Size(_controller.videoDimensions.width.toDouble(),
      _controller.videoDimensions.height.toDouble());

  @override
  double get volume => _controller.general.volume;

  @override
  Future<void> assets(String path) {
    _controller = Player(id: 0);
    _controller.open(
      Media.asset(path),
      autoStart: true,
    );
    _isInitialized = true;
    return Future.value();
  }

  @override
  Future<void> file(File file) {
    _controller = Player(id: 0);
    _controller.open(
      Media.file(file),
      autoStart: true,
    );
    _isInitialized = true;
    return Future.value();
  }

  @override
  Future<void> network(String url) {
    _controller = Player(id: 0);
    _controller.open(
      Media.network(url),
      autoStart: true,
    );
    _isInitialized = true;
    return Future.value();
  }

  @override
  void initialize() {
    if (Platform.isWindows || Platform.isLinux) {
      DartVLC.initialize();
    }
  }

  @override
  void pause() {
    _controller.pause();
  }

  @override
  void play() {
    _controller.play();
  }

  @override
  void seek(Duration duration) {
    _controller.seek(duration);
  }

  @override
  void setLooping(bool looping) {
    _isLooping = looping;
    _controller
        .setPlaylistMode(looping ? PlaylistMode.loop : PlaylistMode.single);
  }

  @override
  void setPlaybackSpeed(double speed) {
    _controller.setRate(speed);
  }

  @override
  void setVolume(double volume) {
    _controller.setRate(volume);
  }

  @override
  Widget builder(BuildContext context, [double? height, double? width]) {
    height ??= MediaQuery.of(context).size.width / 16 * 9;
    width ??= MediaQuery.of(context).size.width;

    return Video(
      player: _controller,
      width: width,
      height: height,
      showControls: false,
    );
  }
}
