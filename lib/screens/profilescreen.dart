import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          "https://scontent.fpnh5-4.fna.fbcdn.net/v/t39.30808-1/484447987_1182847360231289_296100024115737949_n.jpg?stp=dst-jpg_s200x200_tt6&_nc_cat=110&ccb=1-7&_nc_sid=e99d92&_nc_eui2=AeGcZ5sCgmzALAkR1fL4kz0VO_nPc605L607-c9zrTkvrVykI1HR125_bE38xwWqOYBhJ6n4qSKWnhVhJTD-U_wj&_nc_ohc=unDKU-QJ-WQQ7kNvwEqYBLc&_nc_oc=AdmCsVKllJsccPkZ0HLwOlJmk-qep-5NdjXXcJWlQzoxkDwVRyzM-d3Mk_JfVGrgnIY&_nc_zt=24&_nc_ht=scontent.fpnh5-4.fna&_nc_gid=fB83gr3W2rE_PgyJRinwPg&oh=00_Afnaa1aED_va08hX_JojxbB6jmhfmHLVeO493EGWYKRpVQ&oe=69436511",
      "location": "Phnom Penh, Cambodia",
      "joined": "January 2025",
      "bio":
          "Book lover and passionate reader. I believe books should be shared, not stored. Let's build a reading community together! 📚",
      "rating": 4.9,
      "reviews": 18,
    },

    // POINTS SECTION
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
      // ... repeated data ...
      {
        "title": "The Great Gatsby",
        "author": "F. Scott Fitzgerald",
        "label": "For Exchange",
        "color": Colors.orange,
        "img":
            "https://assets.visme.co/templates/banners/thumbnails/i_Bedtime-Story-Book-Cover_full.jpg",
      },
    ],
  };

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ---------------- THEME DATA ----------------
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final user = profileData["user"];
    final stats = profileData["stats"];
    final points = profileData["points"];
    final books = profileData["books"];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Dynamic Background
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            // Use dynamic primary color
            color: Colors.amber,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover,
              opacity: isDark ? 0.2 : 0,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            icon: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.amber, // Amber
                borderRadius: BorderRadius.circular(100),
              ),
              // Settings icon color (Black usually looks best on Amber)
              child: const Icon(Icons.settings, color: Colors.white),
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
                _buildProfileHeader(user, theme, colors),
                const SizedBox(height: 15),

                _buildStats(stats, colors),
                const SizedBox(height: 20),

                // ----- NEW POINTS SECTION -----
                _buildPoints(points, colors, isDark),
                const SizedBox(height: 20),

                _buildBooksTitle(colors),
              ],
            ),
          ),

          // -------- STICKY SEARCH FIELD ----------
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickySearchDelegate(
              backgroundColor:
                  theme.scaffoldBackgroundColor, // Pass Theme Color
              child: Container(
                color: theme.scaffoldBackgroundColor, // Match Scaffold
                child: _buildSearchField(theme, colors),
              ),
            ),
          ),

          // --------- BOOK LIST ----------
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final b = books[index];
              return _bookItem(
                b["title"],
                b["author"],
                b["label"],
                b["color"],
                b["img"],
                colors,
              );
            }, childCount: books.length),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  // ====================== WIDGETS ===========================

  Widget _buildProfileHeader(Map user, ThemeData theme, ColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: theme.scaffoldBackgroundColor, // Dynamic
      child: Column(
        children: [
          Row(
            spacing: 10,
            children: [
              CircleAvatar(
                radius: 45,
                backgroundImage: NetworkImage(user["image"]),
                backgroundColor: colors.surface,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user["name"],
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface, // Dynamic Text
                      ),
                    ),
                    Text(
                      user["location"],
                      style: TextStyle(
                        color: colors.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Member since ${user["joined"]}",
                      style: TextStyle(
                        color: colors.onSurface.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: Text(
              user["bio"],
              textAlign: TextAlign.start,
              style: TextStyle(color: colors.onSurface.withValues(alpha: 0.8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(Map stats, ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statBox("Donated", stats["donated"], colors),
          _statBox("Exchanged", stats["exchanged"], colors),
          _statBox("Borrowed", stats["borrowed"], colors),
        ],
      ),
    );
  }

  // POINTS SECTION UI
  Widget _buildPoints(int points, ColorScheme colors, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.amber.withValues(alpha: 0.1), // Subtle Amber background
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                Text(
                  "$points pts",
                  style: TextStyle(
                    fontSize: 20,
                    // Use brighter amber in dark mode, darker amber in light mode
                    color: isDark ? Colors.amber : Colors.amber.shade800,
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

  Widget _buildBooksTitle(ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        "Your Books",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: colors.onSurface,
        ),
      ),
    );
  }

  // SEARCH FIELD
  Widget _buildSearchField(ThemeData theme, ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: colors.onSurface), // Typing text color
        decoration: InputDecoration(
          hintText: "Search title, author...",
          hintStyle: TextStyle(color: colors.onSurface.withValues(alpha: 0.5)),
          prefixIcon: Icon(
            Icons.search,
            color: colors.onSurface.withValues(alpha: 0.5),
          ),
          filled: true,
          fillColor: theme.cardColor, // Dynamic Fill
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

  Widget _statBox(String title, int value, ColorScheme colors) {
    return Column(
      children: [
        Text(
          "$value",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        Text(
          title,
          style: TextStyle(color: colors.onSurface.withValues(alpha: 0.6)),
        ),
      ],
    );
  }

  Widget _bookItem(
    String title,
    String author,
    String label,
    Color color,
    String img,
    ColorScheme colors,
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                Text(
                  author,
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.6),
                  ),
                ),
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
  final Color backgroundColor; // Add color property

  _StickySearchDelegate({required this.child, required this.backgroundColor});

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return Container(
      color: backgroundColor, // Use dynamic color
      child: child,
    );
  }

  @override
  double get maxExtent => 70;
  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(covariant _StickySearchDelegate oldDelegate) {
    return oldDelegate.child != child ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
