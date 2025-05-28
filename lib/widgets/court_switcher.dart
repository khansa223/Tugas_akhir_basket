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
    return ElevatedButton.icon(
      onPressed: onToggle,
      icon: Icon(isFullCourt ? Icons.crop_16_9 : Icons.switch_right),
      label: Text(isFullCourt ? 'Half Court' : 'Full Court'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(fontSize: 16),
      ),
    );
  }
}
