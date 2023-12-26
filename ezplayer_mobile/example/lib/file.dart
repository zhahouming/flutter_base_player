import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ezplayer/ezplayer.dart';
import 'package:window_manager/window_manager.dart';

class FilePage extends StatefulWidget {
  final File file;
  const FilePage({
    super.key,
    required this.file,
  });

  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
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
    player.externalSubtitles = [
      EzplayerSubtitleExternal(
        id: '1',
        title: 'KungFu',
        language: 'Chinese',
        source: 'assets',
        load: () async {
          final bundle = DefaultAssetBundle.of(context);
          String str = await bundle.loadString('assets/video/KungFu.srt');
          return str;
        },
      )
    ];
    Future.microtask(() async {
      await player.controller.loadFile(widget.file);
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
      body: player.builder(context),
    );
  }
}
