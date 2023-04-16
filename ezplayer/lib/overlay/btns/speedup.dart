part of '../../ezplayer.dart';

class SpeedUp extends StatelessWidget {
  final EzPlayer ezplayer;
  const SpeedUp({
    Key? key,
    required this.ezplayer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EzplayerTextBtn(
      text: ezplayer.controller.playbackSpeed == 1
          ? '倍速'
          : '${ezplayer.controller.playbackSpeed}x',
      onPressed: () {
        ezplayer.showOverlay(
          builder: (context) => PlaybackSpeedOverlay(player: ezplayer),
          alignment: Alignment.centerRight,
        );
      },
    );
  }
}

class PlaybackSpeedOverlay extends StatelessWidget {
  final EzPlayer player;
  const PlaybackSpeedOverlay({
    Key? key,
    required this.player,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<double> speedList = [0.5, 0.75, 1, 1.25, 1.5, 1.75, 2];
    return OverlaySelect(
      title: '倍速播放',
      width: 280,
      list: speedList
          .map((e) => OverlaySelectItem(
              title: '$e 倍速',
              subtitle: e == player.controller.playbackSpeed ? '当前选择' : null,
              selected: player.controller.playbackSpeed == e,
              onPressed: () {
                player.controller.setPlaybackSpeed(e);
                // player.hideOverlay();
              }))
          .toList(),
    );
  }
}
