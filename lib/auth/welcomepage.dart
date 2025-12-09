import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khan_share_mobile_app/auth/login.dart';
import 'package:khan_share_mobile_app/auth/signup.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final Color primaryColor = const Color(0xFFF5C857);
  final Color bodyTextColor = const Color.fromARGB(255, 161, 161, 161);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // Stretch children like buttons
            children: [
              _buildHeader(),
              _buildIllustration(),
              _buildContentText(),
              _buildCtaButtons(),
              _buildSocialLoginSection(),
              const SizedBox(height: 24), // Extra padding at the bottom
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 48.0, bottom: 24.0),
      child: SizedBox(
        width: 120,
        height: 120,
        child: Image.asset(
          'assets/icons/logokhanshare.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.40,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/welcomeIMG.png', fit: BoxFit.cover),
            const SizedBox(height: 10),
            Text(
              'A place for book lovers',
              style: TextStyle(
                color: bodyTextColor.withValues(alpha: 0.8),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. Content Text Widget (Title and Description)
  Widget _buildContentText() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Share Stories, Build Community',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900, // Extra bold for the main title
              color: Colors.black,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Join a community of book lovers in Cambodia. Donate, exchange, and discover new books for free.',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 14, color: bodyTextColor),
          ),
        ],
      ),
    );
  }

  Widget _buildCtaButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignupScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Create Account',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: primaryColor, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text(
              'Log In',
              style: TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLoginSection() {
    return Column(
      children: [
        // "Or" Divider
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text('Or', style: TextStyle(color: Colors.grey)),
              ),
              Expanded(child: Divider()),
            ],
          ),
        ),
        // Google Button
        _buildSocialButton(
          label: 'Google',
          icon: Image.asset(
            'assets/icons/search.png',
            fit: BoxFit.cover,
            width: 20,
          ),
          onPressed: () {},
        ),
        const SizedBox(height: 12),
        // Facebook Button
        _buildSocialButton(
          label: 'Facebook',
          icon: Image.asset(
            'assets/icons/facebook.png',
            fit: BoxFit.cover,
            width: 20,
          ),
          onPressed: () {},
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildSocialButton({
    required String label,
    required Widget icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: Color(0xFFdee2e6),
            width: 1,
          ), // Light grey border
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
