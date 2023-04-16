part of '../ezplayer.dart';

class TopBar extends StatelessWidget {
  final bool isFullscreen;
  final String titleText;
  final List<Widget> topBtns;
  final void Function()? onMenuTap;
  final EzPlayer ezplayer;
  final FlutterBasePlayer player;

  final List<OverlaySelectItem> menuBtns;
  const TopBar({
    Key? key,
    required this.isFullscreen,
    required this.titleText,
    required this.player,
    required this.ezplayer,
    required this.menuBtns,
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
          titleText,
          style: const TextStyle(color: Colors.white70, fontSize: 18),
        ).div(DivStyle(marginLeft: 17)).expanded(),
        Text(
          timeFormat(DateTime.now().millisecondsSinceEpoch),
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ).div(DivStyle(marginRight: 17)),
        ...topBtns,
        SyyVideoIconBtn(
          iconData: Icons.more_horiz,
          onPressed: onMenuTap ??
              () async {
                ezplayer.showOverlay(
                  alignment: Alignment.centerRight,
                  builder: (context) => OverlaySelect(
                    title: '菜单',
                    width: 280,
                    list: menuBtns,
                  ),
                );
              },
        ),
      ],
    ).div(DivStyle(width: MediaQuery.of(context).size.width));
  }
}
