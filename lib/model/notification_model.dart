class NotificationModel {
  final String id;
  final String recipientId;
  final String type;
  final String title;
  final String body;
  final String timestamp;
  final bool isRead;
  final Map<String, dynamic> data;

  NotificationModel({
    required this.id,
    required this.recipientId,
    required this.type,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.isRead,
    required this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      recipientId: json['recipient_id'],
      type: json['type'],
      title: json['title'],
      body: json['body'],
      timestamp: json['timestamp'],
      isRead: json['is_read'],
      data: json['data'],
    );
  }
}
