class LeagueModel {
  final String id;
  final String user;
  final String leagueName;
  final String description;
  final String? leagueCode;
  final String? leagueLogo;
  final DateTime? startDate;
  final DateTime? endDate;
  final String location;
  final List<String> addTeams;
  final String type;
  final String matchFormat;
  final String tiebreakOption;
  final bool allowSubstitutes;
  final String? price;

  LeagueModel({
    required this.id,
    required this.user,
    required this.leagueName,
    required this.description,
    this.leagueCode,
    this.leagueLogo,
    this.startDate,
    this.endDate,
    required this.location,
    required this.addTeams,
    required this.type,
    required this.matchFormat,
    required this.tiebreakOption,
    required this.allowSubstitutes,
    this.price,
  });

  factory LeagueModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      try {
        return DateTime.parse(v as String);
      } catch (_) {
        return null;
      }
    }

    final userVal = json['user']; // Could be String or Map

    // Handle user field being either String ID or Map Object
    String userId = '';
    if (userVal is String) {
      userId = userVal;
    } else if (userVal is Map) {
      userId = userVal['_id']?.toString() ?? '';
    }

    return LeagueModel(
      id: json['_id'] as String? ?? '',
      user: userId,
      leagueName: json['leagueName'] as String? ?? '',
      description: json['description'] as String? ?? '',
      leagueCode: json['leagueCode'] as String?,
      leagueLogo: json['leagueLogo'] as String?,
      startDate: parseDate(json['startDate']),
      endDate: parseDate(json['endDate']),
      location: json['location'] as String? ?? '',
      addTeams:
          (json['addTeams'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      type: json['type'] as String? ?? '',
      matchFormat: json['matchFormat'] as String? ?? '',
      tiebreakOption: json['tiebreakOption'] as String? ?? '',
      allowSubstitutes: json['allowSubstitutes'] as bool? ?? false,
      price: json['price']?.toString(),
    );
  }
}
