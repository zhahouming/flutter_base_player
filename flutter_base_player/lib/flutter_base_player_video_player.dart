import 'dart:async';
import 'dart:io';
// import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base_player_platform_interface/flutter_base_player_platform_interface.dart';
import 'package:video_player/video_player.dart';

class FlutterBasePlayerVideoPlayer extends FlutterBasePlayerPlatform {
  static void registerWith() {
    FlutterBasePlayerPlatform.instance = FlutterBasePlayerVideoPlayer();
  }

  late VideoPlayerController _controller;

  // Returns [size.width] / [size.height].
  // Will return 1.0 if:
  // [isInitialized] is false
  // [size.width], or [size.height] is equal to 0.0
  // aspect ratio would be less than or equal to 0.0
  @override
  double get aspectRatio => _controller.value.aspectRatio;

  @override
  // TODO: implement buffered
  double get buffered => throw UnimplementedError();

  @override
  Duration get duration => _controller.value.duration;

  @override
  String? get errorMessage => _controller.value.errorDescription;

  @override
  bool get hasError => _controller.value.hasError;

  @override
  bool get isBuffering => _controller.value.isBuffering;

  @override
  bool get isInitialized => _controller.value.isInitialized;

  @override
  bool get isLooping => _controller.value.isLooping;

  @override
  bool get isPlaying => _controller.value.isPlaying;

  @override
  double get playbackSpeed => _controller.value.playbackSpeed;

  @override
  Duration get position => _controller.value.position;

  @override
  Size get size => _controller.value.size;

  @override
  double get volume => _controller.value.volume;

  @override
  void initialize() {
    // do nothing
  }

  @override
  Future<void> assets(String path) {
    _controller = VideoPlayerController.asset(path);
    return _controller.initialize();
  }

  @override
  Future<void> file(File file) {
    _controller = VideoPlayerController.file(file);
    return _controller.initialize();
  }

  @override
  Future<void> network(String url) {
    _controller = VideoPlayerController.network(url);
    return _controller.initialize();
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
  void seek(Duration position) {
    _controller.seekTo(position);
  }

  @override
  void setLooping(bool looping) {
    _controller.setLooping(looping);
  }

  @override
  void setPlaybackSpeed(double speed) {
    _controller.setPlaybackSpeed(speed);
  }

  @override
  void setVolume(double volume) {
    _controller.setVolume(volume);
  }

  @override
  Widget builder(BuildContext context, [double? height, double? width]) {
    height ??= MediaQuery.of(context).size.width / 16 * 9;
    width ??= MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(color: Color.fromARGB(0, 0, 0, 0)),
      child: VideoPlayer(_controller),
    );
  }
}
