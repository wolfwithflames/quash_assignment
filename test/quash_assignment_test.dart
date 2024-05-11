import 'package:flutter_test/flutter_test.dart';
import 'package:quash_assignment/quash_assignment.dart';
import 'package:quash_assignment/quash_assignment_platform_interface.dart';
import 'package:quash_assignment/quash_assignment_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockQuashAssignmentPlatform
    with MockPlatformInterfaceMixin
    implements QuashAssignmentPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final QuashAssignmentPlatform initialPlatform = QuashAssignmentPlatform.instance;

  test('$MethodChannelQuashAssignment is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelQuashAssignment>());
  });

  test('getPlatformVersion', () async {
    QuashAssignment quashAssignmentPlugin = QuashAssignment();
    MockQuashAssignmentPlatform fakePlatform = MockQuashAssignmentPlatform();
    QuashAssignmentPlatform.instance = fakePlatform;

    expect(await quashAssignmentPlugin.getPlatformVersion(), '42');
  });
}
