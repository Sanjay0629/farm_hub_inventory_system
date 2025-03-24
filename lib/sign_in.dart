import 'package:farm_hub/log_in.dart';
import 'package:farm_hub/selection_page.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _nameError, _emailError, _passwordError;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() => _nameError = null));
    _emailController.addListener(() => setState(() => _emailError = null));
    _passwordController.addListener(
      () => setState(() => _passwordError = null),
    );
  }

  void _validateFields() {
    setState(() {
      _nameError = _nameController.text.isEmpty ? "Name is required" : null;
      _emailError = _validateEmail(_emailController.text);
      _passwordError = _validatePassword(_passwordController.text);
    });

    if (_nameError == null && _emailError == null && _passwordError == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Sign Up Successful")));

      // Redirect to LogIn page after 1 second
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LogIn()),
        );
      });
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
      backgroundColor: const Color(0xFFA7E063), // Light green background
      body: SafeArea(
        child: Column(
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 30,
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
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "SIGN IN",
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFFC6E69A,
                        ), // Light green input background
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          _buildTextField(_nameController, "Name"),
                          if (_nameError != null) _buildErrorText(_nameError!),

                          const SizedBox(height: 10),

                          _buildTextField(_emailController, "Email"),
                          if (_emailError != null)
                            _buildErrorText(_emailError!),

                          const SizedBox(height: 10),

                          _buildPasswordField(),
                          if (_passwordError != null)
                            _buildErrorText(_passwordError!),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

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
                        "SIGN IN",
                        style: TextStyle(
                          fontFamily: 'Fredoka',
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Bottom text (Fixed at the bottom)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an Account?",
                    style: TextStyle(fontFamily: 'Fredoka', fontSize: 14),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LogIn()),
                      );
                    },
                    child: const Text(
                      "LOG IN",
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
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

  // Common TextField Widget
  Widget _buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontFamily: 'Fredoka', color: Colors.grey),
        border: InputBorder.none,
      ),
    );
  }

  // Password Field with Visibility Toggle
  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: "Password",
        hintStyle: const TextStyle(fontFamily: 'Fredoka', color: Colors.grey),
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
    );
  }

  // Error Text Widget
  Widget _buildErrorText(String error) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          error,
          style: const TextStyle(
            fontFamily: 'Fredoka',
            fontSize: 14,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
