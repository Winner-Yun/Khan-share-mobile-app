import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Changed from provider to get
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khan_share_mobile_app/config/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _bookRequests = true;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // Initialize controller
  final ThemeController _themeController = Get.put(ThemeController());

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() => _profileImage = File(pickedFile.path));
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the custom theme data defined in AppTheme
    final theme = Theme.of(context);
    // Helper for main text/icon color (Black in Light, White in Dark)
    final mainColor = theme.iconTheme.color ?? Colors.black;
    // Helper for outline/secondary elements
    final outlineColor = Colors.grey;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: theme.appBarTheme.iconTheme?.color,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Settings",
          style: GoogleFonts.poppins(
            // Use dynamic primary color
            color: Colors.amber,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: outlineColor.withValues(alpha: 0.1),
            height: 1,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildProfileHeader(mainColor, outlineColor),
            const SizedBox(height: 30),

            _buildSectionHeader("Account", outlineColor),
            _buildCardContainer(theme, outlineColor, [
              _buildListTile(
                mainColor,
                outlineColor,
                icon: Icons.person_outline_rounded,
                title: "Personal Info",
              ),
              _buildDivider(outlineColor),
              _buildListTile(
                mainColor,
                outlineColor,
                icon: Icons.language_rounded,
                title: "Language",
                trailingText: "English",
              ),
              _buildDivider(outlineColor),
              _buildListTile(
                mainColor,
                outlineColor,
                icon: Icons.location_on_outlined,
                title: "Location",
              ),
              _buildDivider(outlineColor),
              _buildListTile(
                mainColor,
                outlineColor,
                icon: Icons.lock_outline_rounded,
                title: "Security",
              ),
            ]),

            const SizedBox(height: 24),

            _buildSectionHeader("Preferences", outlineColor),
            _buildCardContainer(theme, outlineColor, [
              _buildSwitchTile(
                mainColor,
                icon: Icons.notifications_outlined,
                title: "Notifications",
                value: _bookRequests,
                onChanged: (v) => setState(() => _bookRequests = v),
              ),
              _buildDivider(outlineColor),

              // WRAPPED IN OBX FOR REACTIVE THEME SWITCHING
              Obx(
                () => _buildSwitchTile(
                  mainColor,
                  icon: Icons.dark_mode_outlined,
                  title: "Dark Mode",
                  value: _themeController.isDark.value,
                  onChanged: (v) => _themeController.toggleTheme(v),
                ),
              ),
            ]),

            const SizedBox(height: 24),

            _buildSectionHeader("Support", outlineColor),
            _buildCardContainer(theme, outlineColor, [
              _buildListTile(
                mainColor,
                outlineColor,
                icon: Icons.help_outline_rounded,
                title: "Help Center",
              ),
              _buildDivider(outlineColor),
              _buildListTile(
                mainColor,
                outlineColor,
                icon: Icons.shield_outlined,
                title: "Privacy & Terms",
              ),
              _buildDivider(outlineColor),
              _buildListTile(
                mainColor,
                outlineColor,
                icon: Icons.info_outline_rounded,
                title: "About Khan Share",
                trailingText: "v1.0.0",
              ),
            ]),

            const SizedBox(height: 32),
            _buildLogoutButton(theme),

            const SizedBox(height: 40),
            Text(
              "Khan Share • Built for Readers",
              style: TextStyle(
                color: outlineColor.withValues(alpha: 0.7),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ----------------------------------
  // -------- Widget Builders ---------
  // ----------------------------------

  Widget _buildProfileHeader(Color mainColor, Color outlineColor) {
    return Row(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 35,
                backgroundColor: outlineColor.withValues(alpha: 0.2),
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : NetworkImage(
                        'https://scontent.fpnh5-4.fna.fbcdn.net/v/t39.30808-1/484447987_1182847360231289_296100024115737949_n.jpg?stp=dst-jpg_s200x200_tt6&_nc_cat=110&ccb=1-7&_nc_sid=e99d92&_nc_eui2=AeGcZ5sCgmzALAkR1fL4kz0VO_nPc605L607-c9zrTkvrVykI1HR125_bE38xwWqOYBhJ6n4qSKWnhVhJTD-U_wj&_nc_ohc=unDKU-QJ-WQQ7kNvwEqYBLc&_nc_oc=AdmCsVKllJsccPkZ0HLwOlJmk-qep-5NdjXXcJWlQzoxkDwVRyzM-d3Mk_JfVGrgnIY&_nc_zt=24&_nc_ht=scontent.fpnh5-4.fna&_nc_gid=fB83gr3W2rE_PgyJRinwPg&oh=00_Afnaa1aED_va08hX_JojxbB6jmhfmHLVeO493EGWYKRpVQ&oe=69436511',
                      ),
              ),
            ),

            // Camera icon
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.amber, // Using Primary Color explicitly
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 15),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Yun Winner",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
            ),
            const SizedBox(height: 4),
            Text("Winner.y@khmer.com", style: TextStyle(color: outlineColor)),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, Color outlineColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 10, left: 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: outlineColor,
          fontSize: 12,
          letterSpacing: 1.2,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCardContainer(
    ThemeData theme,
    Color outlineColor,
    List<Widget> children,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme
            .cardColor, // Uses AppColorLight.cardBackground or Dark equivalent
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: outlineColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildListTile(
    Color mainColor,
    Color outlineColor, {
    required IconData icon,
    required String title,
    String? trailingText,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: outlineColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: mainColor, size: 20),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: mainColor,
                  ),
                ),
              ),

              if (trailingText != null)
                Text(trailingText, style: TextStyle(color: outlineColor)),

              Icon(
                Icons.chevron_right_rounded,
                color: outlineColor.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    Color mainColor, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: mainColor, size: 20),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: mainColor,
              ),
            ),
          ),

          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.amber, // Primary color
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(Color outlineColor) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 70,
      color: outlineColor.withValues(alpha: 0.1),
    );
  }

  Widget _buildLogoutButton(ThemeData theme) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.red.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.logout_rounded, color: Colors.redAccent),
          SizedBox(width: 8),
          Text(
            "Log Out",
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
