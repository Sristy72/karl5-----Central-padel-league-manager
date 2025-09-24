class CreateLeagueRequestModel {
  final String user;
  final String leagueName;
  final String description;
  final String startDate;
  final String endDate;
  final String location;
  final List<dynamic> addTeams;
  final int totalGameWeeks;
  final String type;
  final String matchFormat;
  final String tiebreakOption;
  final bool allowSubstitutes;

  CreateLeagueRequestModel({
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
  });

  Map<String, dynamic> toJson() => {
        'user': user,
        'leagueName': leagueName,
        'description': description,
        'startDate': startDate,
        'endDate': endDate,
        'location': location,
  'addTeams': addTeams,
        'totalGameWeeks': totalGameWeeks,
        'type': type,
        'matchFormat': matchFormat,
        'tiebreakOption': tiebreakOption,
        'allowSubstitutes': allowSubstitutes,
      };
}
