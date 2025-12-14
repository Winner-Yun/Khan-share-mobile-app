import 'package:flutter/material.dart';

class BookDetailScreen extends StatefulWidget {
  // We pass the book data from the Map Screen
  final Map<String, dynamic> book;

  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  // State variable to handle the "Favorite" heart toggle
  bool isLiked = false;

  // --- HELPER: GET COLOR BASED ON ACTION ---
  Color _getActionColor(String action) {
    switch (action) {
      case 'Donation':
      case 'Donate':
        return Colors.green;
      case 'Borrow':
        return Colors.deepPurple;
      case 'Exchange':
        return Colors.orange;
      default:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ---------------- THEME DATA ----------------
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Extract dynamic data
    String action = widget.book['action'] ?? 'Available';
    Color actionColor = _getActionColor(action);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Dynamic Background
      // 1. APP BAR
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Book Details",
          style: TextStyle(
            color: colors.onSurface, // Dynamic Text
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          // Favorite Heart Button
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked
                  ? Colors.red
                  : colors.onSurface.withValues(alpha: 0.6),
            ),
            onPressed: () {
              setState(() {
                isLiked = !isLiked;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.share_outlined, color: colors.onSurface),
            onPressed: () {},
          ),
        ],
      ),

      // 2. BODY CONTENT
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Image
              Center(
                child: Hero(
                  tag: widget.book['id'] ?? widget.book['title'],
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      widget.book['image'],
                      height: 400,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 320,
                        width: double.infinity,
                        color: theme.cardColor, // Dynamic Placeholder
                        child: Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 50,
                            color: colors.onSurface.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Action Badge (Dynamic)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: actionColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: actionColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  action,
                  style: TextStyle(
                    color: actionColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                widget.book['title'],
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface, // Dynamic Text
                ),
              ),
              const SizedBox(height: 8),

              // Author (Pill)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: theme.cardColor, // Dynamic Background
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: colors.outline.withValues(alpha: 0.1),
                  ),
                ),
                child: Text(
                  widget.book['author'],
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Location Row
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: colors.onSurface.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Phnom Penh",
                    style: TextStyle(
                      color: colors.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.onSurface.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colors.onSurface.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.book['distance'] ?? "N/A",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Owner Info Row
              if (widget.book.containsKey('user')) ...[
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: theme.cardColor,
                      backgroundImage: widget.book['owner_image_url'] != null
                          ? NetworkImage(widget.book['owner_image_url'])
                          : null,
                      child: widget.book['owner_image_url'] == null
                          ? Icon(Icons.person, color: colors.onSurface)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.book['user'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: colors.onSurface,
                          ),
                        ),
                        Text(
                          widget.book['days_ago'] ?? 'Recently',
                          style: TextStyle(
                            color: colors.onSurface.withValues(alpha: 0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 25),
              ],

              // Details Card (Condition, Category, Language)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor, // White in Light, Dark Grey in Dark
                  borderRadius: BorderRadius.circular(12),
                  // Slight border for better separation in dark mode
                  border: Border.all(
                    color: colors.outline.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  children: [
                    _buildDetailRow("Condition", "Very Good", colors),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      "Category",
                      widget.book['category'] ?? "General",
                      colors,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow("Language", "English", colors),
                  ],
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      // 3. BOTTOM BUTTONS (Chat & Request)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor, // Dynamic Background
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Chat Button
              Expanded(
                flex: 1,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.chat_bubble_outline,
                    color: colors.onSurface,
                  ),
                  label: Text(
                    "Chat",
                    style: TextStyle(color: colors.onSurface),
                  ),
                  style: ElevatedButton.styleFrom(
                    // Subtle background for Chat button
                    backgroundColor: isDark
                        ? colors.onSurface.withValues(alpha: 0.1)
                        : Colors.grey[100],
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Request Book Button
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Request sent for $action!"),
                        backgroundColor: actionColor,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: actionColor, // Dynamic Action Color
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Request $action",
                    style: const TextStyle(
                      color:
                          Colors.white, // Always White text on action buttons
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for the detail rows
  Widget _buildDetailRow(String label, String value, ColorScheme colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.onSurface.withValues(alpha: 0.6),
            fontSize: 15,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: colors.onSurface, // Dynamic Value Color
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
