import '../models/player_model.dart';

class PlayerRepository {
  final List<PlayerModel> _players = [];

  List<PlayerModel> getAllPlayers() {
    return List.unmodifiable(_players);
  }

  PlayerModel? getPlayerById(String id) {
    try {
      return _players.firstWhere((player) => player.id == id);
    } catch (e) {
      return null;
    }
  }

  void addPlayer(PlayerModel player) {
    if (!_players.any((p) => p.id == player.id)) {
      _players.add(player);
    }
  }

  void updatePlayer(PlayerModel updatedPlayer) {
    for (int i = 0; i < _players.length; i++) {
      if (_players[i].id == updatedPlayer.id) {
        _players[i] = updatedPlayer;
        break;
      }
    }
  }

  void deletePlayer(String id) {
    _players.removeWhere((player) => player.id == id);
  }

  void clear() {
    _players.clear();
  }
}
