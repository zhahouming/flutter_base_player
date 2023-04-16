import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_base_player_platform_interface/flutter_base_player_platform_interface.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'change_notifier_builder.dart';

class FlutterBasePlayerMediaKitPlayer extends FlutterBasePlayerPlatform {
  static void registerWith() {
    FlutterBasePlayerPlatform.instance =
        () => FlutterBasePlayerMediaKitPlayer();
  }

  FlutterBasePlayerMediaKitPlayer() {
    initListeners();
  }

  _notifyListener(event) {
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    _eventStream.notifyListeners();
  }

  initListeners() {
    _player.streams.audioBitrate.listen(_notifyListener);
    _player.streams.audioDevice.listen(_notifyListener);
    _player.streams.audioDevices.listen(_notifyListener);
    _player.streams.audioParams.listen(_notifyListener);
    _player.streams.buffering.listen(_notifyListener);
    _player.streams.completed.listen(_notifyListener);
    _player.streams.duration.listen(_notifyListener);

    _player.streams.error.listen((event) {
      // print('player error: ' + event.toString());
      _notifyListener(event);
    });
    _player.streams.log.listen((event) {
      if ((event.level == 'error' && event.prefix == 'stream') ||
          event.level == 'fatal') {
        _hasError = true;
        _errorMessage = event.text;
      }
      // print('player log: ' + event.toString());
      _notifyListener(event);
    });
    _player.streams.pitch.listen(_notifyListener);
    _player.streams.playing.listen(_notifyListener);
    _player.streams.playlist.listen(_notifyListener);
    _player.streams.position.listen(_handlePosition);
    _player.streams.rate.listen(_notifyListener);
    _player.streams.track.listen(_notifyListener);
    _player.streams.tracks.listen(_notifyListener);
    _player.streams.volume.listen(_notifyListener);
  }

  _handlePosition(event) {
    if (isPlaying || isInitialized || isBuffering || hasError) {
      _isLoading = false;
    }
    if (isPlaying && duration.inSeconds - position.inSeconds == 5) {
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      precompleteStream.notifyListeners();
    }
    _notifyListener(event);
  }

  Player? __player;

  Player get _player {
    __player ??= Player(configuration: const PlayerConfiguration());
    return __player!;
  }

  VideoController? _controller;

  bool _isInitialized = false;
  bool _isLooping = false;
  bool _hasError = false;
  String _errorMessage = '';

  // Returns [size.width] / [size.height].
  // Will return 1.0 if:
  // [isInitialized] is false
  // [size.width], or [size.height] is equal to 0.0
  // aspect ratio would be less than or equal to 0.0
  @override
  double get aspectRatio => size.width / size.height;

  @override
  bool get completed => _player.state.completed;

  @override
  double get buffered => duration.inMilliseconds == 0
      ? 0
      : position.inMilliseconds / duration.inMilliseconds;

  @override
  Duration get duration => _player.state.duration;

  @override
  String get errorMessage => _errorMessage;

  @override
  bool get hasError => _hasError;

  bool _isLoading = false;

  @override
  bool get isBuffering => _player.state.buffering;

  @override
  bool get isInitialized => _isInitialized;

  @override
  bool get isLooping => _isLooping;

  @override
  bool get isPlaying => _player.state.playing;

  @override
  double get playbackSpeed => _player.state.rate;

  @override
  Duration get position => _player.state.position;

  @override
  Size get size {
    double width = _controller?.width?.toDouble() ?? 480;
    double height = _controller?.height?.toDouble() ?? 360;
    return Size(width, height);
  }

  @override
  double get volume => _player.state.volume;

  initPlayer([String? headers]) async {
    _hasError = false;
    _errorMessage = '';
    await _controller?.dispose();
    await _player.dispose();
    __player = Player(
        configuration: const PlayerConfiguration(logLevel: MPVLogLevel.info));
    if (headers != null && _player.platform is libmpvPlayer) {
      (_player.platform as libmpvPlayer)
          .setProperty("http-header-fields", headers);
    }
    _controller = await VideoController.create(_player.handle);
    initListeners();
  }

  @override
  Future<void> assets(String path) async {
    await initPlayer();
    _isLoading = true;
    await _player.open(Media(path));
    _isInitialized = true;
    return Future.value();
  }

  @override
  Future<void> file(File file) async {
    await initPlayer();
    _isLoading = true;
    await _player.open(Media(file.path));
    _isInitialized = true;
    return Future.value();
  }

  @override
  Future<void> network(String url, [String? headers]) async {
    _isLoading = true;
    await initPlayer(headers);
    await _player.open(Media(url));
    _isInitialized = true;
    return Future.value();
  }

  @override
  void initialize() {
    // do nothing;
  }

  @override
  void dispose() {
    Future.microtask(() async {
      await _controller?.dispose();
      await _player.dispose();
      eventStream.dispose();
      precompleteStream.dispose();
    });
  }

  @override
  void pause() {
    _player.pause();
  }

  @override
  void play() {
    _player.play();
  }

  @override
  void seek(Duration position) {
    _player.seek(position);
  }

  @override
  void setLooping(bool looping) {
    _isLooping = looping;
    _player.setPlaylistMode(looping ? PlaylistMode.single : PlaylistMode.none);
  }

  @override
  void setPlaybackSpeed(double speed) {
    _player.setRate(speed);
  }

  @override
  void setVolume(double volume) {
    _player.setVolume(volume * 100);
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
            return Stack(
              alignment: Alignment.center,
              children: [
                Video(
                  fit: fit ?? BoxFit.contain,
                  controller: _controller,
                  width: box.maxWidth,
                  height: box.maxWidth / (ratio ?? aspectRatio),
                  fill: color ?? Colors.black,
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
                  SizedBox(
                    height: box.maxWidth / (ratio ?? aspectRatio),
                    width: box.maxWidth,
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
                          errorMessage,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 67, 173, 255)),
                        ),
                      ],
                    ),
                  ),
                if (completed)
                  SizedBox(
                    height: box.maxWidth / (ratio ?? aspectRatio),
                    width: box.maxWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          '播放结束',
                          style: TextStyle(
                              color: Color.fromARGB(255, 67, 173, 255)),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          });
        });
  }

  @override
  void setAudioTrack(BaseTrack track) {
    _player.setAudioTrack(track.raw);
  }

  @override
  void setSubtitleTrack(BaseTrack track) {
    _player.setSubtitleTrack(track.raw);
  }

  @override
  void setVideoTrack(BaseTrack track) {
    _player.setVideoTrack(track.raw);
  }

  getSubtitleTrackTitle(SubtitleTrack track) {
    String title = track.title ?? '';
    if (track.id == 'no') {
      title = '不选择';
    }
    if (track.id == 'auto') {
      title = '自动选择';
    }
    return title;
  }

  getVideoTrackTitle(VideoTrack track) {
    String title = track.title ?? '';
    if (track.id == 'no') {
      title = '不选择';
    }
    if (track.id == 'auto') {
      title = '自动选择';
    }
    return title;
  }

  getAudioTrackTitle(AudioTrack track) {
    String title = track.title ?? '';
    if (track.id == 'no') {
      title = '不选择';
    }
    if (track.id == 'auto') {
      title = '自动选择';
    }
    return title;
  }

  @override
  BaseTrack get audioTrack => BaseTrack(
        id: _player.state.track.audio.id,
        title: getAudioTrackTitle(_player.state.track.audio),
        language: _player.state.track.audio.language,
        raw: _player.state.track.audio,
      );

  @override
  List<BaseTrack> get audioTracks => _player.state.tracks.audio
      .map((e) => BaseTrack(
            id: e.id,
            title: getAudioTrackTitle(e),
            language: e.language,
            raw: e,
          ))
      .toList();

  @override
  BaseTrack get subtitleTrack => BaseTrack(
        id: _player.state.track.subtitle.id,
        title: getSubtitleTrackTitle(_player.state.track.subtitle),
        language: _player.state.track.subtitle.language,
        raw: _player.state.track.subtitle,
      );

  @override
  List<BaseTrack> get subtitleTracks => _player.state.tracks.subtitle.map((e) {
        return BaseTrack(
          id: e.id,
          title: getSubtitleTrackTitle(e),
          language: e.language,
          raw: e,
        );
      }).toList();

  @override
  BaseTrack get videoTrack => BaseTrack(
        id: _player.state.track.video.id,
        title: getVideoTrackTitle(_player.state.track.video),
        language: _player.state.track.video.language,
        raw: _player.state.track.video,
      );

  @override
  List<BaseTrack> get videoTracks => _player.state.tracks.video
      .map((e) => BaseTrack(
            id: e.id,
            title: getVideoTrackTitle(e),
            language: e.language,
            raw: e,
          ))
      .toList();
}
