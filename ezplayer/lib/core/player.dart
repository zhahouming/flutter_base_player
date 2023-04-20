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

    await _controller?.dispose();
    await _player.dispose();

    __player = Player(
      configuration: PlayerConfiguration(
        logLevel: logLevel ?? MPVLogLevel.none,
        bufferSize: bufferSize ?? 32 * 1024 * 1024,
      ),
    );

    if (headers != null) {
      if (_player.platform is libmpvPlayer) {
        String v = headers.keys.map((k) => '$k: ${headers[k]}').join(',');
        (_player.platform as libmpvPlayer).setProperty("http-header-fields", v);
      }
    }
    (_player.platform as libmpvPlayer)
        .setProperty("start", initialDuration.toString());
    _controller = await VideoController.create(_player);
  }
}
