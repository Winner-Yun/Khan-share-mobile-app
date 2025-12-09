import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khan_share_mobile_app/auth/login.dart';
import 'package:khan_share_mobile_app/auth/welcomepage.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool ischeck = false;

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final TextEditingController confirmCtrl = TextEditingController();

  String? nameError;
  String? emailError;
  String? passError;
  String? confirmError;

  final RegExp emailReg = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

  bool get isValid {
    return nameCtrl.text.isNotEmpty &&
        emailCtrl.text.isNotEmpty &&
        passCtrl.text.isNotEmpty &&
        confirmCtrl.text.isNotEmpty &&
        nameError == null &&
        emailError == null &&
        passError == null &&
        confirmError == null;
  }

  void validateName(String value) {
    if (value.isEmpty) {
      nameError = "Full name cannot be empty";
    } else {
      nameError = null;
    }
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

  void validateConfirmPassword(String value) {
    if (value.isEmpty) {
      confirmError = "Confirm password cannot be empty";
    } else if (value != passCtrl.text) {
      confirmError = "Passwords do not match";
    } else {
      confirmError = null;
    }
  }

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
        resizeToAvoidBottomInset: true,
        body: _buildSignupForm(context),
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

  Widget _buildSignupForm(BuildContext context) {
    return Container(
      decoration: _buildBackground(),
      child: Container(
        color: Colors.black.withValues(alpha: 0.4),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.all(20), child: _buildHeader()),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildInputField(
                          label: "Full Name",
                          hint: "Enter your Full name",
                          controller: nameCtrl,
                          errorText: nameError,
                          onChanged: (value) {
                            setState(() => validateName(value));
                          },
                        ),
                        const SizedBox(height: 20),
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
                            setState(() {
                              validatePassword(value);
                              validateConfirmPassword(confirmCtrl.text);
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          label: "Confirm Password",
                          hint: "Enter confirm password",
                          controller: confirmCtrl,
                          isPassword: true,
                          icon: Icons.visibility_off,
                          iconColor: Colors.grey,
                          errorText: confirmError,
                          onChanged: (value) {
                            setState(() => validateConfirmPassword(value));
                          },
                        ),
                        const SizedBox(height: 40),

                        _buildButton(context, text: "SIGN UP"),

                        const SizedBox(height: 20),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("Already have account?"),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Sign in",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildHeader() {
    return const FittedBox(
      child: Text(
        "Create Your\nAccount",
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
            errorText: errorText,
            hintStyle: TextStyle(color: Colors.grey.shade600),
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

  Widget _buildButton(BuildContext context, {required String text}) {
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
            disabledBackgroundColor: Colors.grey.withValues(alpha: 1),
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
