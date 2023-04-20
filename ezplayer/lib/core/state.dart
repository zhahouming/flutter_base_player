part of 'index.dart';

mixin _StateMixin on _PlayerInstanceMixin {
  // Returns [size.width] / [size.height].
  // Will return 1.0 if:
  // [isInitialized] is false
  // [size.width], or [size.height] is equal to 0.0
  // aspect ratio would be less than or equal to 0.0
  double get aspectRatio => size.width / size.height;

  bool get completed => _player.state.completed;

  double get buffered => duration.inMilliseconds == 0
      ? 0
      : buffer.inMilliseconds / duration.inMilliseconds;

  Duration get duration => _player.state.duration;

  Duration get buffer => _player.state.buffer;

  String get errorMessage => _errorMessage;

  bool get hasError => _hasError;

  bool get isBuffering => _player.state.buffering;

  bool get isInitialized => _isInitialized;

  bool get isLooping => _isLooping;

  bool get isPlaying => _player.state.playing;

  double get playbackSpeed => _player.state.rate;

  Duration get position => _player.state.position;

  Size get size {
    double width = _player.state.width?.toDouble() ??
        _controller?.width?.toDouble() ??
        480;
    double height = _player.state.height?.toDouble() ??
        _controller?.height?.toDouble() ??
        360;
    return Size(width, height);
  }

  double get volume => _player.state.volume;

  ChangeNotifier get eventStream => _eventStream;

  ChangeNotifier get precompleteStream => _precompleteStream;

  BaseTrack get audioTrack => BaseTrack(
        id: _player.state.track.audio.id,
        title: _getAudioTrackTitle(_player.state.track.audio),
        language: _player.state.track.audio.language,
        raw: _player.state.track.audio,
      );

  List<BaseTrack> get audioTracks => _player.state.tracks.audio
      .map((e) => BaseTrack(
            id: e.id,
            title: _getAudioTrackTitle(e),
            language: e.language,
            raw: e,
          ))
      .toList();

  BaseTrack get subtitleTrack => BaseTrack(
        id: _player.state.track.subtitle.id,
        title: _getSubtitleTrackTitle(_player.state.track.subtitle),
        language: _player.state.track.subtitle.language,
        raw: _player.state.track.subtitle,
      );

  List<BaseTrack> get subtitleTracks => _player.state.tracks.subtitle.map((e) {
        return BaseTrack(
          id: e.id,
          title: _getSubtitleTrackTitle(e),
          language: e.language,
          raw: e,
        );
      }).toList();

  BaseTrack get videoTrack => BaseTrack(
        id: _player.state.track.video.id,
        title: _getVideoTrackTitle(_player.state.track.video),
        language: _player.state.track.video.language,
        raw: _player.state.track.video,
      );

  List<BaseTrack> get videoTracks => _player.state.tracks.video
      .map((e) => BaseTrack(
            id: e.id,
            title: _getVideoTrackTitle(e),
            language: e.language,
            raw: e,
          ))
      .toList();
}

_getSubtitleTrackTitle(SubtitleTrack track) {
  String title = track.title ?? '';
  if (track.id == 'no') {
    title = '不选择';
  }
  if (track.id == 'auto') {
    title = '自动选择';
  }
  return title;
}

_getVideoTrackTitle(VideoTrack track) {
  String title = track.title ?? '';
  if (track.id == 'no') {
    title = '不选择';
  }
  if (track.id == 'auto') {
    title = '自动选择';
  }
  return title;
}

_getAudioTrackTitle(AudioTrack track) {
  String title = track.title ?? '';
  if (track.id == 'no') {
    title = '不选择';
  }
  if (track.id == 'auto') {
    title = '自动选择';
  }
  return title;
}
