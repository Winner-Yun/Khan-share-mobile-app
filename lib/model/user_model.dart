import 'package:khan_share_mobile_app/model/coordinates.dart';

class UserModel {
  final String userId;
  final String name;
  final String email;
  final String password;
  final String location;
  final String memberSince;
  final String profileImage;
  final String bio;
  final int points;

  final UserStats stats;
  final UserSettings settings;
  final Coordinates coordinates;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.password,
    required this.location,
    required this.memberSince,
    required this.profileImage,
    required this.bio,
    required this.points,
    required this.stats,
    required this.settings,
    required this.coordinates,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      location: json['location'],
      memberSince: json['member_since'],
      profileImage: json['profile_image'],
      bio: json['bio'],
      points: json['points'],
      stats: UserStats.fromJson(json['stats']),
      settings: UserSettings.fromJson(json['settings']),
      coordinates: Coordinates.fromJson(json['coordinates']),
    );
  }
}

class UserStats {
  final int donated;
  final int exchanged;
  final int borrowed;

  UserStats({
    required this.donated,
    required this.exchanged,
    required this.borrowed,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      donated: json['donated'],
      exchanged: json['exchanged'],
      borrowed: json['borrowed'],
    );
  }
}

class UserSettings {
  final String language;
  final bool notificationsEnabled;
  final bool darkModeEnabled;

  UserSettings({
    required this.language,
    required this.notificationsEnabled,
    required this.darkModeEnabled,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      language: json['language'],
      notificationsEnabled: json['notifications_enabled'],
      darkModeEnabled: json['dark_mode_enabled'],
    );
  }
}
