class CreateLeagueRequestModel {
  final String user;
  final String leagueName;
  final String description;
  final String startDate;
  final String location;
  final String? price;
  final int totalGameWeeks;
  final String type;
  final String matchFormat;
  final String tiebreakOption;
  final bool allowSubstitutes;
  final String matchPlay;
  final String leagueType;

  CreateLeagueRequestModel({
    required this.user,
    required this.leagueName,
    required this.description,
    required this.startDate,
    required this.location,
    required this.totalGameWeeks,
    required this.type,
    required this.matchFormat,
    required this.tiebreakOption,
    required this.allowSubstitutes,
    required this.price,
    required this.matchPlay,
    required this.leagueType,
  });

  Map<String, dynamic> toJson() => {
    'leagueName': leagueName,
    'description': description,
    'startDate': startDate,
    'location': location,
    'totalGameWeeks': totalGameWeeks,
    'type': type,
    'matchFormat': matchFormat,
    'tiebreakOption': tiebreakOption,
    'allowSubstitutes': allowSubstitutes,
    'matchPlay': matchPlay,
    'leagueType': leagueType,
    if (price != null && price!.isNotEmpty) 'price': price,
  };
}
