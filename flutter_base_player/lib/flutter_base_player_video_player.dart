import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_base_player_platform_interface/flutter_base_player_platform_interface.dart';
import 'package:video_player/video_player.dart';
import 'change_notifier_builder.dart';

class FlutterBasePlayerVideoPlayer extends FlutterBasePlayerPlatform {
  static void registerWith() {
    FlutterBasePlayerPlatform.instance = () => FlutterBasePlayerVideoPlayer();
  }

  initListeners() {
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    _controller?.addListener(_eventStream.notifyListeners);
    _controller?.addListener(_handleState);
  }

  _handleState() {
    if (isPlaying || isInitialized || isBuffering || hasError) {
      _isLoading = false;
    }
    if (!isPlaying && duration.inSeconds - position.inSeconds == 0) {
      if (!_completed) {
        _completed = true;
      }
    } else {
      _completed = false;
    }
    if (isPlaying && duration.inSeconds - position.inSeconds == 5) {
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      precompleteStream.notifyListeners();
    }
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    _eventStream.notifyListeners();
  }

  VideoPlayerController? _controller;

  // Returns [size.width] / [size.height].
  // Will return 1.0 if:
  // [isInitialized] is false
  // [size.width], or [size.height] is equal to 0.0
  // aspect ratio would be less than or equal to 0.0
  @override
  double get aspectRatio => _controller?.value.aspectRatio ?? 16 / 9;

  @override
  double get buffered => _controller != null
      ? _controller!.value.buffered.last.end.inSeconds / duration.inSeconds
      : 0;

  bool _completed = false;
  @override
  bool get completed => _completed;

  @override
  Duration get duration =>
      _controller?.value.duration ?? const Duration(seconds: 0);

  @override
  String? get errorMessage => _controller?.value.errorDescription;

  @override
  bool get hasError => _controller?.value.hasError ?? false;

  bool _isLoading = false;

  @override
  bool get isBuffering => _controller?.value.isBuffering ?? false;

  @override
  bool get isInitialized => _controller?.value.isInitialized ?? false;

  @override
  bool get isLooping => _controller?.value.isLooping ?? false;

  @override
  bool get isPlaying => _controller?.value.isPlaying ?? false;

  @override
  double get playbackSpeed => _controller?.value.playbackSpeed ?? 1;

  @override
  Duration get position =>
      _controller?.value.position ?? const Duration(seconds: 0);

  @override
  Size get size => _controller?.value.size ?? const Size(480, 360);

  @override
  double get volume => _controller?.value.volume ?? 1;

  @override
  void initialize() {
    // do nothing, dart_vlc need only
  }

  @override
  void dispose() {
    _controller?.dispose();
    precompleteStream.dispose();
    _eventStream.dispose();
  }

  @override
  Future<void> assets(String path) {
    _controller?.dispose();
    _completed = false;
    _isLoading = true;
    path = path.replaceFirst('asset://', '');
    _controller = VideoPlayerController.asset(
      path,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    initListeners();
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    eventStream.notifyListeners();
    return _controller!.initialize();
  }

  @override
  Future<void> file(File file) {
    _controller?.dispose();
    _completed = false;
    _isLoading = true;
    _controller = VideoPlayerController.file(
      file,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    initListeners();
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    eventStream.notifyListeners();
    return _controller!.initialize();
  }

  @override
  Future<void> network(String url, [String? headers]) {
    _controller?.dispose();
    _completed = false;
    _isLoading = true;
    Map<String, String> httpHeaders = {};
    headers?.split(';').forEach((String item) {
      List<String> tmp = item.split(':');
      httpHeaders[tmp[0].trim()] = tmp[1].trim();
    });
    _controller = VideoPlayerController.network(
      url,
      httpHeaders: httpHeaders,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    initListeners();
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    eventStream.notifyListeners();
    return _controller!.initialize();
  }

  @override
  void pause() {
    _controller?.pause();
  }

  @override
  void play() {
    _controller?.play();
  }

  @override
  void replay() {
    _controller?.play();
  }

  @override
  void seek(Duration position) {
    _controller?.seekTo(position);
  }

  @override
  void setLooping(bool looping) {
    _controller?.setLooping(looping);
  }

  @override
  void setPlaybackSpeed(double speed) {
    _controller?.setPlaybackSpeed(speed);
  }

  @override
  void setVolume(double volume) {
    _controller?.setVolume(volume);
  }

  final ChangeNotifier _eventStream = ChangeNotifier();

  @override
  ChangeNotifier get eventStream => _eventStream;

  final ChangeNotifier _precompleteStream = ChangeNotifier();
  @override
  ChangeNotifier get precompleteStream => _precompleteStream;

  @override
  Widget builder(BuildContext context,
      [BoxFit? fit, double? ratio, Color? color]) {
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
                decoration: BoxDecoration(color: color ?? Colors.black),
                child: Stack(
                  fit: StackFit.passthrough,
                  alignment: Alignment.center,
                  children: [
                    if (!isInitialized &&
                        !completed &&
                        !hasError &&
                        !_isLoading)
                      SizedBox(
                        height: box.maxWidth / (ratio ?? aspectRatio),
                        width: box.maxWidth,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              '未选择视频',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 67, 173, 255)),
                            ),
                          ],
                        ),
                      ),
                    if (isInitialized)
                      FittedBox(
                        fit: fit ?? BoxFit.contain,
                        child: SizedBox(
                          height: size.height,
                          width: size.width,
                          child: VideoPlayer(_controller!),
                        ),
                      ),
                    if (isBuffering)
                      Container(
                        height: box.maxWidth / (ratio ?? aspectRatio),
                        width: box.maxWidth,
                        color: Colors.black54,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(strokeWidth: 1),
                            SizedBox(height: 20),
                            Text(
                              '缓冲中...',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 10, 137, 234)),
                            ),
                          ],
                        ),
                      ),
                    if (_isLoading)
                      Container(
                        height: box.maxWidth / (ratio ?? aspectRatio),
                        width: box.maxWidth,
                        color: Colors.black54,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(strokeWidth: 1),
                            SizedBox(height: 20),
                            Text(
                              '加载中...',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 10, 137, 234)),
                            ),
                          ],
                        ),
                      ),
                    if (hasError)
                      Container(
                        height: box.maxWidth / (ratio ?? aspectRatio),
                        width: box.maxWidth,
                        color: Colors.black54,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '播放错误',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 67, 173, 255)),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              errorMessage ?? '',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 67, 173, 255)),
                            ),
                          ],
                        ),
                      ),
                    if (completed && !hasError)
                      Container(
                        height: box.maxWidth / (ratio ?? aspectRatio),
                        width: box.maxWidth,
                        color: Colors.black54,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.replay,
                                color: Color.fromARGB(255, 67, 173, 255),
                              ),
                              onPressed: () {
                                _controller?.play();
                              },
                            ),
                            TextButton(
                              onPressed: () {
                                _controller?.play();
                              },
                              child: const Text(
                                '重新播放',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 67, 173, 255)),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  get audioTrack => null;

  @override
  get audioTracks => [];

  @override
  void setAudioTrack(track) {
    // do nothing;
  }

  @override
  void setSubtitleTrack(track) {
    // do nothing;
  }

  @override
  void setVideoTrack(track) {
    // do nothing;
  }

  @override
  get subtitleTrack => null;

  @override
  get subtitleTracks => [];

  @override
  get videoTrack => null;

  @override
  get videoTracks => [];
}
