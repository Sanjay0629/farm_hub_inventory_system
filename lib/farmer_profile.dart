import 'package:farm_hub/farm_account.dart';
import 'package:flutter/material.dart';

class FarmerProfile extends StatefulWidget {
  @override
  _FarmerProfileState createState() => _FarmerProfileState();
}

class _FarmerProfileState extends State<FarmerProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController farmNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController registrationController = TextEditingController();

  // Email Validation
  bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  // Phone Number Validation (Only Digits, 10 Digits)
  bool _isValidPhone(String phone) {
    final RegExp phoneRegex = RegExp(r'^\d{10}$'); // 10-digit number
    return phoneRegex.hasMatch(phone);
  }

  // Function to validate fields
  bool _validateFields() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty ||
        farmNameController.text.isEmpty ||
        locationController.text.isEmpty ||
        registrationController.text.isEmpty) {
      _showError("All fields are required!");
      return false;
    }

    if (!_isValidEmail(emailController.text)) {
      _showError("Enter a valid email address!");
      return false;
    }

    if (!_isValidPhone(phoneController.text)) {
      _showError("Enter a valid 10-digit phone number!");
      return false;
    }

    if (passwordController.text.length < 6) {
      _showError("Password must be at least 6 characters long!");
      return false;
    }

    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _editProfile() {
    if (!_validateFields()) return; // Stop execution if validation fails

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Edited Successfully!"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FarmAccount()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA5D76E), // Light green background
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Profile Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ),
                    const Text(
                      "My Profile",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.more_horiz, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Profile Picture
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/images/farmer1.png'),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Profile Details Section
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Personal Details
                    const Text(
                      "Personal Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(nameController, "Name"),
                    _buildTextField(emailController, "Email"),
                    _buildTextField(phoneController, "Phone"),
                    _buildTextField(
                      passwordController,
                      "Password",
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    // Farm Details
                    const Text(
                      "Farm Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(farmNameController, "Farm Name"),
                    _buildTextField(locationController, "Location"),
                    _buildTextField(
                      registrationController,
                      "Registration Number",
                    ),
                    const SizedBox(height: 30),
                    // Edit Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[800],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _editProfile,
                      child: const Text(
                        "EDIT",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom TextField Widget
  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.green),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }
}
