// Controller using GetX
import 'package:get/get.dart';

class CreateLeagueFormController extends GetxController {
  var teamList = <Map<String, String>>[].obs;

  void addTeam() {
    teamList.add({"name": "", "contact": ""});
  }

  void removeTeam(int index) {
    if (teamList.isNotEmpty) teamList.removeAt(index);
  }
}