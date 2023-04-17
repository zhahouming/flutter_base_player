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
        if (!isFullscreen && ezplayer.showBackBtn)
          IconButton(
            onPressed: Navigator.of(context).pop,
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 14,
            ),
          ).div(DivStyle(marginLeft: 3)),
        Text(
          titleText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        )
            .div(DivStyle(
              marginLeft: !isFullscreen && ezplayer.showBackBtn ? 0 : 17,
              paddingBottom: 3,
            ))
            .expanded(),
        Text(
          timeFormat(DateTime.now().millisecondsSinceEpoch),
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ).div(DivStyle(marginRight: 17)),
        ...topBtns,
        EzplayerIconBtn(
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
