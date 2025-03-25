import 'package:farm_hub/location_page.dart';
import 'package:farm_hub/selection_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'sign_in_farmer.dart';

class LogInFarmer extends StatefulWidget {
  const LogInFarmer({super.key});

  @override
  _LogInFarmer createState() => _LogInFarmer();
}

class _LogInFarmer extends State<LogInFarmer> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();

    // Remove error message when user starts typing
    _emailController.addListener(() {
      setState(() {
        _emailError = null;
      });
    });

    _passwordController.addListener(() {
      setState(() {
        _passwordError = null;
      });
    });
  }

  void _validateFields() {
    setState(() {
      _emailError = _validateEmail(_emailController.text);
      _passwordError = _validatePassword(_passwordController.text);
    });

    if (_emailError == null && _passwordError == null) {
      // Navigate to next page if no validation errors
      _navigateToNextPage();
    }
  }

  void _navigateToNextPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LocationPage(),
      ), // Replace with your actual page
    );
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) return "Email is required";
    final emailRegExp = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    if (!emailRegExp.hasMatch(value)) return "Enter a valid email";
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) return "Password is required";
    if (value.length < 6) return "Password must be at least 6 characters";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA7E063), // Light green background
      body: Column(
        children: [
          // Back Button
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SelectionPage()),
                  );
                },
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "LOG IN",
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Email Field
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle: const TextStyle(
                            fontFamily: 'Fredoka',
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),

                    // Email Error Message
                    if (_emailError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _emailError!,
                            style: const TextStyle(
                              fontFamily: 'Fredoka',
                              fontSize: 14,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),

                    // Password Field with Visibility Toggle
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: const TextStyle(
                            fontFamily: 'Fredoka',
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                    ),

                    // Password Error Message
                    if (_passwordError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _passwordError!,
                            style: const TextStyle(
                              fontFamily: 'Fredoka',
                              fontSize: 14,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Login Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF3B5D36,
                        ), // Dark green button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 100,
                        ),
                      ),
                      onPressed: _validateFields,
                      child: const Text(
                        "LOG IN",
                        style: TextStyle(
                          fontFamily: 'Fredoka',
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
            ),
            child: Center(
              child: Text.rich(
                TextSpan(
                  text: "Don't have an Account? ",
                  style: const TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "SIGN IN",
                      style: const TextStyle(
                        fontFamily: 'Fredoka',
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignInFarmer(),
                                ),
                              );
                            },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
