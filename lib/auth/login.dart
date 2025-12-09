import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khan_share_mobile_app/auth/signup.dart';
import 'package:khan_share_mobile_app/auth/welcomepage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool ischeck = false;

  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  String? emailError;
  String? passError;

  final RegExp emailReg = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

  bool get isValid {
    return emailError == null &&
        passError == null &&
        emailCtrl.text.isNotEmpty &&
        passCtrl.text.isNotEmpty;
  }

  void validateEmail(String value) {
    if (value.isEmpty) {
      emailError = "Email cannot be empty";
    } else if (!emailReg.hasMatch(value)) {
      emailError = "Invalid email format";
    } else {
      emailError = null;
    }
  }

  void validatePassword(String value) {
    if (value.isEmpty) {
      passError = "Password cannot be empty";
    } else if (value.length < 8) {
      passError = "Password must be at least 8 characters";
    } else {
      passError = null;
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return PopScope(
      canPop: false,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _buldLoginForm(context),
      ),
    );
  }

  BoxDecoration _buildBackground() {
    return const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/welcomeIMG.png'),
        fit: BoxFit.cover,
        alignment: AlignmentGeometry.xy(1, 0),
      ),
    );
  }

  Widget _buldLoginForm(BuildContext context) {
    return Container(
      decoration: _buildBackground(),
      child: Container(
        color: Colors.black.withValues(alpha: 0.4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(padding: const EdgeInsets.all(20.0), child: _buildHeader()),
            Container(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 0.8,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      _buildInputField(
                        label: "Gmail",
                        hint: "Enter your Email",
                        controller: emailCtrl,
                        errorText: emailError,
                        onChanged: (value) {
                          setState(() => validateEmail(value));
                        },
                      ),

                      const SizedBox(height: 20),

                      _buildInputField(
                        label: "Password",
                        hint: "Enter password",
                        controller: passCtrl,
                        isPassword: true,
                        icon: Icons.visibility_off,
                        iconColor: Colors.grey,
                        errorText: passError,
                        onChanged: (value) {
                          setState(() => validatePassword(value));
                        },
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      _buildButton(text: "SIGN IN"),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text("Don't have account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const FittedBox(
      child: Text(
        "Hello \nSign in!",
        style: TextStyle(
          height: 1.2,
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required Function(String) onChanged,
    bool isPassword = false,
    IconData? icon,
    Color iconColor = Colors.grey,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          controller: controller,
          onChanged: onChanged,
          obscureText: isPassword && !ischeck ? true : false,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade600),
            errorText: errorText,
            suffixIcon: icon != null
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        ischeck = !ischeck;
                      });
                    },
                    child: Icon(
                      ischeck ? Icons.visibility : Icons.visibility_off,
                      size: 20,
                      color: iconColor,
                    ),
                  )
                : null,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.amber, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton({required String text}) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 191, 147, 2),
              Color.fromARGB(255, 0, 212, 85),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: ElevatedButton(
          onPressed: isValid
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Scaffold()),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.grey.withValues(
              alpha: 1,
            ), // disabled color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
