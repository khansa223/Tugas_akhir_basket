import 'package:flutter/material.dart';
import '../models/player_model.dart';
import 'bench_view.dart';
import 'court_view.dart';
import '../widgets/court_switcher.dart';
import 'tactical_board_screen_part1.dart';

// Define _TacticalBoardScreenState if not already defined elsewhere
class _TacticalBoardScreenState extends State<TacticalBoardScreen> {
  // Add required fields and methods here or import the correct file if already defined
  // Example placeholders:
  bool _isFullCourt = true;
  List<PlayerModel> _playersOnCourt = [];
  Map<String, Offset> _playerPositions = {};
  List<Offset> _drawingPoints = [];

  void _updatePlayerPosition(String id, Offset position) {}
  void _removePlayerFromCourt(PlayerModel player) {}
  void _clearDrawing() {}
  void _addPlayerToCourt(PlayerModel player) {}
  void _toggleCourt() {}

  @override
  Widget build(BuildContext context) {
    final List<PlayerModel> allPlayers = [
      for (int i = 1; i <= 5; i++) PlayerModel(id: 'P$i', label: 'P$i', isOffense: true),
      for (int i = 1; i <= 5; i++) PlayerModel(id: 'D$i', label: 'D$i', isOffense: false),
    ];

    final List<PlayerModel> benchPlayers = allPlayers.where((p) => !_playersOnCourt.any((pl) => pl.id == p.id)).toList();

    return Scaffold(
     
  
      body: Stack(
        children: [
          CourtView(
            isFullCourt: _isFullCourt,
            playersOnCourt: _playersOnCourt,
            playerPositions: _playerPositions,
            onPlayerPositionChanged: _updatePlayerPosition,
            onPlayerDraggedBack: _removePlayerFromCourt,
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
