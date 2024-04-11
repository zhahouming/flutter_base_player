import 'package:flutter/material.dart';
import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:inode/inode.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int? ino;
  String? localpath;
  final _inodePlugin = Inode();

  @override
  void initState() {
    super.initState();
  }

  Future<void> getFileInode() async {
    if (localpath == null) return;
    try {
      ino = await _inodePlugin.getInode(localpath!);
    } catch (e, s) {
      print('$e, $s');
    }

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('path: $localpath'),
              const SizedBox(height: 10),
              Text('inode: $ino'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  setState(() {
                    localpath = result?.paths.first;
                  });
                  getFileInode();
                },
                child: const Text('pick file'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
