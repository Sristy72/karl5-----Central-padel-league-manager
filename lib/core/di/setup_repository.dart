import 'package:flutter_karlfive223_manager/features/join_league/domain/repo/team_repo.dart';
import 'package:flutter_karlfive223_manager/features/league/models/league_model.dart';
import 'package:get/get.dart';

import '../../features/auth/data/repo/auth_repo_impl.dart';
import '../../features/auth/domain/repo/auth_repo.dart';
import '../../features/home/data/home_repository.dart';
import '../../features/home/data/home_repository_impl.dart';
import '../../features/join_league/data/repositories/join_league/join_league.dart';
import '../../features/league/data/league_repository.dart';
import '../../features/league/data/league_repository_impl.dart';
import '../../features/Create_league/data/create_league_repository.dart';
import '../../features/Create_league/data/create_league_repository_impl.dart';

void setupRepository() {
  Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(apiClient: Get.find()));
  // Home repository used by HomeController and related features
  Get.lazyPut<HomeRepository>(() => HomeRepositoryImpl(apiClient: Get.find()));
  Get.lazyPut<LeagueRepository>(
    () => LeagueRepositoryImpl(apiClient: Get.find()),
  );
  // Create League repository
  Get.lazyPut<CreateLeagueRepository>(
    () => CreateLeagueRepositoryImpl(apiClient: Get.find()),
  );
  Get.lazyPut<JoinLeagueRepository>(
    () => JoinLeagueRepositoryImpl(apiClient: Get.find()),
  );
}
