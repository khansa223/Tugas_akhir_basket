import 'package:flutter/material.dart';
import '../widgets/court_switcher.dart';
import '../widgets/draggable_player.dart';
import '../widgets/drawing_painter.dart';
import '../models/player_model.dart';
import 'fullcourt_view.dart';
import 'halfcourt_view.dart';

class TacticalBoardScreen extends StatefulWidget {
  const TacticalBoardScreen({super.key});

  @override
  State<TacticalBoardScreen> createState() => _TacticalBoardScreenState();
}

class _TacticalBoardScreenState extends State<TacticalBoardScreen> {
  bool _isFullCourt = true;

  // Player markers on court with positions
  final List<PlayerModel> _players = [];
  final Map<String, Offset> _playerPositions = {};

  // Drawing points
  List<Offset> _drawingPoints = [];

  void _toggleCourt() {
    setState(() {
      _isFullCourt = !_isFullCourt;
      // Clear players and drawings on court switch
      _players.clear();
      _playerPositions.clear();
      _drawingPoints.clear();
    });
  }

  void _addPlayer(PlayerModel player) {
    setState(() {
      if (!_players.any((p) => p.id == player.id)) {
        _players.add(player);
        _playerPositions[player.id] = const Offset(100, 100); // default position
      }
    });
  }

  void _updatePlayerPosition(String id, Offset position) {
    setState(() {
      _playerPositions[id] = position;
    });
  }

  void _clearDrawing() {
    setState(() {
      _drawingPoints.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // List of draggable players to add
    final List<PlayerModel> availablePlayers = [
      for (int i = 1; i <= 5; i++) PlayerModel(id: 'P$i', label: 'P$i', isOffense: true),
      for (int i = 1; i <= 5; i++) PlayerModel(id: 'D$i', label: 'D$i', isOffense: false),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Basketball Tactical Board'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          _isFullCourt ? const FullcourtView() : const HalfcourtView(),
          // Drawing canvas
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                RenderBox box = context.findRenderObject() as RenderBox;
                Offset localPosition = box.globalToLocal(details.globalPosition);
                _drawingPoints = List.from(_drawingPoints)..add(localPosition);
              });
            },
            onPanEnd: (details) {
              setState(() {
                _drawingPoints = List.from(_drawingPoints)..add(const Offset(0, 0));
              });
            },
            child: CustomPaint(
              painter: DrawingPainter(points: _drawingPoints),
              size: Size.infinite,
            ),
          ),
          // Player markers on court
          ..._players.map((player) {
            final pos = _playerPositions[player.id] ?? const Offset(100, 100);
            return DraggablePlayer(
              key: ValueKey(player.id),
              label: player.label,
              color: player.isOffense ? Colors.blue : Colors.red,
              initialPosition: pos,
              onDragEnd: (offset) {
                _updatePlayerPosition(player.id, offset);
              },
            );
          }).toList(),
          // Player selection panel at top
          Positioned(
            top: 56,
            left: 0,
            right: 0,
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: availablePlayers.map((player) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Draggable<PlayerModel>(
                    data: player,
                    feedback: Material(
                      color: Colors.transparent,
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
                    ),
                    childWhenDragging: Container(
                      width: 40,
                      height: 40,
                      color: Colors.grey.shade300,
                    ),
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
                  ),
                );
              }).toList(),
            ),
          ),
          // Drag target area for players on court
          Positioned.fill(
            child: DragTarget<PlayerModel>(
              onAcceptWithDetails: (details) {
                final RenderBox box = context.findRenderObject() as RenderBox;
                final localOffset = box.globalToLocal(details.offset);
                _addPlayer(details.data);
                _updatePlayerPosition(details.data.id, localOffset);
              },
              builder: (context, candidateData, rejectedData) {
                return const SizedBox.expand();
              },
            ),
          ),
          // Clear drawing button at bottom left
          Positioned(
            bottom: 16,
            left: 16,
            child: ElevatedButton(
              onPressed: _clearDrawing,
              child: const Text('Clear Drawing'),
            ),
          ),
          // Court switcher button at bottom center
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: CourtSwitcher(
              isFullCourt: _isFullCourt,
              onToggle: _toggleCourt,
            ),
          ),
        ],
      ),
    );
  }
}
