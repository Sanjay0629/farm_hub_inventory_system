import 'package:farm_hub/farmer_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'sign_in_farmer.dart';
import 'selection_page.dart';
import 'location_page.dart';

class LogInFarmer extends StatefulWidget {
  const LogInFarmer({super.key});

  @override
  _LogInFarmer createState() => _LogInFarmer();
}

class _LogInFarmer extends State<LogInFarmer> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;
  bool _isLoading = false; // Loading indicator

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() => setState(() => _emailError = null));
    _passwordController.addListener(
      () => setState(() => _passwordError = null),
    );
  }

  void _validateFields() {
    setState(() {
      _emailError = _validateEmail(_emailController.text);
      _passwordError = _validatePassword(_passwordController.text);
    });

    if (_emailError == null && _passwordError == null) {
      _signIn();
    }
  }

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login Successful!")));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FarmerProfile()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found') {
          _emailError = "No user found for this email.";
        } else if (e.code == 'wrong-password') {
          _passwordError = "Incorrect password.";
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Login failed")));
        }
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) return "Email is required";
    final emailRegExp = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return emailRegExp.hasMatch(value) ? null : "Enter a valid email";
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) return "Password is required";
    return value.length < 6 ? "Password must be at least 6 characters" : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA7E063),
      body: Column(
        children: [
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

                    // Password Field
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
                            onPressed:
                                () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                          ),
                        ),
                      ),
                    ),

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
                        backgroundColor: const Color(0xFF3B5D36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 100,
                        ),
                      ),
                      onPressed: _isLoading ? null : _validateFields,
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
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
