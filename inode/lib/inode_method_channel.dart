import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'inode_platform_interface.dart';

/// An implementation of [InodePlatform] that uses method channels.
class MethodChannelInode extends InodePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('inode');

  @override
  Future<int?> getInode(String path) async {
    final ino = await methodChannel.invokeMethod<int>('getInode', path);
    return ino;
  }
}
