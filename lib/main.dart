import 'package:flutter/material.dart';
import 'views/tactical_board_screen.dart';

void main() {
  runApp(const BasketballTacticalBoardApp());
}

class BasketballTacticalBoardApp extends StatelessWidget {
  const BasketballTacticalBoardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basketball Tactical Board',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const TacticalBoardScreen(),
    );
  }
}
