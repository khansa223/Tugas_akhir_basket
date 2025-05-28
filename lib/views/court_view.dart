import 'package:flutter/material.dart';
import '../models/player_model.dart';
import '../widgets/drawing_painter.dart';
import 'fullcourt_view.dart';
import 'halfcourt_view.dart';
import '../widgets/draggable_player.dart';

class CourtView extends StatelessWidget {
  final bool isFullCourt;
  final List<PlayerModel> playersOnCourt;
  final Map<String, Offset> playerPositions;
  final void Function(String, Offset) onPlayerPositionChanged;
  final void Function(PlayerModel) onPlayerDraggedBack;
  final List<Offset> drawingPoints;
  final VoidCallback onClearDrawing;

  const CourtView({
    Key? key,
    required this.isFullCourt,
    required this.playersOnCourt,
    required this.playerPositions,
    required this.onPlayerPositionChanged,
    required this.onPlayerDraggedBack,
    required this.drawingPoints,
    required this.onClearDrawing,
  }) : super(key: key);

  Widget _buildPlayerCircle(PlayerModel player, {double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: player.isOffense ? Colors.blue : Colors.red,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          player.label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        isFullCourt ? const FullcourtView() : const HalfcourtView(),
        GestureDetector(
          onPanUpdate: (details) {
            RenderBox box = context.findRenderObject() as RenderBox;
            Offset localPosition = box.globalToLocal(details.globalPosition);
            drawingPoints.add(localPosition);
          },
          onPanEnd: (details) {
            drawingPoints.add(const Offset(0, 0));
          },
          child: CustomPaint(
            painter: DrawingPainter(points: drawingPoints),
            size: Size.infinite,
          ),
        ),
        ...playersOnCourt.map((player) {
          final pos = playerPositions[player.id] ?? const Offset(100, 100);
          return Positioned(
            left: pos.dx,
            top: pos.dy,
            child: DraggablePlayer(
              label: player.label,
              color: player.isOffense ? Colors.blue : Colors.red,
              initialPosition: pos,
              onDragEnd: (offset) {
                onPlayerPositionChanged(player.id, offset);
              },
            ),
          );
        }).toList(),
        Positioned(
          bottom: 16,
          left: 16,
          child: ElevatedButton(
            onPressed: onClearDrawing,
            child: const Text('Clear Drawing'),
          ),
        ),
      ],
    );
  }
}
