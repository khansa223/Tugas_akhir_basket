import 'package:flutter/material.dart';

class HalfcourtView extends StatelessWidget {
  const HalfcourtView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.black,
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          'assets/half_court.png',
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
