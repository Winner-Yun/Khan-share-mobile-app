import 'package:khan_share_mobile_app/model/book_model.dart';
import 'package:khan_share_mobile_app/model/chat_model.dart';
import 'package:khan_share_mobile_app/model/notification_model.dart';
import 'package:khan_share_mobile_app/model/user_model.dart';

class AppDatabase {
  final String databaseVersion;
  final String generatedAt;
  final List<UserModel> users;
  final List<BookModel> books;
  final List<ChatModel> chats;
  final List<NotificationModel> notifications;

  AppDatabase({
    required this.databaseVersion,
    required this.generatedAt,
    required this.users,
    required this.books,
    required this.chats,
    required this.notifications,
  });

  factory AppDatabase.fromJson(Map<String, dynamic> json) {
    return AppDatabase(
      databaseVersion: json['database_version'],
      generatedAt: json['generated_at'],
      users: (json['users'] as List).map((e) => UserModel.fromJson(e)).toList(),
      books: (json['books'] as List).map((e) => BookModel.fromJson(e)).toList(),
      chats: (json['chats'] as List).map((e) => ChatModel.fromJson(e)).toList(),
      notifications: (json['notifications'] as List)
          .map((e) => NotificationModel.fromJson(e))
          .toList(),
    );
  }
}
