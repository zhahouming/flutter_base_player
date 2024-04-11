import 'package:flutter_test/flutter_test.dart';
import 'package:inode/inode_platform_interface.dart';
import 'package:inode/inode_method_channel.dart';

void main() {
  final InodePlatform initialPlatform = InodePlatform.instance;

  test('$MethodChannelInode is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelInode>());
  });

  test('getPlatformVersion', () async {});
}
