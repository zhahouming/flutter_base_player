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
  // FlutterBasePlayer player = FlutterBasePlayer();

  @override
  void initState() {
    Future.microtask(() async {
      await player.controller.loadNetwork(widget.url);
      player.controller.play();
    });
    // player.loadNetwork(widget.url);
    // player.play();
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
