import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'inode_method_channel.dart';

abstract class InodePlatform extends PlatformInterface {
  /// Constructs a InodePlatform.
  InodePlatform() : super(token: _token);

  static final Object _token = Object();

  static InodePlatform _instance = MethodChannelInode();

  /// The default instance of [InodePlatform] to use.
  ///
  /// Defaults to [MethodChannelInode].
  static InodePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [InodePlatform] when
  /// they register themselves.
  static set instance(InodePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<int?> getInode(String path) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
