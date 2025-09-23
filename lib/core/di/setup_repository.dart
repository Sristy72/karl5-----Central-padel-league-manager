import 'package:get/get.dart';

import '../../features/auth/data/repo/auth_repo_impl.dart';
import '../../features/auth/domain/repo/auth_repo.dart';
import '../../features/home/data/home_repository.dart';
import '../../features/home/data/home_repository_impl.dart';
import '../../features/league/data/team_repository.dart';
import '../../features/league/data/team_repository_impl.dart';
import '../../features/league/data/league_repository.dart';
import '../../features/league/data/league_repository_impl.dart';

void setupRepository() {
  Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(apiClient: Get.find()));
  // Home repository used by HomeController and related features
  Get.lazyPut<HomeRepository>(() => HomeRepositoryImpl(apiClient: Get.find()));
  Get.lazyPut<LeagueRepository>(
    () => LeagueRepositoryImpl(apiClient: Get.find()),
  );
  // Team repository used by League features (delete team, etc.)
  Get.lazyPut<TeamRepository>(() => TeamRepositoryImpl( apiclient: Get.find()));
}
