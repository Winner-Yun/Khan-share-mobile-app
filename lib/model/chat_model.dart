class ChatModel {
  final String chatId;
  final String partnerId;
  final String partnerName;
  final String partnerImage;
  final String lastMessage;
  final String timestamp;
  final int unreadCount;
  final bool isOnline;
  final List<MessageModel> messages;

  ChatModel({
    required this.chatId,
    required this.partnerId,
    required this.partnerName,
    required this.partnerImage,
    required this.lastMessage,
    required this.timestamp,
    required this.unreadCount,
    required this.isOnline,
    required this.messages,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chatId: json['chat_id'],
      partnerId: json['partner_id'],
      partnerName: json['partner_name'],
      partnerImage: json['partner_image'],
      lastMessage: json['last_message'],
      timestamp: json['timestamp'],
      unreadCount: json['unread_count'],
      isOnline: json['is_online'],
      messages: (json['messages'] as List)
          .map((e) => MessageModel.fromJson(e))
          .toList(),
    );
  }
}

class MessageModel {
  final String senderId;
  final String text;
  final String time;

  MessageModel({
    required this.senderId,
    required this.text,
    required this.time,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: json['sender_id'],
      text: json['text'],
      time: json['time'],
    );
  }
}
