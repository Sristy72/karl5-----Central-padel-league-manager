import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';
import '../screens/playing_level_screen.dart';

class EnterController extends BaseController {
  /// Example action when user presses "Continue"
  Future<void> onContinue() async {
    Get.to(PlayingLevelScreen());
    setLoading(true);
  }
}
