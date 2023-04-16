part of '../ezplayer.dart';

class BottomBar extends StatelessWidget {
  final EzPlayer ezplayer;
  final FlutterBasePlayer player;
  final bool isPlaying;
  final bool isFullscreen;
  final String positionTime;
  final String totalTime;
  final SyyVideoProgressBarController pCtrl;
  final void Function() togglePlay;
  final List<Widget> bottomLeftBtns;
  final List<Widget> bottomRightBtns;
  final double playbackSpeed;

  const BottomBar({
    Key? key,
    required this.ezplayer,
    required this.player,
    required this.isPlaying,
    required this.isFullscreen,
    required this.positionTime,
    required this.totalTime,
    required this.pCtrl,
    required this.togglePlay,
    required this.playbackSpeed,
    List<Widget>? bottomLeftBtns,
    List<Widget>? bottomRightBtns,
  })  : bottomLeftBtns = bottomLeftBtns ?? const [],
        bottomRightBtns = bottomRightBtns ?? const [],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   syyVCtrl.updateOverlay(
    //     widget: playbackSpeedSelectOverlay,
    //     alignment: Alignment.centerRight,
    //   );
    // });

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _PlayedTime(positionTime),
            SyyVideoProgressBar(controller: pCtrl)
                .div(DivStyle(alignment: Alignment.center, height: 10))
                .expanded(),
            _TotalTime(totalTime),
          ],
        ).div(DivStyle(
          paddingLR: 10,
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SyyVideoIconBtn(
                  iconData: isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                  onPressed: togglePlay,
                ),
                SpeedUp(ezplayer: ezplayer),
                VideoBoxfit(ezplayer: ezplayer),
                ...bottomLeftBtns
              ],
            ),
            Row(
              children: [
                ...bottomRightBtns,
                AudioTrack(ezplayer: ezplayer),
                SubtitleTrack(ezplayer: ezplayer),
                SyyVideoIconBtn(
                  iconData:
                      isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  onPressed: () {
                    if (isFullscreen) return Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenVideoPlayer(
                          ezplayer,
                          bottomLeftBtns: bottomLeftBtns,
                          bottomRightBtns: bottomRightBtns,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _PlayedTime extends StatelessWidget {
  final String positionTime;
  const _PlayedTime(this.positionTime, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      positionTime,
      style: const TextStyle(color: Colors.white, fontSize: 10),
    ).div(DivStyle(width: 48, height: 10, alignment: Alignment.bottomLeft));
  }
}

class _TotalTime extends StatelessWidget {
  final String totalTime;
  const _TotalTime(this.totalTime, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      totalTime,
      style: const TextStyle(color: Colors.white, fontSize: 10),
    ).div(DivStyle(width: 48, height: 10, alignment: Alignment.bottomRight));
  }
}
