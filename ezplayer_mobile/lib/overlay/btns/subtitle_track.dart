part of '../../ezplayer.dart';

class SubtitleTrack extends StatelessWidget {
  final EzPlayer ezplayer;
  const SubtitleTrack({Key? key, required this.ezplayer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EzplayerTextBtn(
        text: '字幕',
        onPressed: () {
          ezplayer.showOverlay(
            alignment: Alignment.centerRight,
            builder: (context) => OverlaySelect(
              title: '内嵌字幕选择',
              width: 280,
              list: ezplayer.controller.subtitleTracks
                  .map((item) => OverlaySelectItem(
                        title: '${item.title} ${item.language ?? ""}',
                        subtitle: '内嵌字幕  ${item.id}',
                        selected:
                            ezplayer.controller.subtitleTrack.id == item.id,
                        onPressed: () {
                          ezplayer.controller.setSubtitleTrack(item);
                          // ezplayer.hideOverlay();
                        },
                      ))
                  .toList(),
            ),
          );
        });
  }
}
