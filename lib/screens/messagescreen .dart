import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khan_share_mobile_app/screens/chatscreen.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Access Theme Data
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Dynamic Background
      appBar: AppBar(
        title: Text(
          "Messages",
          style: GoogleFonts.poppins(
            // Use dynamic primary color
            color: Colors.amber,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover,
              opacity: isDark ? 0.2 : 0,
              // Lower opacity to blend better with themes
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSearchField(theme, colors),
          Expanded(child: _buildMessageList(theme, colors)),
        ],
      ),
    );
  }

  // ----------------------------------------
  // SEARCH FIELD
  // ----------------------------------------
  Widget _buildSearchField(ThemeData theme, ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: colors.onSurface), // Typing text color
        decoration: InputDecoration(
          hintText: "Search...",
          hintStyle: TextStyle(color: colors.onSurface.withValues(alpha: 0.5)),
          prefixIcon: Icon(
            Icons.search,
            color: colors.onSurface.withValues(alpha: 0.5),
          ),
          filled: true,
          // Dynamic fill color (White in Light, Dark Grey in Dark)
          fillColor: theme.cardColor,
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
  Widget _buildMessageList(ThemeData theme, ColorScheme colors) {
    return ListView(
      children: [
        _buildMessageItem(
          context: context,
          theme: theme,
          colors: colors,
          name: "Dara Sok",
          message: "Yes, the book is still available!",
          time: "2m ago",
          unreadCount: 2,
          avatarUrl: "https://randomuser.me/api/portraits/men/32.jpg",
          isOnline: true,
        ),

        // 2. KIMLY PRAK
        _buildMessageItem(
          context: context,
          theme: theme,
          colors: colors,
          name: "Kimly Prak",
          message: "Thank you so much for the book 🙏",
          time: "1h ago",
          unreadCount: 0,
          avatarUrl: "https://i.ibb.co/bWVKkHh/profile2.jpg",
          isOnline: false,
        ),

        // 3. SOPHEA CHEA
        _buildMessageItem(
          context: context,
          theme: theme,
          colors: colors,
          name: "Sophea Chea",
          message: "Can we meet tomorrow at 2pm?",
          time: "3h ago",
          unreadCount: 1,
          avatarUrl: "https://randomuser.me/api/portraits/men/55.jpg",
          isOnline: true,
        ),
      ],
    );
  }

  // ----------------------------------------
  // A SINGLE MESSAGE ROW
  // ----------------------------------------
  Widget _buildMessageItem({
    required BuildContext context,
    required ThemeData theme,
    required ColorScheme colors,
    required String name,
    required String message,
    required String time,
    required int unreadCount,
    required bool isOnline,
    String? avatarUrl,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ChatScreen(name: name, avatarUrl: avatarUrl ?? ""),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: colors.surface,
                  backgroundImage: avatarUrl != null
                      ? NetworkImage(avatarUrl)
                      : null,
                  child: avatarUrl == null
                      ? Icon(
                          Icons.image_not_supported,
                          size: 28,
                          color: colors.onSurface,
                        )
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
                        border: Border.all(
                          color: theme
                              .scaffoldBackgroundColor, // Match background for cutoff effect
                          width: 2,
                        ),
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: colors.onSurface, // Dynamic Name Color
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      // Lighter text for message preview
                      color: colors.onSurface.withValues(alpha: 0.6),
                    ),
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
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                if (unreadCount > 0)
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.amber, // Use dynamic Amber color
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Text(
                        unreadCount.toString(),
                        style: const TextStyle(
                          color:
                              Colors.white, // Text inside badge is always white
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
