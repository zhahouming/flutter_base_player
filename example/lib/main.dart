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

  BoxFit fit = BoxFit.contain;
  double ratio = 4 / 3;

  @override
  void initState() {
    player.loadNetwork('https://media.w3.org/2010/05/sintel/trailer.mp4');
    // player.loadNetwork('http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4');
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
            child: Text(
              'Video Test',
              style: TextStyle(fontSize: 24, height: 2),
            ),
          ),
          SizedBox(
            height: 300,
            width: 300,
            child: player.builder(context, fit: fit, ratio: ratio),
          ),
          Row(
            children: [
              TextButton(onPressed: player.play, child: const Text('play')),
              TextButton(onPressed: player.pause, child: const Text('pause')),
            ],
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    fit = BoxFit.contain;
                  });
                },
                child: const Text('contain'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    fit = BoxFit.cover;
                  });
                },
                child: const Text('cover'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    fit = BoxFit.fill;
                  });
                },
                child: const Text('fill'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    fit = BoxFit.fitHeight;
                  });
                },
                child: const Text('fitHeight'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    fit = BoxFit.fitWidth;
                  });
                },
                child: const Text('fitWidth'),
              ),
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
