part of '../../ezplayer.dart';

class VideoBoxfit extends StatelessWidget {
  final EzPlayer ezplayer;
  const VideoBoxfit({Key? key, required this.ezplayer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EzplayerTextBtn(
        text: '画面',
        onPressed: () {
          ezplayer.showOverlay(
            alignment: Alignment.centerRight,
            builder: (context) => OverlaySelect(
              title: '画面裁剪模式',
              width: 280,
              list: [
                OverlaySelectItem(
                  title: '原始比例',
                  subtitle: '默认设置',
                  selected: ezplayer.cutStyle == BoxFit.contain,
                  onPressed: () {
                    ezplayer.setCutStyle(BoxFit.contain);
                    // ezplayer.hideOverlay();
                  },
                ),
                OverlaySelectItem(
                  title: '按比例铺满',
                  subtitle: '可能会裁剪掉一部分画面',
                  selected: ezplayer.cutStyle == BoxFit.cover,
                  onPressed: () {
                    ezplayer.setCutStyle(BoxFit.cover);
                    // ezplayer.hideOverlay();
                  },
                ),
                OverlaySelectItem(
                  title: '拉伸铺满',
                  subtitle: '可能会使画面变形明显',
                  selected: ezplayer.cutStyle == BoxFit.fill,
                  onPressed: () {
                    ezplayer.setCutStyle(BoxFit.fill);
                    // ezplayer.hideOverlay();
                  },
                ),
                OverlaySelectItem(
                  title: '高度铺满',
                  subtitle: '按比例缩放宽度，宽度可能会裁剪掉一部分',
                  selected: ezplayer.cutStyle == BoxFit.fitHeight,
                  onPressed: () {
                    ezplayer.setCutStyle(BoxFit.fitHeight);
                    // ezplayer.hideOverlay();
                  },
                ),
                OverlaySelectItem(
                  title: '宽度铺满',
                  subtitle: '按比例缩放高度，高度可能会裁剪掉一部分',
                  selected: ezplayer.cutStyle == BoxFit.fitWidth,
                  onPressed: () {
                    ezplayer.setCutStyle(BoxFit.fitWidth);
                    // ezplayer.hideOverlay();
                  },
                ),
              ],
            ),
          );
        });
  }
}
