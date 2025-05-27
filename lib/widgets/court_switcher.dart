import 'package:flutter/material.dart';

class CourtSwitcher extends StatelessWidget {
  final bool isFullCourt;
  final VoidCallback onToggle;

  const CourtSwitcher({
    super.key,
    required this.isFullCourt,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 36,
      icon: Icon(isFullCourt ? Icons.crop_16_9 : Icons.crop_square),
      tooltip: isFullCourt ? 'Switch to Half Court' : 'Switch to Full Court',
      onPressed: onToggle,
    );
  }
}
