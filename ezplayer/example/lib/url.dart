import 'package:flutter/material.dart';
import 'package:ezplayer/ezplayer.dart';
// import 'package:flutter_base_player/flutter_base_player.dart';

class UrlPage extends StatefulWidget {
  final String url;
  final String? headers;
  const UrlPage({
    super.key,
    required this.url,
    this.headers,
  });

  @override
  State<UrlPage> createState() => _UrlPageState();
}

class _UrlPageState extends State<UrlPage> {
  EzPlayer player = EzPlayer();

  @override
  void initState() {
    player.attachMenu(OverlaySelectItem(
      title: '测试菜单',
      subtitle: 'desc',
      onPressed: () {},
    ));
    player.attachButton(
      EzplayerTextBtn(
        text: 'left',
        onPressed: () {
          player.showOverlay(
            alignment: Alignment.centerRight,
            builder: (context) => OverlaySelect(
              title: '内嵌音轨选择',
              width: 280,
              list: player.controller.audioTracks
                  .map((item) => OverlaySelectItem(
                        title: '${item?.title} ${item?.language ?? ""}',
                        subtitle: '内嵌音轨',
                        selected:
                            player.controller.audioTrack?.title == item?.title,
                        onPressed: () {
                          player.controller.setAudioTrack(item!);
                          // ezplayer.hideOverlay();
                        },
                      ))
                  .toList(),
            ),
          );
        },
      ),
      ButtonPosition.left,
    );
    player.attachButton(
      EzplayerTextBtn(
        text: 'right',
        onPressed: () {},
      ),
      ButtonPosition.right,
    );
    Future.microtask(() async {
      await player.controller.loadNetwork(widget.url);
      player.controller.play();
    });
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EzPlayer'),
      ),
      body: Container(
        // height: 300,
        width: MediaQuery.of(context).size.width,
        child: player.builder(context),
      ),
    );
  }
}
