import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khan_share_mobile_app/screens/map_picker_screen.dart';

class Createbooklist extends StatefulWidget {
  const Createbooklist({super.key});

  @override
  State<Createbooklist> createState() => _CreatebooklistState();
}

class _CreatebooklistState extends State<Createbooklist> {
  String? selectedShareType = "Donate";

  // Controllers for all inputs
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController conditionController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Location Controller
  final TextEditingController locationController = TextEditingController(
    text: "Phnom Penh, Cambodia",
  );

  File? bookImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        bookImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ---------------- THEME DATA ----------------
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Dynamic background
      appBar: _buildAppBar(theme, colors),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPhotoPicker(theme, colors),
              const SizedBox(height: 20),

              // 1. Title
              _buildTextField(
                "Book Title *",
                "Enter book title",
                titleController,
                theme,
                colors,
              ),
              const SizedBox(height: 16),

              // 2. Author
              _buildTextField(
                "Author *",
                "Enter author name",
                authorController,
                theme,
                colors,
              ),
              const SizedBox(height: 16),

              // 3. Location
              _buildLocationField(theme, colors),
              const SizedBox(height: 16),

              // 4. Category
              _buildTextField(
                "Category",
                "e.g. Fiction, History...",
                categoryController,
                theme,
                colors,
              ),
              const SizedBox(height: 16),

              // 5. Condition
              _buildTextField(
                "Condition",
                "e.g. Like New, Used...",
                conditionController,
                theme,
                colors,
              ),
              const SizedBox(height: 16),

              // 6. Language
              _buildTextField(
                "Language",
                "e.g. Khmer, English...",
                languageController,
                theme,
                colors,
              ),
              const SizedBox(height: 16),

              // 7. Description
              _buildDescriptionField(theme, colors),
              const SizedBox(height: 25),

              // 8. Share Options
              _buildShareOptions(theme, colors, isDark),
              const SizedBox(height: 25),

              _buildSubmitButton(colors),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------- WIDGETS ---------------------

  AppBar _buildAppBar(ThemeData theme, ColorScheme colors) {
    final isDark = theme.brightness == Brightness.dark;
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent, // Allow image to show
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: Colors.amber),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        "Add Book",
        style: GoogleFonts.poppins(
          // Use dynamic primary color
          color: Colors.amber,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Colors.black, // Fallback background
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
            opacity: isDark ? 0.2 : 0,
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPicker(ThemeData theme, ColorScheme colors) {
    return InkWell(
      onTap: _pickImage,
      child: Container(
        height: 170,
        width: double.infinity,
        decoration: BoxDecoration(
          // Use cardColor (Dark Grey in Dark Mode, Light Grey in Light Mode)
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.outline.withValues(alpha: 0.2)),
        ),
        child: bookImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  bookImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 30,
                      color: colors.onSurface.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Tap to add photo",
                      style: GoogleFonts.poppins(
                        color: colors.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller,
    ThemeData theme,
    ColorScheme colors,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: colors.onSurface, // Dynamic label color
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: TextStyle(color: colors.onSurface), // Typing text color
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.4),
            ),
            filled: true,
            // Dynamic fill color
            fillColor: theme.cardColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationField(ThemeData theme, ColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Location *",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: locationController,
          style: TextStyle(color: colors.onSurface),
          decoration: InputDecoration(
            hintText: "Enter or select location",
            hintStyle: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.4),
            ),
            filled: true,
            fillColor: theme.cardColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.location_on, color: Colors.amber),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MapPickerScreen(),
                  ),
                );
                if (result != null && result is String) {
                  setState(() {
                    locationController.text = result;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField(ThemeData theme, ColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description (Optional)",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: descriptionController,
          maxLines: 4,
          style: TextStyle(color: colors.onSurface),
          decoration: InputDecoration(
            hintText: "Tell others about this book...",
            hintStyle: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.4),
            ),
            filled: true,
            fillColor: theme.cardColor,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShareOptions(ThemeData theme, ColorScheme colors, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "How would you like to share? *",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        _shareOption(
          "Donate",
          "Give away your book to someone who needs it",
          theme,
          colors,
          isDark,
        ),
        const SizedBox(height: 10),
        _shareOption(
          "Exchange",
          "Trade with another book you want to read",
          theme,
          colors,
          isDark,
        ),
        const SizedBox(height: 10),
        _shareOption(
          "Borrow",
          "Lend your book temporarily and get it back later",
          theme,
          colors,
          isDark,
        ),
      ],
    );
  }

  Widget _shareOption(
    String type,
    String subtitle,
    ThemeData theme,
    ColorScheme colors,
    bool isDark,
  ) {
    final bool selected = selectedShareType == type;

    // Determine background color for selected state
    // Light Mode: Green[50], Dark Mode: Primary with low opacity
    final selectedBg = isDark
        ? Colors.amber.withValues(alpha: 0.15)
        : Colors.green[50];

    final unselectedBg = theme.cardColor;

    return InkWell(
      onTap: () => setState(() => selectedShareType = type),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? selectedBg : unselectedBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? Colors.amber
                : colors.outline.withValues(alpha: 0.2),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio(
              value: type,
              // ignore: deprecated_member_use
              groupValue: selectedShareType,
              // ignore: deprecated_member_use
              onChanged: (value) =>
                  setState(() => selectedShareType = value.toString()),
              activeColor: Colors.amber,
              // Fix radio color in dark mode unselected state
              fillColor: WidgetStateProperty.resolveWith<Color>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.amber;
                }
                return colors.outline;
              }),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: colors.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(ColorScheme colors) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber, // Use dynamic Amber
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          "Share Book",
          style: GoogleFonts.poppins(
            color: Colors.white, // Always white text on primary button
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
