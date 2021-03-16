import 'package:margadarshan/pages/a_pages_index.dart';

class MatPageArguments {
  String macAddress;
  UserOnBoardingFlows flowValue = UserOnBoardingFlows.NA;

  MatPageArguments([this.macAddress, this.flowValue]);
}

class PlayerPageArguments {
  List<PlayerModel> allPlayerDetails;
  UserOnBoardingFlows flowValue = UserOnBoardingFlows.NA;

  PlayerPageArguments({this.allPlayerDetails, this.flowValue});
}
