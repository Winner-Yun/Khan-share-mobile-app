import 'package:flutter/material.dart';
import 'package:khan_share_mobile_app/config/appColors.dart';
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

  // 2. Data Source (Moved here to filter it)
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
        final category = book['category'].toString().toLowerCase(); // <-- added

        // NOW SEARCHES TITLE + AUTHOR + CATEGORY
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
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Column(
        children: <Widget>[
          _buildHeaderAndSearch(context),
          Padding(padding: const EdgeInsets.all(10.0), child: _buildTabBar()),
          Expanded(child: _buildBookList()),
        ],
      ),
    );
  }

  // ---------------- HEADER + SEARCH ----------------
  Widget _buildHeaderAndSearch(BuildContext context) {
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
                        errorBuilder: (c, o, s) => const Icon(
                          Icons.book,
                          color: Colors.amber,
                          size: 20,
                        ),
                      ),
                      const Text(
                        "Khan Share",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColor.textAppbar,
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
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(
                            Icons.notifications,
                            color: AppColor.tabUnselected,
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
              const Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: AppColor.textAppbar,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Phnom Penh",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColor.textAppbar,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Search Bar
              TextField(
                controller: _searchController,
                // --- ADDED: Update state on change ---
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  fillColor: AppColor.background,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 1, color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 1, color: Colors.transparent),
                  ),
                  prefixIcon: Icon(Icons.search, color: AppColor.iconSecondary),
                  hintText: 'Search books, authors, categories...',
                  hintStyle: TextStyle(color: AppColor.textSecondary),
                  border: InputBorder.none,
                  suffixIcon: Icon(
                    Icons.filter_list,
                    color: AppColor.iconSecondary,
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
  Widget _buildTabBar() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tabs.length,
        itemBuilder: (context, index) {
          // --- UPDATED: Check selected index ---
          final isSelected = index == _selectedTabIndex;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: isSelected
                    ? AppColor.primary
                    : const Color.fromARGB(255, 215, 215, 215),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              // --- UPDATED: Set state on tap ---
              onPressed: () {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              child: Text(
                _tabs[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColor.textPrimary,
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
  Widget _buildBookList() {
    final displayBooks = _filteredBooks; // Use the filtered list

    if (displayBooks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 50, color: Colors.grey),
            const SizedBox(height: 10),
            Text("No books found", style: TextStyle(color: Colors.grey[600])),
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

    switch (action) {
      case 'Donation':
        actionColor = AppColor.donate;
        actionIcon = Icons.volunteer_activism;
        break;
      case 'Exchange':
        actionColor = AppColor.exchange;
        actionIcon = Icons.compare_arrows;
        break;
      default:
        actionColor = AppColor.borrow;
        actionIcon = Icons.bookmark_add;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        color: AppColor.cardBackground,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: () {
            // Add tap logic here if needed
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
                          Icon(actionIcon, size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            action,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
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
                          style: const TextStyle(
                            color: AppColor.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        author,
                        style: const TextStyle(
                          color: AppColor.textSecondary,
                          fontSize: 14,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          category,
                          style: const TextStyle(
                            color: AppColor.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: AppColor.iconSecondary,
                          ),
                          Text(
                            'Phnom Penh • $distance',
                            style: const TextStyle(
                              color: AppColor.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          readers ?? "0 previous readers",
                          style: const TextStyle(
                            color: AppColor.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          daysAgo,
                          style: const TextStyle(
                            color: AppColor.textSecondary,
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
                                ? const Icon(
                                    Icons.person,
                                    size: 18,
                                    color: AppColor.iconPrimary,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            user,
                            style: const TextStyle(
                              color: AppColor.textPrimary,
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
