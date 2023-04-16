part of '../../ezplayer.dart';

class AudioTrack extends StatelessWidget {
  final EzPlayer ezplayer;
  const AudioTrack({Key? key, required this.ezplayer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EzplayerTextBtn(
        text: '音轨',
        onPressed: () {
          ezplayer.showOverlay(
            alignment: Alignment.centerRight,
            builder: (context) => OverlaySelect(
              title: '内嵌音轨选择',
              width: 280,
              list: ezplayer.controller.audioTracks
                  .map((item) => OverlaySelectItem(
                        title: '${item?.title} ${item?.language ?? ""}',
                        subtitle: '内嵌音轨',
                        selected: ezplayer.controller.audioTrack?.title ==
                            item?.title,
                        onPressed: () {
                          ezplayer.controller.setAudioTrack(item!);
                          // ezplayer.hideOverlay();
                        },
                      ))
                  .toList(),
            ),
          );
        });
  }
}
