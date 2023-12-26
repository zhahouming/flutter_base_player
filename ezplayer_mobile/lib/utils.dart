part of 'ezplayer.dart';

timeFormat(int ms) {
  return formatDate(
    DateTime.fromMillisecondsSinceEpoch(ms),
    [HH, ':', nn, ':', ss],
  );
}

extension SubtitleExtension on Widget {
  Widget subtitle({
    required FlutterBasePlayer videoPlayerController,
    SubtitleController? subtitleController,
    required SubtitleStyle subtitleStyle,
    Color? backgroundColor,
  }) {
    if (subtitleController == null) return this;
    return SubtitleWrapper(
      videoPlayerController: videoPlayerController,
      subtitleController: subtitleController,
      subtitleStyle: subtitleStyle,
      backgroundColor: backgroundColor,
      videoChild: this,
    );
  }
}
