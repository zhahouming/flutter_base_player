import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ezplayer/ezplayer.dart';

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
    Future.microtask(() async {
      await player.controller.loadFile(widget.file);
      await player.controller.play();
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
