import 'package:flutter/material.dart';
import '../models/player_model.dart';

class BenchView extends StatelessWidget {
  final List<PlayerModel> benchPlayers;
  final void Function(PlayerModel) onPlayerDraggedBack;

  const BenchView({
    Key? key,
    required this.benchPlayers,
    required this.onPlayerDraggedBack,
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
    return DragTarget<PlayerModel>(
      onWillAccept: (player) => player != null,
      onAccept: (player) {
        onPlayerDraggedBack(player);
      },
      builder: (context, candidateData, rejectedData) {
        return SizedBox(
          height: 60,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: benchPlayers.map((player) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Draggable<PlayerModel>(
                  data: player,
                  feedback: Material(
                    color: Colors.transparent,
                    child: _buildPlayerCircle(player, opacity: 0.7),
                  ),
                  childWhenDragging: Container(
                    width: 40,
                    height: 40,
                    color: Colors.grey.shade300,
                  ),
                  child: _buildPlayerCircle(player),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
