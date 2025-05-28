import 'package:flutter/material.dart';

class FullcourtView extends StatelessWidget {
  const FullcourtView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.black,
        child: Image.asset(
          'assets/full_court.png',
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
