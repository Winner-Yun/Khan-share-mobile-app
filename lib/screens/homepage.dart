import 'package:flutter/material.dart';
import 'package:khan_share_mobile_app/screens/notification_screen.dart';

// ---------------------------------------------------------------------------

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  @override
  Widget build(BuildContext context) {
    return const BookShareScreen();
  }
}

class BookShareScreen extends StatefulWidget {
  const BookShareScreen({super.key});

  @override
  State<BookShareScreen> createState() => _BookShareScreenState();
}

class _BookShareScreenState extends State<BookShareScreen> {
  // 1. State Variables for Search and Tabs
  int _selectedTabIndex = 0;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  final List<String> _tabs = ['All Books', 'Donate', 'Exchange', 'Borrow'];

  // 2. Data Source
  final List<Map<String, dynamic>> _allBooks = [
    {
      'title': 'Pride and Prejudice',
      'author': 'Jane Austen',
      'action': 'Donation',
      'distance': '4.1 km',
      'category': 'History',
      'readers': '4 previous readers',
      'days_ago': '1 day ago',
      'user': 'Piseth Tan',
      'image_url':
          'https://m.media-amazon.com/images/I/81OthjkJBuL._AC_UF1000,1000_QL80_.jpg',
      'owner_image_url': 'https://randomuser.me/api/portraits/men/32.jpg',
    },
    {
      'title': 'The Catcher in the Rye',
      'author': 'J.D. Salinger',
      'action': 'Exchange',
      'distance': '5.3 km',
      'category': 'Comedy',
      'readers': null,
      'days_ago': '2 days ago',
      'user': 'Srey Mom',
      'image_url':
          'https://m.media-amazon.com/images/I/71QKQ9mwV7L._AC_UF1000,1000_QL80_.jpg',
      'owner_image_url': 'https://randomuser.me/api/portraits/women/44.jpg',
    },
    {
      'title': "Harry Potter and the Philosopher's Stone",
      'author': 'J.K. Rowling',
      'action': 'Borrow',
      'distance': '0.9 km',
      'category': 'History',
      'readers': '6 previous readers',
      'days_ago': '3 days ago',
      'user': 'Sokha Chan',
      'image_url':
          'https://m.media-amazon.com/images/I/81iqZ2HHD-L._AC_UF1000,1000_QL80_.jpg',
      'owner_image_url': 'https://randomuser.me/api/portraits/men/55.jpg',
    },
  ];

  // 3. Filtering Logic
  List<Map<String, dynamic>> get _filteredBooks {
    return _allBooks.where((book) {
      // Filter by Tab
      bool matchesTab = true;
      if (_selectedTabIndex == 1) matchesTab = book['action'] == 'Donation';
      if (_selectedTabIndex == 2) matchesTab = book['action'] == 'Exchange';
      if (_selectedTabIndex == 3) matchesTab = book['action'] == 'Borrow';

      // Filter by Search Text
      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();

        final title = book['title'].toLowerCase();
        final author = book['author'].toLowerCase();
        final category = book['category'].toString().toLowerCase();

        matchesSearch =
            title.contains(query) ||
            author.contains(query) ||
            category.contains(query);
      }

      return matchesTab && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access Theme Data
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Dynamic background
      body: Column(
        children: <Widget>[
          _buildHeaderAndSearch(context, theme, colors),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: _buildTabBar(theme, colors),
          ),
          Expanded(child: _buildBookList(theme, colors)),
        ],
      ),
    );
  }

  // ---------------- HEADER + SEARCH ----------------
  Widget _buildHeaderAndSearch(
    BuildContext context,
    ThemeData theme,
    ColorScheme colors,
  ) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 0, 0, 0),
        image: DecorationImage(
          image: AssetImage("assets/images/background.jpg"),
          fit: BoxFit.cover,
          opacity: 0.9,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      // Using Icon as fallback if asset missing
                      Image.asset(
                        'assets/icons/logokhanshare2.png',
                        width: 20,
                        fit: BoxFit.cover,
                        errorBuilder: (c, o, s) =>
                            Icon(Icons.book, color: Colors.amber, size: 20),
                      ),
                      Text(
                        "Khan Share",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          // Use theme's appbar foreground (usually amber/gold in your theme)
                          color: const Color.fromARGB(255, 189, 142, 0),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.amber, // Dynamic primary color
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Icon(
                            Icons.notifications,
                            color: Colors.white, // Contrast icon color
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Location
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: const Color.fromARGB(255, 189, 142, 0),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Phnom Penh",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 189, 142, 0),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Search Bar
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                style: TextStyle(color: colors.onSurface), // Typing text color
                cursorColor: Colors.amber,
                decoration: InputDecoration(
                  fillColor: theme.cardColor, // Dynamic input background
                  filled: true,
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 1, color: Colors.transparent),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 1, color: Colors.transparent),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: colors.onSurface.withValues(alpha: 0.5),
                  ),
                  hintText: 'Search books, authors, categories...',
                  hintStyle: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.5),
                  ),
                  border: InputBorder.none,
                  suffixIcon: Icon(
                    Icons.filter_list,
                    color: colors.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- TAB BAR ----------------
  Widget _buildTabBar(ThemeData theme, ColorScheme colors) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tabs.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedTabIndex;

          // Determine unselected background color based on theme brightness
          final unselectedBg = theme.brightness == Brightness.dark
              ? Colors.grey[800]
              : const Color.fromARGB(255, 215, 215, 215);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: isSelected ? Colors.amber : unselectedBg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              onPressed: () {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              child: Text(
                _tabs[index],
                style: TextStyle(
                  color: isSelected
                      ? (theme.brightness == Brightness.dark
                            ? Colors.black
                            : Colors.white)
                      : colors.onSurface,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------- BOOK LIST ----------------
  Widget _buildBookList(ThemeData theme, ColorScheme colors) {
    final displayBooks = _filteredBooks;

    if (displayBooks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 50,
              color: colors.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 10),
            Text(
              "No books found",
              style: TextStyle(color: colors.onSurface.withValues(alpha: 0.6)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: displayBooks.length,
      itemBuilder: (context, index) {
        final b = displayBooks[index];

        return _buildBookListItem(
          theme: theme,
          colors: colors,
          title: b['title'],
          author: b['author'],
          action: b['action'],
          distance: b['distance'],
          category: b['category'],
          readers: b['readers'],
          daysAgo: b['days_ago'],
          user: b['user'],
          imageUrl: b['image_url'],
          ownerImageUrl: b['owner_image_url'],
        );
      },
    );
  }

  // ---------------- BOOK LIST ITEM ----------------
  Widget _buildBookListItem({
    required ThemeData theme,
    required ColorScheme colors,
    required String title,
    required String author,
    required String action,
    required String distance,
    required String category,
    String? readers,
    required String daysAgo,
    required String user,
    required String imageUrl,
    String? ownerImageUrl,
  }) {
    Color actionColor;
    IconData actionIcon;
    final isDark = theme.brightness == Brightness.dark;

    // Use brighter colors in dark mode for visibility
    switch (action) {
      case 'Donation':
        actionColor = Colors.green;
        actionIcon = Icons.volunteer_activism;
        break;
      case 'Exchange':
        actionColor = isDark ? Colors.orangeAccent : Colors.orange;
        actionIcon = Icons.compare_arrows;
        break;
      default:
        actionColor = const Color(0xFF6B45A2); // Purple
        actionIcon = Icons.bookmark_add;
    }

    // Text color specifically for the action tag (always white on light mode, black on accent in dark mode?)
    // Actually, simple white usually works on solid colors, but let's be safe.
    final actionTextColor = Colors.white;
    final actionIconColor = Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        color: theme.cardColor, // Dynamic Card Background
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: () {
            // Add tap logic here
          },
          borderRadius: BorderRadius.circular(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Image
              Stack(
                children: [
                  Container(
                    width: 120,
                    height: 215,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      color: Colors.grey[200],
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: actionColor,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(actionIcon, size: 14, color: actionIconColor),
                          const SizedBox(width: 4),
                          Text(
                            action,
                            style: TextStyle(
                              color: actionTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 16),

              // Book Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          title,
                          style: TextStyle(
                            color: colors.onSurface, // Dynamic Text Color
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        author,
                        style: TextStyle(
                          color: colors.onSurface.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: colors.onSurface.withValues(alpha: 0.6),
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: colors.onSurface.withValues(alpha: 0.5),
                          ),
                          Text(
                            'Phnom Penh • $distance',
                            style: TextStyle(
                              color: colors.onSurface.withValues(alpha: 0.6),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          readers ?? "0 previous readers",
                          style: TextStyle(
                            color: colors.onSurface.withValues(alpha: 0.6),
                            fontSize: 13,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          daysAgo,
                          style: TextStyle(
                            color: colors.onSurface.withValues(alpha: 0.6),
                            fontSize: 13,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: ownerImageUrl != null
                                ? NetworkImage(ownerImageUrl)
                                : null,
                            child: ownerImageUrl == null
                                ? Icon(
                                    Icons.person,
                                    size: 18,
                                    color: colors.onSurface,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            user,
                            style: TextStyle(
                              color: colors.onSurface,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
