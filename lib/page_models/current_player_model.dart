import 'package:flutter/cupertino.dart';
import 'package:margadarshan/page_models/player_model.dart';

class CurrentPlayerModel extends ChangeNotifier {
  String currentPlayerId;

  PlayerModel player;
  CurrentPlayerModel();

  void initialize() {
    player = PlayerModel(playerid: currentPlayerId);
    player.initialize();
    player.addListener(() {
      notifyListeners();
    });
  }
}
