part of '../ezplayer.dart';

class _TopBar extends StatelessWidget {
  final bool isFullscreen;
  final String titleText;
  final List<Widget> topBtns;
  final void Function()? onMenuTap;
  const _TopBar({
    Key? key,
    required this.isFullscreen,
    required this.titleText,
    topBtns,
    this.onMenuTap,
  })  : topBtns = topBtns ?? const [],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          isFullscreen ? titleText : '',
          style: const TextStyle(color: Colors.white70, fontSize: 18),
        ).div(SyyBoxStyle(marginLeft: 17)).expanded(),
        Text(
          timeFormat(DateTime.now().millisecondsSinceEpoch),
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ).div(SyyBoxStyle(marginRight: 17)),
        ...topBtns,
        SyyVideoIconBtn(
          iconData: Icons.more_horiz,
          onPressed: onMenuTap ??
              () async {
                syyToast('当前播放: $titleText');
              },
        ),
      ],
    ).div(SyyBoxStyle(width: global.screenWidth));
  }
}
