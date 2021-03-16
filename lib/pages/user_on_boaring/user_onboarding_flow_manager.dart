import 'package:flutter/material.dart';
import 'package:margadarshan/classes/userOnBoardingFlow.dart';
import 'package:margadarshan/pages/user_on_boaring/user_on_boarding_mat_add_page.dart';
import 'package:margadarshan/pages/user_on_boaring/user_on_boarding_player_add_page.dart';

class UserOnBoardingFlowManager {
  static final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  static Widget chooseFlow(UserOnBoardingFlows flowValue) {
    switch (flowValue) {
      case UserOnBoardingFlows.FLOW1:
        return UserOnBoardingMatAddPage(flowValue);
        break;
      case UserOnBoardingFlows.FLOW2:
        return UserOnBoardingMatAddPage(flowValue);
        break;
      case UserOnBoardingFlows.FLOW3:
        return UserOnBoardingPlayerAddPage(flowValue);
        break;
      case UserOnBoardingFlows.NA:
      default:
        return Container();
        // TODO: Handle this case.
        break;
    }
  }
}
