import 'dart:async';
import 'dart:io';
// import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base_player_platform_interface/flutter_base_player_platform_interface.dart';
import 'package:video_player/video_player.dart';
import 'change_notifier_builder.dart';

class FlutterBasePlayerVideoPlayer extends FlutterBasePlayerPlatform {
  initListeners() {
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    _controller.addListener(_eventStream.notifyListeners);
  }

  disposeListeners() {
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    _controller.removeListener(_eventStream.notifyListeners);
  }

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
    // do nothing, dart_vlc need only
  }

  @override
  void dispose() {
    _eventStream.dispose();
    _controller.dispose();
  }

  @override
  Future<void> assets(String path) {
    _controller = VideoPlayerController.asset(path);
    initListeners();
    return _controller.initialize();
  }

  @override
  Future<void> file(File file) {
    _controller = VideoPlayerController.file(file);
    initListeners();
    return _controller.initialize();
  }

  @override
  Future<void> network(String url) {
    _controller = VideoPlayerController.network(url);
    initListeners();
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

  final ChangeNotifier _eventStream = ChangeNotifier();

  @override
  ChangeNotifier get eventStream => _eventStream;

  @override
  Widget builder(BuildContext context, [BoxFit? fit, double? ratio]) {
    return ChangeNotifierBuilder(
      notifier: _eventStream,
      builder: (context) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints box) {
            double ratioHeight = box.maxWidth / (ratio ?? aspectRatio);
            return ClipRect(
              child: Container(
                height:
                    ratioHeight > box.maxHeight ? box.maxHeight : ratioHeight,
                width: box.maxWidth,
                decoration:
                    const BoxDecoration(color: Color.fromARGB(0, 0, 0, 0)),
                child: FittedBox(
                  fit: fit ?? BoxFit.contain,
                  child: SizedBox(
                    height: size.height,
                    width: size.width,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
