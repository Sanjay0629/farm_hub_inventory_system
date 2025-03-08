import "package:flutter/material.dart";

class ConsumerFarmerLoginPage extends StatelessWidget {
  const ConsumerFarmerLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -68,
            left: -87,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: Color.fromRGBO(169, 224, 110, 0.75),
            ),
          ),
          Positioned(
            top: 119,
            left: -68,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Color.fromRGBO(235, 233, 109, 0.75),
            ),
          ),
          Positioned(
            left: 143,
            top: 814,
            child: CircleAvatar(
              radius: 104,
              backgroundColor: Color(0xBFA8DF6E),
            ),
          ),
          Positioned(
            left: 275,
            top: 670,
            child: CircleAvatar(
              radius: 130,
              backgroundColor: Color(0xBFEAE86C),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 150,
                  backgroundImage: AssetImage("assets/images/consumer.png"),
                ),
              ),
              Center(
                child: CircleAvatar(
                  radius: 150,
                  backgroundImage: AssetImage("assets/images/consumer.png"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
