import 'package:flutter/material.dart';
import '../models/player_model.dart';
import 'bench_view.dart';
import 'court_view.dart';
import '../widgets/court_switcher.dart';

class TacticalBoardScreen extends StatefulWidget {
  const TacticalBoardScreen({super.key});

  @override
  State<TacticalBoardScreen> createState() => _TacticalBoardScreenState();
}

class _TacticalBoardScreenState extends State<TacticalBoardScreen> {
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
    // Placeholder widget, replace with your actual UI
    return Scaffold(
      
    );
  }
}
