class Team {
  String id;
  String user;
  String teamName;
  String captainName;
  String partnerName;
  String playerLevels;
  String email;
  String contactNumber;
  String logoPhotoUrl;
  String league;
  bool agreedToRules;
  bool confirmedAvailability;
  String applicationStatus;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Team({
    required this.id,
    required this.user,
    required this.teamName,
    required this.captainName,
    required this.partnerName,
    required this.playerLevels,
    required this.email,
    required this.contactNumber,
    required this.logoPhotoUrl,
    required this.league,
    required this.agreedToRules,
    required this.confirmedAvailability,
    required this.applicationStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['_id'],
      user: json['user'],
      teamName: json['teamName'],
      captainName: json['captainName'],
      partnerName: json['partnerName'],
      playerLevels: json['playerLevels'],
      email: json['email'],
      contactNumber: json['contactNumber'],
      logoPhotoUrl: json['logoPhotoUrl'],
      league: json['league'],
      agreedToRules: json['agreedToRules'],
      confirmedAvailability: json['confirmedAvailability'],
      applicationStatus: json['applicationStatus'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'teamName': teamName,
      'captainName': captainName,
      'partnerName': partnerName,
      'playerLevels': playerLevels,
      'email': email,
      'contactNumber': contactNumber,
      'logoPhotoUrl': logoPhotoUrl,
      'league': league,
      'agreedToRules': agreedToRules,
      'confirmedAvailability': confirmedAvailability,
      'applicationStatus': applicationStatus,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}
