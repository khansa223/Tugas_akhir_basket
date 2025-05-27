import 'package:flutter/material.dart';

class DraggablePlayer extends StatelessWidget {
  final String label;
  final Color color;
  final Offset initialPosition;
  final void Function(Offset) onDragEnd;

  const DraggablePlayer({
    super.key,
    required this.label,
    required this.color,
    required this.initialPosition,
    required this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: initialPosition.dx,
      top: initialPosition.dy,
      child: Draggable<String>(
        data: label,
        feedback: _buildPlayerCircle(opacity: 0.7),
        childWhenDragging: Container(),
        onDragEnd: (details) {
          onDragEnd(details.offset);
        },
        child: _buildPlayerCircle(),
      ),
    );
  }

  Widget _buildPlayerCircle({double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
