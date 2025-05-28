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

  final List<PlayerModel> _players = [];
  final Map<String, Offset> _playerPositions = {};
  List<Offset> _drawingPoints = [];

  void _toggleCourt() {
    setState(() {
      _isFullCourt = !_isFullCourt;
      _players.clear();
      _playerPositions.clear();
      _drawingPoints.clear();
    });
  }

  void _addPlayer(PlayerModel player) {
    setState(() {
      if (!_players.any((p) => p.id == player.id)) {
        _players.add(player);
        _playerPositions[player.id] = const Offset(100, 100);
      }
    });
  }

  void _removePlayer(String id) {
    setState(() {
      _players.removeWhere((p) => p.id == id);
      _playerPositions.remove(id);
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
    final List<PlayerModel> allPlayers = [
      for (int i = 1; i <= 5; i++) PlayerModel(id: 'P$i', label: 'P$i', isOffense: true),
      for (int i = 1; i <= 5; i++) PlayerModel(id: 'D$i', label: 'D$i', isOffense: false),
    ];

    final List<PlayerModel> benchPlayers = allPlayers.where((p) => !_players.any((pl) => pl.id == p.id)).toList();

    return Scaffold(
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
            onPanEnd: (_) {
              setState(() {
                _drawingPoints = List.from(_drawingPoints)..add(const Offset(0, 0));
              });
            },
            child: CustomPaint(
              painter: DrawingPainter(points: _drawingPoints),
              size: Size.infinite,
            ),
          ),

          // Players on court
          ..._players.map((player) {
            final pos = _playerPositions[player.id] ?? const Offset(100, 100);
            return DraggablePlayer(
              key: ValueKey(player.id),
              label: player.label,
              color: player.isOffense ? Colors.blue : Colors.red,
              initialPosition: pos,
              onDragEnd: (offset) => _updatePlayerPosition(player.id, offset),
            );
          }),

          // Left column: P1–P5
          Positioned(
            top: 100,
            left: 8,
            child: Column(
              children: [
                ...benchPlayers
                    .where((p) => p.isOffense)
                    .map((player) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Draggable<PlayerModel>(
                            data: player,
                            feedback: Material(
                              color: Colors.transparent,
                              child: _buildPlayerCircle(player),
                            ),
                            childWhenDragging: Container(
                              width: 40,
                              height: 40,
                              color: Colors.grey.shade300,
                            ),
                            child: _buildPlayerCircle(player),
                          ),
                        )),
              ],
            ),
          ),

          // Right column: D1–D5
          Positioned(
            top: 100,
            right: 8,
            child: Column(
              children: [
                ...benchPlayers
                    .where((p) => !p.isOffense)
                    .map((player) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Draggable<PlayerModel>(
                            data: player,
                            feedback: Material(
                              color: Colors.transparent,
                              child: _buildPlayerCircle(player),
                            ),
                            childWhenDragging: Container(
                              width: 40,
                              height: 40,
                              color: Colors.grey.shade300,
                            ),
                            child: _buildPlayerCircle(player),
                          ),
                        )),
              ],
            ),
          ),

          // Drag area for placing players
          Positioned.fill(
            child: DragTarget<PlayerModel>(
              onAcceptWithDetails: (details) {
                final RenderBox box = context.findRenderObject() as RenderBox;
                final localOffset = box.globalToLocal(details.offset);
                if (_players.any((p) => p.id == details.data.id)) {
                  _updatePlayerPosition(details.data.id, localOffset);
                } else {
                  _addPlayer(details.data);
                  _updatePlayerPosition(details.data.id, localOffset);
                }
              },
              builder: (_, __, ___) => const SizedBox.expand(),
            ),
          ),

          // Bottom right: Clear Drawing
          Positioned(
            right: 12,
            bottom: 16,
            child: ElevatedButton(
              onPressed: _clearDrawing,
              child: const Text('Clear Drawing'),
            ),
          ),

          // Bottom left: Court Switcher
          Positioned(
            left: 12,
            bottom: 16,
            child: CourtSwitcher(
              isFullCourt: _isFullCourt,
              onToggle: _toggleCourt,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCircle(PlayerModel player) {
    return Container(
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
    );
  }
}
