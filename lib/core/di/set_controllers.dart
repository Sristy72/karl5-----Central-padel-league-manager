import 'package:get/get.dart';
import '../../features/auth/presentation/controller/auth_controller.dart';
import '../../features/league/presentation/controllers/league_controller.dart';
import '../../features/home/controller/home_controller.dart';
import '../../features/home/data/home_repository.dart';

void setupController() {
  // Auth Controller
  Get.lazyPut<AuthController>(() => AuthController(Get.find(), Get.find()));
  Get.lazyPut<LeagueController>(() => LeagueController(repository: Get.find()));
  // Home controller depends on HomeRepository
  Get.lazyPut<HomeController>(
    () => HomeController(repository: Get.find<HomeRepository>()),
  );
}
