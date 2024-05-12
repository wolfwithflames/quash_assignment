import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'quash_assignment_method_channel.dart';

abstract class QuashAssignmentPlatform extends PlatformInterface {
  /// Constructs a QuashAssignmentPlatform.
  QuashAssignmentPlatform() : super(token: _token);

  static final Object _token = Object();

  static QuashAssignmentPlatform _instance = MethodChannelQuashAssignment();

  /// The default instance of [QuashAssignmentPlatform] to use.
  ///
  /// Defaults to [MethodChannelQuashAssignment].
  static QuashAssignmentPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [QuashAssignmentPlatform] when
  /// they register themselves.
  static set instance(QuashAssignmentPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> startRecording() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> handleScreenshot(Function(dynamic) callback) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
