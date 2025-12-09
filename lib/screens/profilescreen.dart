import 'package:flutter/material.dart';
import 'package:khan_share_mobile_app/config/appColors.dart';
import 'package:khan_share_mobile_app/screens/settingscreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Combined data map
  final Map<String, dynamic> profileData = {
    "user": {
      "name": "Yun Winner",
      "image":
          "https://scontent.fpnh5-4.fna.fbcdn.net/v/t39.30808-1/484447987_1182847360231289_296100024115737949_n.jpg?stp=dst-jpg_s200x200_tt6&_nc_cat=110&ccb=1-7&_nc_sid=e99d92&_nc_eui2=AeGcZ5sCgmzALAkR1fL4kz0VO_nPc605L607-c9zrTkvrVykI1HR125_bE38xwWqOYBhJ6n4qSKWnhVhJTD-U_wj&_nc_ohc=H37nphlBj9kQ7kNvwEZ2kfw&_nc_oc=AdlN6XYsX36Mx13O8kMBeeFLPPBlOFaYEVIDDLeZqSahgHlqcZK7KOpHHjYT5iBvatM&_nc_zt=24&_nc_ht=scontent.fpnh5-4.fna&_nc_gid=w9O8_1HFvEd8hyZVeYw1JQ&oh=00_AfnMQN93k7TzAMi8lQvUESxFrBnbdyphRDIiVree2I4KWw&oe=693C5D11",
      "location": "Phnom Penh, Cambodia",
      "joined": "January 2025",
      "bio":
          "Book lover and passionate reader. I believe books should be shared, not stored. Let's build a reading community together! 📚",
      "rating": 4.9,
      "reviews": 18,
    },

    // POINTS SECTION (NEW)
    "points": 2480,

    "stats": {"donated": 23, "exchanged": 12, "borrowed": 8},

    "books": [
      {
        "title": "To Kill a Mockingbird",
        "author": "Harper Lee",
        "label": "Donating",
        "color": Colors.green,
        "img":
            "https://placeit-img-1-p.cdn.aws.placeit.net/uploads/stage/stage_image/22739/optimized_large_thumb_children-stories-book-cover-541__1_.jpg",
      },
      {
        "title": "1984",
        "author": "George Orwell",
        "label": "For Exchange",
        "color": Colors.orange,
        "img":
            "https://assets.visme.co/templates/banners/thumbnails/i_Bedtime-Story-Book-Cover_full.jpg",
      },
      {
        "title": "1984",
        "author": "George Orwell",
        "label": "For Exchange",
        "color": Colors.orange,
        "img":
            "https://assets.visme.co/templates/banners/thumbnails/i_Bedtime-Story-Book-Cover_full.jpg",
      },
      {
        "title": "1984",
        "author": "George Orwell",
        "label": "For Exchange",
        "color": Colors.orange,
        "img":
            "https://assets.visme.co/templates/banners/thumbnails/i_Bedtime-Story-Book-Cover_full.jpg",
      },
      {
        "title": "1984",
        "author": "George Orwell",
        "label": "For Exchange",
        "color": Colors.orange,
        "img":
            "https://assets.visme.co/templates/banners/thumbnails/i_Bedtime-Story-Book-Cover_full.jpg",
      },
      {
        "title": "1984",
        "author": "George Orwell",
        "label": "For Exchange",
        "color": Colors.orange,
        "img":
            "https://assets.visme.co/templates/banners/thumbnails/i_Bedtime-Story-Book-Cover_full.jpg",
      },
      {
        "title": "1984",
        "author": "George Orwell",
        "label": "For Exchange",
        "color": Colors.orange,
        "img":
            "https://assets.visme.co/templates/banners/thumbnails/i_Bedtime-Story-Book-Cover_full.jpg",
      },
      {
        "title": "1984",
        "author": "George Orwell",
        "label": "For Exchange",
        "color": Colors.orange,
        "img":
            "https://assets.visme.co/templates/banners/thumbnails/i_Bedtime-Story-Book-Cover_full.jpg",
      },
      {
        "title": "1984",
        "author": "George Orwell",
        "label": "For Exchange",
        "color": Colors.orange,
        "img":
            "https://assets.visme.co/templates/banners/thumbnails/i_Bedtime-Story-Book-Cover_full.jpg",
      },
      {
        "title": "1984",
        "author": "George Orwell",
        "label": "For Exchange",
        "color": Colors.orange,
        "img":
            "https://assets.visme.co/templates/banners/thumbnails/i_Bedtime-Story-Book-Cover_full.jpg",
      },
      // ... more books ...
    ],
  };

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = profileData["user"];
    final stats = profileData["stats"];
    final points = profileData["points"];
    final books = profileData["books"];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColor.textAppbar,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
            icon: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(Icons.settings, color: AppColor.tabUnselected),
            ),
          ),
        ],
      ),

      // ========== SCROLLABLE PAGE WITH STICKY SEARCH ===========
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(user),
                const SizedBox(height: 15),

                _buildStats(stats),
                const SizedBox(height: 20),

                // ----- NEW POINTS SECTION -----
                _buildPoints(points),
                const SizedBox(height: 20),

                _buildBooksTitle(),
              ],
            ),
          ),

          // -------- STICKY SEARCH FIELD ----------
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickySearchDelegate(
              child: Container(
                color: AppColor.background,
                child: _buildSearchField(),
              ),
            ),
          ),

          // --------- BOOK LIST ----------
          SliverList(
            delegate: SliverChildBuilderDelegate(childCount: books.length, (
              context,
              index,
            ) {
              final b = books[index];
              return _bookItem(
                b["title"],
                b["author"],
                b["label"],
                b["color"],
                b["img"],
              );
            }),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  // ====================== WIDGETS ===========================

  Widget _buildProfileHeader(user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: AppColor.background,
      child: Column(
        children: [
          Row(
            spacing: 10,
            children: [
              CircleAvatar(
                radius: 45,
                backgroundImage: NetworkImage(user["image"]),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user["name"],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(user["location"], style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 5),
                  Text("Member since ${user["joined"]}"),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: Text(user["bio"], textAlign: TextAlign.start),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(stats) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statBox("Donated", stats["donated"]),
          _statBox("Exchanged", stats["exchanged"]),
          _statBox("Borrowed", stats["borrowed"]),
        ],
      ),
    );
  }

  // POINTS SECTION UI
  Widget _buildPoints(int points) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.amber.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber),
        ),
        child: Row(
          children: [
            Icon(Icons.stars, color: Colors.amber, size: 32),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Points",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "$points pts",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.amber.shade800,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBooksTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        "Your Books",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // SEARCH FIELD
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search title, author...",
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

  // ---------------- REUSABLE ITEMS ----------------

  Widget _statBox(String title, int value) {
    return Column(
      children: [
        Text(
          "$value",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(title, style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _bookItem(
    String title,
    String author,
    String label,
    Color color,
    String img,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(img, width: 60, height: 90, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(author, style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================ STICKY HEADER DELEGATE ==================
class _StickySearchDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _StickySearchDelegate({required this.child});

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return Container(color: Colors.white, child: child);
  }

  @override
  double get maxExtent => 70;
  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(covariant _StickySearchDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
