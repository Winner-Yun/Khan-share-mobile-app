import 'package:flutter/material.dart';
import 'package:khan_share_mobile_app/config/appColors.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text(
          "Messages",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColor.textAppbar,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/background.jpg",
              ), // your image path
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSearchField(),
          Expanded(child: _buildMessageList()),
        ],
      ),
    );
  }

  // ----------------------------------------
  // SEARCH FIELD
  // ----------------------------------------
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey.shade200,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // ----------------------------------------
  // MESSAGE LIST
  // ----------------------------------------
  Widget _buildMessageList() {
    return ListView(
      children: [
        _buildMessageItem(
          name: "Dara Sok",
          message: "Yes, the book is still available!",
          time: "2m ago",
          unreadCount: 2,
          avatarUrl:
              "https://randomuser.me/api/portraits/men/32.jpg", // USE ANY IMAGE YOU WANT
          isOnline: true,
        ),
        _buildMessageItem(
          name: "Kimly Prak",
          message: "Thank you so much for the book 🙏",
          time: "1h ago",
          unreadCount: 0,
          avatarUrl: "https://i.ibb.co/bWVKkHh/profile2.jpg", // USE ANY IMAGE
          isOnline: false,
        ),
        _buildMessageItem(
          name: "Sophea Chea",
          message: "Can we meet tomorrow at 2pm?",
          time: "3h ago",
          unreadCount: 1,
          avatarUrl:
              "https://randomuser.me/api/portraits/men/55.jpg", // testing broken image
          isOnline: true,
        ),
      ],
    );
  }

  // ----------------------------------------
  // A SINGLE MESSAGE ROW
  // ----------------------------------------
  Widget _buildMessageItem({
    required String name,
    required String message,
    required String time,
    required int unreadCount,
    required bool isOnline,
    String? avatarUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: avatarUrl != null
                    ? NetworkImage(avatarUrl)
                    : null,
                child: avatarUrl == null
                    ? const Icon(Icons.image_not_supported, size: 28)
                    : null,
              ),
              if (isOnline)
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),

          // Text Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),

          // Time + unread badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              const SizedBox(height: 6),
              if (unreadCount > 0)
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
