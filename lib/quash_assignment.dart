
import 'quash_assignment_platform_interface.dart';
export 'dio_logger.dart';

class QuashAssignment {
  Future<String?> getPlatformVersion() {
    return QuashAssignmentPlatform.instance.getPlatformVersion();
  }
}
