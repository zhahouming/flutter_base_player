import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_player/flutter_base_player.dart';
import 'package:file_picker/file_picker.dart';

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
      // showPerformanceOverlay: true,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LauncherPage(),
    );
  }
}

class LauncherPage extends StatelessWidget {
  const LauncherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) =>
                      const MyHomePage(title: 'Flutter Demo Home Page')),
            );
          },
          child: const Text('jump'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const MyHomePagePure(
                      title: 'Flutter Demo Home Page Pure')),
            );
          },
          child: const Text('jump pure'),
        )
      ],
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
  FlutterBasePlayer player2 = FlutterBasePlayer();

  BoxFit fit = BoxFit.contain;
  double ratio = 4 / 3;
  String inputUrl = '';
  String inputHeaders = '';
  TextEditingController inputController = TextEditingController();
  TextEditingController inputController2 = TextEditingController();

  List<String> urlist = [
    'http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4',
    'http://vjs.zencdn.net/v/oceans.mp4',
    'https://www.w3school.com.cn/i/movie.mp4',
    'https://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4',
    'https://media.w3.org/2010/05/sintel/trailer.mp4',
    'rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mov',
    'http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8',
    'http://devimages.apple.com/iphone/samples/bipbop/gear3/prog_index.m3u8',
    'http://220.161.87.62:8800/hls/0/index.m3u8',
    'rtmp://mobliestream.c3tv.com:554/live/goodtv.sdp',
    'rtmp://media3.scctv.net/live/scctv_800',
  ];

  @override
  void initState() {
    Future.microtask(() async {
      await player2.loadNetwork(
        'http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4',
        logLevel: LogLevel.info,
      );
      player2.play();
      player2.setLooping(true);
    });

    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    player2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          Container(
            height: 300,
            width: 200,
            child: player2.builder(context, fit: fit),
          ),
          player.builder(context, fit: fit, ratio: 16 / 9, color: Colors.white),
          ChangeNotifierBuilder(
              notifier: player.eventStream,
              builder: (context) {
                return Wrap(
                  spacing: 30,
                  runSpacing: 10,
                  children: [
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
                    Text('duration: ${player.duration}'),
                    Text('position: ${player.position}'),
                  ],
                );
              }),
          const SizedBox(height: 30),
          Wrap(spacing: 20, runSpacing: 10, children: [
            TextButton(
                onPressed: () async {
                  try {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();
                    if (result != null) {
                      File file = File(result.files.single.path!);
                      await player.loadFile(file);
                      player.play();
                    } else {
                      // User canceled the picker
                    }
                  } catch (err) {
                    print('error' + err.toString());
                  }
                },
                child: const Text('load file')),
            TextButton(
                onPressed: () async {
                  await player.loadNetwork(
                      'https://media.w3.org/2010/05/sintel/trailer.mp4');
                  player.play();
                },
                child: const Text('load network')),
            TextButton(
                onPressed: () async {
                  await player.loadAssets('asset://assets/video/test.mp4');
                  player.play();
                },
                child: const Text('load assets')),
          ]),
          const SizedBox(height: 30),
          Wrap(
            spacing: 20,
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'audio/video url',
                ),
                controller: inputController,
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'audio/video headers',
                ),
                controller: inputController2,
              ),
              TextButton(
                onPressed: () async {
                  await player.loadNetwork(
                    inputController.value.text.trim(),
                    // inputController2.value.text.trim(),
                  );
                  player.play();
                },
                child: const Text('start load network'),
              ),
            ],
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
                  player
                      .seek(Duration(seconds: player.position.inSeconds + 10));
                },
                child: const Text('seek +10s'),
              ),
              TextButton(
                onPressed: () {
                  player
                      .seek(Duration(seconds: player.position.inSeconds + 60));
                },
                child: const Text('seek +60s'),
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
          const Text('video tracks:'),
          ChangeNotifierBuilder(
              notifier: player.eventStream,
              builder: (context) {
                return Wrap(
                    children: player.videoTracks
                        .map((BaseTrack? track) => TextButton(
                            onPressed: () {
                              player.setVideoTrack(track!);
                            },
                            child: Text(
                                '${track?.title} - ${track?.language ?? ''}')))
                        .toList());
              }),
          const SizedBox(height: 30),
          const Text('audio tracks:'),
          ChangeNotifierBuilder(
              notifier: player.eventStream,
              builder: (context) {
                return Wrap(
                    children: player.audioTracks
                        .map((BaseTrack? track) => TextButton(
                            onPressed: () {
                              player.setAudioTrack(track!);
                            },
                            child: Text(
                                '${track?.title} - ${track?.language ?? ''}')))
                        .toList());
              }),
          const SizedBox(height: 30),
          const Text('subtitle tracks:'),
          ChangeNotifierBuilder(
              notifier: player.eventStream,
              builder: (context) {
                return Wrap(
                    children: player.subtitleTracks
                        .map((BaseTrack? track) => TextButton(
                            onPressed: () {
                              player.setSubtitleTrack(track!);
                            },
                            child: Text(
                                '${track?.title} - ${track?.language ?? ''}')))
                        .toList());
              }),
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
          const Text('test url list:'),
          ...urlist
              .map(
                (String url) => Row(
                  children: [
                    Text(url),
                    TextButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: url));
                      },
                      child: const Text('copy'),
                    ),
                  ],
                ),
              )
              .toList(),
          const SizedBox(height: 30),
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

class MyHomePagePure extends StatefulWidget {
  const MyHomePagePure({super.key, required this.title});

  final String title;

  @override
  State<MyHomePagePure> createState() => _MyHomePagePureState();
}

class _MyHomePagePureState extends State<MyHomePagePure> {
  FlutterBasePlayer player = FlutterBasePlayer();
  FlutterBasePlayer player2 = FlutterBasePlayer();

  BoxFit fit = BoxFit.contain;
  double ratio = 4 / 3;
  String inputUrl = '';
  String inputHeaders = '';
  TextEditingController inputController = TextEditingController();
  TextEditingController inputController2 = TextEditingController();

  @override
  void initState() {
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
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          player.builder(context),
          const SizedBox(height: 30),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: [
              TextButton(
                  onPressed: () async {
                    try {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();
                      if (result != null) {
                        File file = File(result.files.single.path!);
                        await player.loadFile(file);
                        player.play();
                      } else {
                        // User canceled the picker
                      }
                    } catch (err) {
                      print('error' + err.toString());
                    }
                  },
                  child: const Text('load file')),
              TextButton(onPressed: player.play, child: const Text('play')),
              TextButton(onPressed: player.pause, child: const Text('pause')),
              TextButton(
                onPressed: () {
                  player
                      .seek(Duration(seconds: player.position.inSeconds + 10));
                },
                child: const Text('seek +10s'),
              ),
              TextButton(
                onPressed: () {
                  player
                      .seek(Duration(seconds: player.position.inSeconds + 60));
                },
                child: const Text('seek +60s'),
              ),
              TextButton(
                onPressed: () {
                  player.setPlaybackSpeed(1.0);
                },
                child: const Text('setPlaybackSpeed 1.0'),
              ),
              TextButton(
                onPressed: () {
                  player.setPlaybackSpeed(2.0);
                },
                child: const Text('setPlaybackSpeed 2.0'),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
