library core_player;

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:path/path.dart';

part 'internal.dart';
part 'utils.dart';
part 'player.dart';
part 'state.dart';

class FlutterBasePlayer with _InternalMixin, _PlayerInstanceMixin, _StateMixin {
  static initialize() {
    MediaKit.ensureInitialized();
  }

  String filename = '';

  Future<void> loadAssets(
    String path, {
    int? bufferSize,
    MPVLogLevel? logLevel,
    Duration? initialDuration,
  }) async {
    filename = basename(path);
    await _initPlayer(
      bufferSize: bufferSize,
      logLevel: logLevel,
      initialDuration: initialDuration,
    );
    _initListeners();
    _isLoading = true;
    await _player.open(Media(path));
    _isInitialized = true;
    return Future.value();
  }

  Future<void> loadFile(
    File file, {
    int? bufferSize,
    MPVLogLevel? logLevel,
    Duration? initialDuration,
  }) async {
    filename = basename(file.path);
    await _initPlayer(
      bufferSize: bufferSize,
      logLevel: logLevel,
      initialDuration: initialDuration,
    );
    _initListeners();
    _isLoading = true;
    await _player.open(Media(file.path));
    _isInitialized = true;
    return Future.value();
  }

  Future<void> loadNetwork(
    String url, {
    Map? headers,
    int? bufferSize,
    MPVLogLevel? logLevel,
    Duration? initialDuration,
  }) async {
    filename = basename(url);
    _isLoading = true;
    await _initPlayer(
      headers: headers,
      bufferSize: bufferSize,
      logLevel: logLevel,
      initialDuration: initialDuration,
    );
    _initListeners();
    await _player.open(Media(url));
    _isInitialized = true;
    return Future.value();
  }

  notifyListener(event) {
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    _eventStream.notifyListeners();
  }

  _initListeners() {
    _player.streams.audioBitrate.listen(notifyListener);
    _player.streams.audioDevice.listen(notifyListener);
    _player.streams.audioDevices.listen(notifyListener);
    _player.streams.audioParams.listen(notifyListener);
    _player.streams.buffering.listen(notifyListener);
    _player.streams.completed.listen(notifyListener);
    _player.streams.duration.listen(notifyListener);

    _player.streams.error.listen((event) {
      notifyListener(event);
    });
    _player.streams.log.listen((event) {
      if ((event.level == 'error' && event.prefix == 'stream') ||
          event.level == 'fatal') {
        _hasError = true;
        _errorMessage = event.text;
      }
      notifyListener(event);
    });
    _player.streams.pitch.listen(notifyListener);
    _player.streams.playing.listen(notifyListener);
    _player.streams.playlist.listen(notifyListener);
    _player.streams.position.listen(_handlePosition);
    _player.streams.rate.listen(notifyListener);
    _player.streams.track.listen(notifyListener);
    _player.streams.tracks.listen(notifyListener);
    _player.streams.volume.listen(notifyListener);
  }

  _handlePosition(event) {
    if (isPlaying || isInitialized || isBuffering || hasError) {
      _isLoading = false;
    }
    if (isPlaying && duration.inSeconds - position.inSeconds == 5) {
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      precompleteStream.notifyListeners();
    }
    notifyListener(event);
  }

  setProperty(String property, String value) {
    if (_player.platform is libmpvPlayer) {
      (_player.platform as libmpvPlayer).setProperty(property, value);
    }
  }

  void dispose() {
    Future.microtask(() async {
      await _player.dispose();
      eventStream.dispose();
      precompleteStream.dispose();
    });
  }

  void pause() {
    _player.pause();
  }

  void play() {
    _player.play();
  }

  void replay() {
    _player.playOrPause();
  }

  void seek(Duration position) {
    _player.seek(position);
  }

  void setLooping(bool looping) {
    _isLooping = looping;
    _player.setPlaylistMode(looping ? PlaylistMode.single : PlaylistMode.none);
  }

  void setPlaybackSpeed(double speed) {
    _player.setRate(speed);
  }

  void setVolume(double volume) {
    _player.setVolume(volume * 100);
  }

  void setVideoTrack(BaseTrack track) {
    _player.setVideoTrack(track.raw);
  }

  void setAudioTrack(BaseTrack track) {
    _player.setAudioTrack(track.raw);
  }

  void setSubtitleTrack(BaseTrack track) {
    _player.setSubtitleTrack(track.raw);
  }

  Widget builder(
    BuildContext context, {
    BoxFit? fit,
    double? ratio,
    Color? color,
  }) {
    return ChangeNotifierBuilder(
      notifier: _eventStream,
      builder: (context) {
        return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints box) {
          return Stack(
            alignment: Alignment.center,
            children: [
              if (_controller != null)
                Video(
                  fit: fit ?? BoxFit.contain,
                  controller: _controller!,
                  width: box.maxWidth,
                  height: box.maxWidth / (ratio ?? aspectRatio),
                  fill: color ?? Colors.black,
                  controls: NoVideoControls,
                ),
              if (isBuffering && !hasError)
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
                        style:
                            TextStyle(color: Color.fromARGB(255, 10, 137, 234)),
                      ),
                    ],
                  ),
                ),
              if (_isLoading && !hasError)
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
                        style:
                            TextStyle(color: Color.fromARGB(255, 10, 137, 234)),
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
                        style:
                            TextStyle(color: Color.fromARGB(255, 67, 173, 255)),
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
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.replay,
                          color: Color.fromARGB(255, 67, 173, 255),
                        ),
                        onPressed: () {
                          _player.playOrPause();
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          _player.playOrPause();
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
          );
        });
      },
    );
  }
}
