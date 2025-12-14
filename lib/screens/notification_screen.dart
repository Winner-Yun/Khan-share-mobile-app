import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Dummy Data
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
      SnackBar(
        backgroundColor: Colors.amber,
        content: const Text(
          "All notifications marked as read",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ---------------- THEME DATA ----------------
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Dynamic Background
      body: Column(
        children: [
          _buildHeader(context, theme, colors, isDark),
          Expanded(
            child: notifications.isEmpty
                ? _buildEmptyState(colors)
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _buildNotificationItem(
                        notifications[index],
                        theme,
                        colors,
                        isDark,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // --- HEADER ---
  Widget _buildHeader(
    BuildContext context,
    ThemeData theme,
    ColorScheme colors,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        image: DecorationImage(
          image: const AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
          // Darken the image in dark mode for better text contrast
          opacity: isDark ? 0.3 : 1.0,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: Colors.amber, // Dynamic Amber
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
              Text(
                "Notifications",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  // Use dynamic appbar text color
                  color: theme.appBarTheme.foregroundColor,
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.amber, // Dynamic Amber
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
  Widget _buildNotificationItem(
    Map<String, dynamic> data,
    ThemeData theme,
    ColorScheme colors,
    bool isDark,
  ) {
    bool isRead = data['isRead'];

    // Define colors for Read/Unread states based on Theme
    final readBg = theme.cardColor;
    final unreadBg = isDark
        ? Colors.amber.withValues(alpha: 0.1) // Subtle Amber tint for dark mode
        : const Color(0xFFFFFDE7); // Yellowish tint for light mode

    final readBorder = isDark ? Colors.transparent : Colors.grey.shade200;
    final unreadBorder = isDark
        ? Colors.amber.withValues(alpha: 0.3)
        : const Color(0xFFFFF59D);

    return InkWell(
      onTap: () {
        setState(() {
          data['isRead'] = true;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead ? readBg : unreadBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isRead ? readBorder : unreadBorder),
          boxShadow: isRead
              ? []
              : [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIcon(data['type'], colors, isDark),
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
                            color: colors.onSurface, // Dynamic Text Color
                          ),
                        ),
                      ),
                      Text(
                        data['time'],
                        style: TextStyle(
                          fontSize: 12,
                          color: isRead
                              ? colors.onSurface.withValues(alpha: 0.5)
                              : colors.primary,
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
                      color: colors.onSurface.withValues(
                        alpha: 0.7,
                      ), // Slightly dimmer body text
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
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- ICON BUILDER ---
  Widget _buildIcon(String type, ColorScheme colors, bool isDark) {
    IconData icon;
    Color color;
    Color bg;

    // Use withValues alpha:  instead of .shade50 to look good on Dark Mode
    switch (type) {
      case 'success':
        icon = Icons.check_circle_outline;
        color = Colors.green;
        bg = Colors.green.withValues(alpha: isDark ? 0.2 : 0.1);
        break;
      case 'alert':
        icon = Icons.notifications_active_outlined;
        color = Colors.orange;
        bg = Colors.orange.withValues(alpha: isDark ? 0.2 : 0.1);
        break;
      default:
        icon = Icons.info_outline;
        color = colors.primary;
        bg = colors.primary.withValues(alpha: isDark ? 0.2 : 0.1);
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(icon, color: color, size: 22),
    );
  }

  // --- EMPTY STATE ---
  Widget _buildEmptyState(ColorScheme colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: colors.onSurface.withValues(
              alpha: 0.2,
            ), // Dynamic empty icon
          ),
          const SizedBox(height: 16),
          Text(
            "No Notifications Yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "We'll let you know when updates arrive.",
            style: TextStyle(color: colors.onSurface.withValues(alpha: 0.5)),
          ),
        ],
      ),
    );
  }
}
