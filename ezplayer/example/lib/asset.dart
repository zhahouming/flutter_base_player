import 'package:flutter/material.dart';
import 'package:ezplayer/ezplayer.dart';
import 'package:window_manager/window_manager.dart';

class AssetPage extends StatefulWidget {
  final String asset;
  const AssetPage({
    super.key,
    required this.asset,
  });

  @override
  State<AssetPage> createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> {
  EzPlayer player = EzPlayer();

  @override
  void initState() {
    player.aftterEnterFullscreen.addListener(() {
      // print('aftterEnterFullscreen');
      windowManager.setFullScreen(true);
    });
    player.aftterExitFullscreen.addListener(() {
      // print('aftterExitFullscreen');
      windowManager.setFullScreen(false);
    });
    Future.microtask(() async {
      await player.controller.loadAssets(widget.asset);
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
        alignment: const Alignment(0, -0.4),
        child: player.builder(context, ratio: 4 / 3),
      ),
    );
  }
}
