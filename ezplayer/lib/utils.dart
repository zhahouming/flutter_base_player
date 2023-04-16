part of 'ezplayer.dart';

timeFormat(int ms) {
  return formatDate(
    DateTime.fromMillisecondsSinceEpoch(ms),
    [HH, ':', nn, ':', ss],
  );
}
