import 'package:margadarshan/helpers/liquid_pull_to_refresh.dart';
import 'package:margadarshan/helpers/update_helper.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart'
    as staggeredAnimations;

import 'a_pages_index.dart';

enum GamesPageRowType { GAMES, CLASSES }

class GamesPage extends StatefulWidget {
  static String routeName = "/games_page";

  @override
  _GamesPageState createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  @override
  void initState() {
    super.initState();
    NewVersion(
      context: context,
      androidId: 'com.yipli.app',
    ).showAlertIfNecessary();
  }

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;

    return ChangeNotifierProvider<GamesModel>(
      child:
          Consumer3<GamesModel, CurrentPlayerModel, PlayerOnBoardingStateModel>(
        builder: (context, allGamesModel, currentPlayerModel,
            playerOnBoardingStateModel, child) {
          Future<Null> refreshList() async {
            setState(() {});
            await Future.delayed(Duration(seconds: 1));
          }

          if (allGamesModel == null) {
            return YipliLoaderMini(
              loadingMessage: "Loading your games ... ",
            );
          }
          if (allGamesModel.allGames.length == 0) {
            return YipliLoaderMini(
              loadingMessage: "Loading your games ... ",
            );
          }
          if (currentPlayerModel.player.id != null) {
            if (!playerOnBoardingStateModel.isInProgress)
              YipliUtils.showDailyTipForCurrentPlayer(
                  context, currentPlayerModel.player.id);
          }

          return Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            color: Theme.of(context).backgroundColor,
            child: LiquidPullToRefresh(
              showChildOpacityTransition: false,
              animSpeedFactor: 5.0,
              onRefresh: refreshList,
              backgroundColor: yipliNewBlue,
              //  yipliWhite.withOpacity(0.7),
              color: yipliBlack,
              child: ListView.builder(
                itemCount: allGamesModel.allGames.length,
                itemExtent: _screenSize.height / 8,
                itemBuilder: (BuildContext context, int index) {
                  GameDetails currentGame = allGamesModel.allGames[index];
                  return staggeredAnimations.AnimationConfiguration
                      .staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 250),
                    delay: Duration(milliseconds: 75),
                    child: staggeredAnimations.FadeInAnimation(
                      child: staggeredAnimations.SlideAnimation(
                        verticalOffset: 50.0,
                        child: GamesDisplayListItem(
                          //height: 50,
                          description: currentGame.description,
                          intensity: currentGame.intensityLevel,
                          name: currentGame.name,
                          imageLink: currentGame.iconImgUrl,
                          rating: 4.5,
                          iosURL: currentGame.iosUrl,
                          androidURL: currentGame.androidUrl,
                          windowsURL: currentGame.windowsUrl,
                          // color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
          // }
        },
      ),
      create: (BuildContext context) {
        GamesModel allGamesModel = GamesModel();
        allGamesModel.initialize();

        return allGamesModel;
      },
    );
  }
}

class YipliLoaderMini extends StatelessWidget {
  final String loadingMessage;
  const YipliLoaderMini({
    Key key,
    this.loadingMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Jello(
            child: YipliLogoLarge(
              heightScaleDownFactor: 4,
            ),
            preferences: AnimationPreferences(
              duration: Duration(seconds: 1),
              autoPlay: AnimationPlayStates.PingPong,
            ),
          ),
          Text(
            loadingMessage,
            style: Theme.of(context).textTheme.bodyText2,
          )
        ],
      ),
    );
  }
}
