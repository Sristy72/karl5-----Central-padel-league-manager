import 'team_model.dart';
import 'user_model.dart';

class League {
  String id;
  User user;
  String leagueName;
  String description;
  DateTime startDate;
  DateTime endDate;
  String location;
  List<Team> addTeams;
  int totalGameWeeks;
  String type;
  String matchFormat;
  String tiebreakOption;
  bool allowSubstitutes;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  League({
    required this.id,
    required this.user,
    required this.leagueName,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.addTeams,
    required this.totalGameWeeks,
    required this.type,
    required this.matchFormat,
    required this.tiebreakOption,
    required this.allowSubstitutes,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['_id'],
      user: User.fromJson(json['user']),
      leagueName: json['leagueName'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      location: json['location'],
      addTeams: (json['addTeams'] as List)
          .map((e) => Team.fromJson(e))
          .toList(),
      totalGameWeeks: json['totalGameWeeks'],
      type: json['type'],
      matchFormat: json['matchFormat'],
      tiebreakOption: json['tiebreakOption'],
      allowSubstitutes: json['allowSubstitutes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user.toJson(),
      'leagueName': leagueName,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'location': location,
      'addTeams': addTeams.map((team) => team.toJson()).toList(),
      'totalGameWeeks': totalGameWeeks,
      'type': type,
      'matchFormat': matchFormat,
      'tiebreakOption': tiebreakOption,
      'allowSubstitutes': allowSubstitutes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}
