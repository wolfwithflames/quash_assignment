import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'quash_assignment_platform_interface.dart';

/// An implementation of [QuashAssignmentPlatform] that uses method channels.
class MethodChannelQuashAssignment extends QuashAssignmentPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('quash_assignment');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
