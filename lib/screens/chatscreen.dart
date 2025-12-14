import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String avatarUrl;

  const ChatScreen({super.key, required this.name, required this.avatarUrl});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {
      "message": "Hi! Is the Harry Potter book still available?",
      "isMe": false,
      "time": "10:30 AM",
    },
    {
      "message": "Yes! It is still available 🤩",
      "isMe": true,
      "time": "10:32 AM",
    },
    {
      "message": "Great! Can I pick it up this weekend?",
      "isMe": false,
      "time": "10:35 AM",
    },
    {
      "message":
          "Sure! Saturday afternoon works for me. Where would you like to meet?",
      "isMe": true,
      "time": "10:36 AM",
    },
    {
      "message": "How about near Olympic Stadium?",
      "isMe": false,
      "time": "10:40 AM",
    },
  ];

  @override
  Widget build(BuildContext context) {
    // ---------------- THEME DATA ----------------
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Dynamic Colors based on Theme
    final Color myMessageColor = Colors.amber; // Amber
    final Color myMessageText = Colors.black; // Text on Amber

    final Color otherMessageColor = theme.cardColor; // White or Dark Grey
    final Color otherMessageText = colors.onSurface; // Black or White

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.avatarUrl),
              backgroundColor: colors.surface,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Online",
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.amber),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // -------------------------------------
          // CHAT LIST
          // -------------------------------------
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final bool isMe = msg['isMe'];

                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isMe ? myMessageColor : otherMessageColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: isMe
                            ? const Radius.circular(12)
                            : Radius.zero,
                        bottomRight: isMe
                            ? Radius.zero
                            : const Radius.circular(12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          spreadRadius: 1,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['message'],
                          style: TextStyle(
                            color: isMe ? myMessageText : otherMessageText,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg['time'],
                          style: TextStyle(
                            // Slightly dim the time color
                            color: (isMe ? myMessageText : otherMessageText)
                                .withValues(alpha: 0.6),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // -------------------------------------
          // INPUT AREA
          // -------------------------------------
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: theme.cardColor, // Input bar background
                border: Border(
                  top: BorderSide(color: colors.outline.withValues(alpha: 0.1)),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.image_outlined,
                      color: colors.onSurface.withValues(alpha: 0.5),
                    ),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: TextStyle(color: colors.onSurface),
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: TextStyle(
                          color: colors.onSurface.withValues(alpha: 0.5),
                        ),
                        filled: true,
                        // Slightly differen shade for the input box itself
                        fillColor: isDark
                            ? Colors.grey.withValues(alpha: 0.1)
                            : const Color(0xFFF3F4F6),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.amber,
                    radius: 22,
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () {
                        if (_messageController.text.isNotEmpty) {
                          setState(() {
                            _messages.add({
                              "message": _messageController.text,
                              "isMe": true,
                              "time": "Now",
                            });
                            _messageController.clear();
                          });
                          Future.delayed(const Duration(milliseconds: 100), () {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
