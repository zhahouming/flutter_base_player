import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';
import 'package:ezplayer/ezplayer.dart';
import './asset.dart';
import './file.dart';
import './url.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EzPlayer.initialize();
  // Must add this line.
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await windowManager.ensureInitialized();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LauncherPage(),
    );
  }
}

class LauncherPage extends StatefulWidget {
  const LauncherPage({Key? key}) : super(key: key);

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 30),
          Wrap(spacing: 20, runSpacing: 10, children: [
            TextButton(
                onPressed: () async {
                  try {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();
                    if (result != null) {
                      File file = File(result.files.single.path!);
                      // ignore: use_build_context_synchronously
                      routerPush(
                        context,
                        (context) => SafeArea(child: FilePage(file: file)),
                      );
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
                  routerPush(
                    context,
                    (context) => const SafeArea(
                      child: UrlPage(
                        url: 'https://media.w3.org/2010/05/sintel/trailer.mp4',
                      ),
                    ),
                  );
                },
                child: const Text('load network')),
            TextButton(
                onPressed: () async {
                  routerPush(
                    context,
                    (context) => const SafeArea(
                      child: AssetPage(
                        asset: 'asset://assets/video/test.mp4',
                      ),
                    ),
                  );
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
                  routerPush(
                    context,
                    (context) => SafeArea(
                      child: UrlPage(
                        url: inputController.value.text.trim(),
                        headers: inputController2.value.text.trim(),
                      ),
                    ),
                  );
                },
                child: const Text('start load network'),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const SizedBox(height: 30),
          const Text(
            'test url list:',
            style: TextStyle(
              fontSize: 14,
              decoration: TextDecoration.none,
              // color: Colors.white38,
            ),
          ),
          ...urlist
              .map(
                (String url) => Row(
                  children: [
                    Text(
                      url,
                      style: const TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.none,
                        // color: Colors.white38,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        routerPush(
                          context,
                          (context) => SafeArea(
                            child: UrlPage(url: url),
                          ),
                        );
                      },
                      child: const Text('play'),
                    ),
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
    );
  }
}

routerPush(BuildContext context, Widget Function(BuildContext) builder) async {
  return Navigator.of(context).push(MaterialPageRoute(builder: builder));
}

routerPop(BuildContext context) {
  Navigator.of(context).pop();
}
