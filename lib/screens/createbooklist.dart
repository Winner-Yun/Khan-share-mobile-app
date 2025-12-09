import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khan_share_mobile_app/config/appColors.dart';
import 'package:khan_share_mobile_app/screens/map_picker_screen.dart';

class Createbooklist extends StatefulWidget {
  const Createbooklist({super.key});

  @override
  State<Createbooklist> createState() => _CreatebooklistState();
}

class _CreatebooklistState extends State<Createbooklist> {
  String? selectedShareType = "Donate";

  // Controllers for all inputs (so you can type)
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController conditionController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Location Controller (Pre-filled but editable)
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPhotoPicker(),
              const SizedBox(height: 20),

              // 1. Title
              _buildTextField(
                "Book Title *",
                "Enter book title",
                titleController,
              ),
              const SizedBox(height: 16),

              // 2. Author
              _buildTextField(
                "Author *",
                "Enter author name",
                authorController,
              ),
              const SizedBox(height: 16),

              // 3. Location (Editable + Map Icon)
              _buildLocationField(),
              const SizedBox(height: 16),

              // 4. Category (Changed to TextField so you can type)
              _buildTextField(
                "Category",
                "e.g. Fiction, History...",
                categoryController,
              ),
              const SizedBox(height: 16),

              // 5. Condition (Changed to TextField so you can type)
              _buildTextField(
                "Condition",
                "e.g. Like New, Used...",
                conditionController,
              ),
              const SizedBox(height: 16),

              // 6. Language (Changed to TextField so you can type)
              _buildTextField(
                "Language",
                "e.g. Khmer, English...",
                languageController,
              ),
              const SizedBox(height: 16),

              // 7. Description
              _buildDescriptionField(),
              const SizedBox(height: 25),

              // 8. Share Options
              _buildShareOptions(),
              const SizedBox(height: 25),

              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------- WIDGETS ---------------------

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.exchange),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        "Add Book",
        style: GoogleFonts.poppins(
          color: AppColor.exchange,
          fontWeight: FontWeight.w600,
          fontSize: 18,
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
    );
  }

  Widget _buildPhotoPicker() {
    return InkWell(
      onTap: _pickImage,
      child: Container(
        height: 170,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
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
                    const Icon(Icons.camera_alt, size: 30, color: Colors.grey),
                    const SizedBox(height: 8),
                    Text(
                      "Tap to add photo",
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // Updated to support standard Text Input (Editable)
  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[100],
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

  // Location Field: Allows Typing AND Clicking Icon for Map
  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Location *",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: locationController,
          decoration: InputDecoration(
            hintText: "Enter or select location",
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            // Map Icon Button that opens the Picker
            suffixIcon: IconButton(
              icon: Icon(Icons.location_on, color: Colors.amber[700]),
              onPressed: () async {
                // 1. Navigate to MapPickerScreen and wait for result
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MapPickerScreen(),
                  ),
                );

                // 2. If user confirmed a location, update the text field
                if (result != null && result is String) {
                  setState(() {
                    locationController.text = result; // Update the text!
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description (Optional)",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: descriptionController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Tell others about this book...",
            filled: true,
            fillColor: Colors.grey[100],
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

  Widget _buildShareOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "How would you like to share? *",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        _shareOption("Donate", "Give away your book to someone who needs it"),
        const SizedBox(height: 10),
        _shareOption("Exchange", "Trade with another book you want to read"),
        const SizedBox(height: 10),
        _shareOption("Lend", "Lend your book temporarily, get it back later"),
      ],
    );
  }

  Widget _shareOption(String type, String subtitle) {
    final bool selected = selectedShareType == type;
    return InkWell(
      onTap: () => setState(() => selectedShareType = type),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? Colors.green[50] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Colors.amber : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio(
              value: type,
              groupValue: selectedShareType,
              onChanged: (value) =>
                  setState(() => selectedShareType = value.toString()),
              activeColor: Colors.amber,
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
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[700],
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

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF5C857),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          "Share Book",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
