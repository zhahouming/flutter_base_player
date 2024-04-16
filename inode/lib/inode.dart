import 'dart:io';

import 'inode_platform_interface.dart';

class Inode {
  Future<int?> getInode(String path) async {
    var file = File(path);
    if (!file.existsSync()) {
      return null;
    }
    return InodePlatform.instance.getInode(path);
  }
}
