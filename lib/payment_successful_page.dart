import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:farm_hub/browse_farm_page.dart';
import 'package:flutter/material.dart';

class PaymentSuccessfulPage extends StatefulWidget {
  final String farmerId;

  const PaymentSuccessfulPage({super.key, required this.farmerId});

  @override
  State<PaymentSuccessfulPage> createState() => _PaymentSuccessfulPageState();
}

class _PaymentSuccessfulPageState extends State<PaymentSuccessfulPage> {
  bool _hasRated = false;

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyRated();
  }

  Future<void> _checkIfAlreadyRated() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ratingDoc =
        await FirebaseFirestore.instance
            .collection('farmers')
            .doc(widget.farmerId)
            .collection('ratings')
            .doc(user.uid)
            .get();

    if (ratingDoc.exists) {
      setState(() {
        _hasRated = true;
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showRatingPopup());
    }
  }

  void _showRatingPopup() {
    int selectedRating = 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFF4FFD9),
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Rate Your Experience',
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "How would you rate this farmer?",
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            Icons.star,
                            color:
                                index < selectedRating
                                    ? Colors.orange
                                    : Colors.grey,
                            size: 30,
                          ),
                          onPressed: () {
                            setDialogState(() {
                              selectedRating = index + 1;
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Maybe later",
                            style: TextStyle(
                              fontFamily: 'Fredoka',
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed:
                              selectedRating > 0
                                  ? () async {
                                    await _submitRating(selectedRating);
                                    Navigator.pop(context);
                                    _showToast("🎉 Thank you for rating!");
                                  }
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Submit",
                            style: TextStyle(fontFamily: 'Fredoka'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _submitRating(int rating) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ratingRef = FirebaseFirestore.instance
        .collection('farmers')
        .doc(widget.farmerId)
        .collection('ratings')
        .doc(user.uid);

    await ratingRef.set({'rating': rating});
    setState(() {
      _hasRated = true;
    });
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Fredoka')),
        backgroundColor: const Color(0xFFA8DF6E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: Stack(
        children: [
          // Background Circles
          Positioned(
            top: -68,
            left: -87,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: const Color.fromRGBO(169, 224, 110, 0.75),
            ),
          ),
          Positioned(
            top: 119,
            left: -68,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: const Color.fromRGBO(235, 233, 109, 0.75),
            ),
          ),
          Positioned(
            left: 275,
            top: 670,
            child: CircleAvatar(
              radius: 130,
              backgroundColor: const Color(0xBFA8DF6E),
            ),
          ),

          // Success Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset("assets/images/success.png", width: 250),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Congratulations!",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: "Fredoka",
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(17, 26, 44, 1),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  "You have successfully made\nthe payment, enjoy our service!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),

          // Return to home
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BrowseFarmsPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(
                        235,
                        233,
                        109,
                        0.75,
                      ),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          "Return to Home Page",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Fredoka",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.home, size: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
