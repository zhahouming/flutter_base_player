part of 'index.dart';

mixin _PlayerInstanceMixin on _InternalMixin {
  Player? __player;

  Player get _player =>
      __player ??= Player(configuration: const PlayerConfiguration());

  VideoController? _controller;

  _initPlayer({
    Map? headers,
    int? bufferSize,
    MPVLogLevel? logLevel,
    Duration? initialDuration,
  }) async {
    _hasError = false;
    _errorMessage = '';
    _errorLogs = [];

    await _player.dispose();

    __player = Player(
      configuration: PlayerConfiguration(
        logLevel: logLevel ?? MPVLogLevel.error,
        bufferSize: bufferSize ?? 32 * 1024 * 1024,
      ),
    );

    if (headers != null) {
      if (_player.platform is NativePlayer) {
        String v = headers.keys.map((k) => '$k: ${headers[k]}').join(',');
        (_player.platform as NativePlayer).setProperty("http-header-fields", v);
      }
    }
    (_player.platform as NativePlayer)
        .setProperty("start", initialDuration.toString());
    _controller = VideoController(_player);
  }
}
