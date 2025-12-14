import 'package:khan_share_mobile_app/model/coordinates.dart';

class BookModel {
  final String id;
  final String ownerId;
  final String title;
  final String author;
  final String action;
  final String status;
  final String category;
  final String condition;
  final String language;
  final String description;

  final String distance;
  final String postedTime;

  final String ownerName;
  final String ownerImageUrl;
  final String image;

  final Coordinates location;

  BookModel({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.author,
    required this.action,
    required this.status,
    required this.category,
    required this.condition,
    required this.language,
    required this.description,
    required this.distance,
    required this.postedTime,
    required this.ownerName,
    required this.ownerImageUrl,
    required this.image,
    required this.location,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      ownerId: json['owner_id'],
      title: json['title'],
      author: json['author'],
      action: json['action'],
      status: json['status'],
      category: json['category'],
      condition: json['condition'],
      language: json['language'],
      description: json['description'],
      distance: json['distance'],
      postedTime: json['posted_time'],
      ownerName: json['owner_name'],
      ownerImageUrl: json['owner_image_url'],
      image: json['image'],
      location: Coordinates.fromJson(json['location']),
    );
  }
}
