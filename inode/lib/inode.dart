import 'inode_platform_interface.dart';

class Inode {
  Future<int?> getInode(String path) {
    return InodePlatform.instance.getInode(path);
  }
}
