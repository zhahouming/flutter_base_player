> easy video player for flutter

## Support Platform

Android, iOS, MacOS, Windows, Linux

## Installation

We use [flutter_base_player](https://pub.dev/packages/flutter_base_player) , and they have some additional configuration steps, please refer to the instructions provided by these packages

## Example

```dart
import 'package:flutter/material.dart';
import 'package:ezplayer/ezplayer.dart';

void main() {
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
      body: ListView(
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
            child: player.builder(context, fit: fit,),
            // child: player.builder(context, fit: fit, ratio: ratio),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: [
              TextButton(onPressed: player.play, child: const Text('play')),
              TextButton(onPressed: player.pause, child: const Text('pause')),
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
                  player.seek(const Duration(seconds: 10));
                },
                child: const Text('seek to 10s'),
              ),
              TextButton(
                onPressed: () {
                  player.seek(const Duration(seconds: 20));
                },
                child: const Text('seek to 20s'),
              ),
              TextButton(
                onPressed: () {
                  player.seek(const Duration(seconds: 30));
                },
                child: const Text('seek to 30s'),
              ),
              TextButton(
                onPressed: () {
                  player.seek(const Duration(seconds: 40));
                },
                child: const Text('seek to 40s'),
              ),
              TextButton(
                onPressed: () {
                  player.seek(const Duration(seconds: 50));
                },
                child: const Text('seek to 50s'),
              ),
              TextButton(
                onPressed: () {
                  player.setLooping(true);
                },
                child: const Text('setLooping true'),
              ),
              TextButton(
                onPressed: () {
                  player.setLooping(false);
                },
                child: const Text('setLooping false'),
              ),
              TextButton(
                onPressed: () {
                  player.setPlaybackSpeed(1.0);
                },
                child: const Text('setPlaybackSpeed 1.0'),
              ),
              TextButton(
                onPressed: () {
                  player.setPlaybackSpeed(0.5);
                },
                child: const Text('setPlaybackSpeed 0.5'),
              ),
              TextButton(
                onPressed: () {
                  player.setPlaybackSpeed(2.0);
                },
                child: const Text('setPlaybackSpeed 2.0'),
              ),
              TextButton(
                onPressed: () {
                  player.setVolume(1.0);
                },
                child: const Text('setVolume 1.0'),
              ),
              TextButton(
                onPressed: () {
                  player.setVolume(0.8);
                },
                child: const Text('setVolume 0.8'),
              ),
              TextButton(
                onPressed: () {
                  player.setVolume(0.6);
                },
                child: const Text('setVolume 0.6'),
              ),
              TextButton(
                onPressed: () {
                  player.setVolume(0.0);
                },
                child: const Text('setVolume 0.0'),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Text('initial state:'),
          Wrap(
              spacing: 30,
              runSpacing: 10,
              alignment: WrapAlignment.start,
              children: [
                Text('position: ${player.position}'),
                Text('duration: ${player.duration}'),
                Text('aspectRatio: ${player.aspectRatio}'),
                Text('isPlaying: ${player.isPlaying}'),
                
                Text('playbackSpeed: ${player.playbackSpeed}'),
                Text('size: ${player.size}'),
                Text('volume: ${player.volume}'),

                Text('errorMessage: ${player.errorMessage}'),
                Text('hasError: ${player.hasError}'),

                Text('isBuffering: ${player.isBuffering}'),
                Text('isInitialized: ${player.isInitialized}'),
                Text('isLooping: ${player.isLooping}'),
              ],
          ),
          const SizedBox(height: 30),
          const Text('real-time state:'),
          ChangeNotifierBuilder(
            notifier: player.eventStream,
            builder: (context) {
              return Wrap(
                spacing: 30,
                runSpacing: 10,
                children: [
                  Text('position: ${player.position}'),
                  Text('duration: ${player.duration}'),
                  Text('aspectRatio: ${player.aspectRatio}'),
                  Text('isPlaying: ${player.isPlaying}'),
                  
                  Text('playbackSpeed: ${player.playbackSpeed}'),
                  Text('size: ${player.size}'),
                  Text('volume: ${player.volume}'),

                  Text('errorMessage: ${player.errorMessage}'),
                  Text('hasError: ${player.hasError}'),

                  Text('isBuffering: ${player.isBuffering}'),
                  Text('isInitialized: ${player.isInitialized}'),
                  Text('isLooping: ${player.isLooping}'),
                ],
              );
            }
          )
          
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
```
