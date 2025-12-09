import 'package:flutter/material.dart';
import 'package:khan_share_mobile_app/config/appColors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Dummy Data - Removed "Chat" items
  List<Map<String, dynamic>> notifications = [
    {
      "id": 2,
      "title": "Book Request Accepted",
      "body": "The owner of '1984' has accepted your request.",
      "time": "2 mins ago",
      "isRead": false,
      "type": "success",
    },
    {
      "id": 3,
      "title": "New Book Near You",
      "body": "A new copy of 'Flutter Dev' was just listed 1.2km away.",
      "time": "1 hour ago",
      "isRead": false,
      "type": "alert",
    },
    {
      "id": 4,
      "title": "Donation Reminder",
      "body": "Thank you for donating 'The Great Gatsby'.",
      "time": "Yesterday",
      "isRead": true,
      "type": "info",
    },
    {
      "id": 6,
      "title": "Profile Update",
      "body": "Your profile picture was updated successfully.",
      "time": "3 days ago",
      "isRead": true,
      "type": "info",
    },
  ];

  void _markAllAsRead() {
    setState(() {
      for (var n in notifications) {
        n['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color.fromARGB(255, 255, 217, 103),
        content: Text(
          "All notifications marked as read",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: notifications.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _buildNotificationItem(notifications[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // --- HEADER ---
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: Colors.amber,
                radius: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Text(
                "Notifications",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  // Using white to contrast with background image
                  color: AppColor.textAppbar,
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.amber,
                radius: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.done_all,
                    color: Colors.white,
                    size: 20,
                  ),
                  tooltip: "Mark all as read",
                  onPressed: _markAllAsRead,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- NOTIFICATION ITEM ---
  Widget _buildNotificationItem(Map<String, dynamic> data) {
    bool isRead = data['isRead'];

    return InkWell(
      onTap: () {
        setState(() {
          data['isRead'] = true;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : const Color(0xFFFFFDE7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isRead ? Colors.grey.shade200 : const Color(0xFFFFF59D),
          ),
          boxShadow: isRead
              ? []
              : [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIcon(data['type']),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          data['title'],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isRead
                                ? FontWeight.w600
                                : FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Text(
                        data['time'],
                        style: TextStyle(
                          fontSize: 12,
                          color: isRead ? Colors.grey : Colors.amber[800],
                          fontWeight: isRead
                              ? FontWeight.normal
                              : FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data['body'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (!isRead)
              Container(
                margin: const EdgeInsets.only(left: 8, top: 5),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- ICON BUILDER (Removed Chat case) ---
  Widget _buildIcon(String type) {
    IconData icon;
    Color color;
    Color bg;

    switch (type) {
      case 'success':
        icon = Icons.check_circle_outline;
        color = Colors.green;
        bg = Colors.green.shade50;
        break;
      case 'alert':
        icon = Icons.notifications_active_outlined;
        color = Colors.orange;
        bg = Colors.orange.shade50;
        break;
      default:
        icon = Icons.info_outline;
        color = Colors.amber[800]!;
        bg = Colors.yellow.shade50;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(icon, color: color, size: 22),
    );
  }

  // --- EMPTY STATE ---
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.amber[100],
          ),
          const SizedBox(height: 16),
          const Text(
            "No Notifications Yet",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "We'll let you know when updates arrive.",
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
