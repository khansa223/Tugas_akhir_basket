import 'package:flutter/material.dart';
import '../models/player_model.dart';
import 'bench_view.dart';
import 'court_view.dart';
import '../widgets/court_switcher.dart';

class TacticalBoardScreenMain extends StatefulWidget {
  const TacticalBoardScreenMain({super.key});

  @override
  State<TacticalBoardScreenMain> createState() => _TacticalBoardScreenMainState();
}

class _TacticalBoardScreenMainState extends State<TacticalBoardScreenMain> {
  bool _isFullCourt = true;

  final List<PlayerModel> _playersOnCourt = [];
  final Map<String, Offset> _playerPositions = {};

  List<Offset> _drawingPoints = [];

  void _toggleCourt() {
    setState(() {
      _isFullCourt = !_isFullCourt;
      _playersOnCourt.clear();
      _playerPositions.clear();
      _drawingPoints.clear();
    });
  }

  void _addPlayerToCourt(PlayerModel player) {
    setState(() {
      if (!_playersOnCourt.any((p) => p.id == player.id)) {
        _playersOnCourt.add(player);
        _playerPositions[player.id] = const Offset(100, 100);
      }
    });
  }

  void _removePlayerFromCourt(String id) {
    setState(() {
      _playersOnCourt.removeWhere((p) => p.id == id);
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

    final List<PlayerModel> benchPlayers = allPlayers.where((p) => !_playersOnCourt.any((pl) => pl.id == p.id)).toList();

    return Scaffold(
      
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          CourtView(
            isFullCourt: _isFullCourt,
            playersOnCourt: _playersOnCourt,
            playerPositions: _playerPositions,
            onPlayerPositionChanged: _updatePlayerPosition,
            onPlayerDraggedBack: (player) => _removePlayerFromCourt(player.id),
            drawingPoints: _drawingPoints,
            onClearDrawing: _clearDrawing,
          ),
          Positioned(
            top: 56,
            left: 0,
            right: 0,
            child: BenchView(
              benchPlayers: benchPlayers,
              onPlayerDraggedBack: _addPlayerToCourt,
            ),
          ),
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
