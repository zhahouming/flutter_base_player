import 'package:flutter/material.dart';
import 'package:flutter_base_player/flutter_base_player.dart';

void main() {
  FlutterBasePlayer.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterBasePlayer player = FlutterBasePlayer();

  @override
  void initState() {
    player.setUrl('https://media.w3.org/2010/05/sintel/trailer.mp4');
    // player.setUrl('http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4');
    player.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          const Center(
            child: Text('video test'),
          ),
          player.builder(context),
          Row(
            children: [
              TextButton(onPressed: player.play, child: const Text('play')),
              TextButton(onPressed: player.pause, child: const Text('pause')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          player.play();
        },
        child: const Icon(Icons.play_circle),
      ),
    );
  }
}
