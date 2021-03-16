import 'package:margadarshan/database_models/adventure-gaming/adventure-gaming-video-watched.dart';
import 'package:margadarshan/pages/excercise_list_screen.dart';
import 'package:margadarshan/pages/player_profile_page.dart';
import 'package:margadarshan/pages/remote_play.dart';
import 'package:margadarshan/pages/user_profile.dart';
import 'package:margadarshan/widgets/timeline/startJourney.dart';
// import 'package:upgrader/upgrader.dart';
import 'a_pages_index.dart';

enum YipliBackgroundMode { light, dark }

class YipliPageFrame extends StatefulWidget {
  const YipliPageFrame({
    Key key,
    this.child,
    this.selectedIndex = 0,
    this.toShowTabBar = false,
    this.tabBar,
    this.tabsCount = 1,
    this.title,
    this.toShowBottomBar = false,
    this.backgroundMode = YipliBackgroundMode.dark,
    this.showDrawer = false,
    this.isBottomBarInactive = true,
    this.toDisableFeatures = true,
    this.widgetOnAppBar,
  })  : assert(selectedIndex != null,
            "Please select some bottombar index to show."),
        super(key: key);

  final YipliBackgroundMode backgroundMode;
  final Widget child;
  final bool isBottomBarInactive;
  final int selectedIndex;
  final bool showDrawer;
  final TabBar tabBar;
  final int tabsCount;
  final Widget title;
  final bool toDisableFeatures;
  final bool toShowBottomBar;
  final bool toShowTabBar;
  final Widget widgetOnAppBar;

  @override
  _YipliPageFrameState createState() => _YipliPageFrameState();
}

class _YipliPageFrameState extends State<YipliPageFrame>
    with TickerProviderStateMixin {
  AnimationController drawerProgress;
  GlobalKey<EnsureVisibleState> ensureKey;

  GlobalKey<State<StatefulWidget>> _drawerKey;
  static var _pageOptions;

  int _selectedPage = 0;

  @override
  void initState() {
    _selectedPage = widget.selectedIndex;
    if (!widget.toDisableFeatures) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print("Discover karu!");
        FeatureDiscovery.discoverFeatures(
          context,
          {
            YipliConstants.featureDiscoveryDrawerButtonId,
            YipliConstants.featureFitnessGamingId,
            YipliConstants.featureAdventureGamingId,
            YipliConstants.featureDiscoveryPlayerProfileId,
            YipliConstants.featureDiscoveryYipliFeedId,
            YipliConstants.featureDiscoverySwitchPlayerId,
          },
        );
      });
    }
    super.initState();
  }

  void checkFeaturesAndShow(BuildContext context) {}

  Widget buildDrawerButton() {
    drawerProgress =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _drawerKey = new GlobalKey();
    return InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          print("Opening drawer!");
          dynamic state = _drawerKey.currentState;
          drawerProgress.forward();
          state.showButtonMenu();
        },
        child: IgnorePointer(child: buildPopupMenuButton()));
  }

  ///menu items
  PopupMenuButton<int> buildPopupMenuButton() {
    PlayerPage playerPage;
    dynamic currentPlayerModel = Provider.of<CurrentPlayerModel>(context);
    return PopupMenuButton<int>(
      // padding: const EdgeInsets.all(1.0),
      key: _drawerKey,
      //Todo @Ameet - Transition to be changed
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        color: IconTheme.of(context).color,
        progress: drawerProgress,
      ),
      elevation: 24,
      color: Theme.of(context).primaryColor,
      offset: Offset.fromDirection(1.5708, 120.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      onSelected: (selected) {
        drawerProgress.reverse();
      },
      onCanceled: () {
        drawerProgress.reverse();
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: DrawTile(
              tileText: 'My family',
              tileIcon: FontAwesomeIcons.users,
              targetRoute: UserProfile.routeName),
        ),
        PopupMenuItem(
            value: 1,
            child: DrawTile(
                tileText: 'Players',
                tileIcon: FontAwesomeIcons.running,
                targetRoute: PlayerPage.routeName)),
        PopupMenuItem(
            value: 2,
            child: DrawTile(
                tileText: 'My Mats',
                tileIcon: Icons.stay_current_landscape,
                targetRoute: MatMenuPage.routeName)),
        PopupMenuItem(
          value: 4,
          child: DrawTile(
              tileText: 'FAQs',
              tileIcon: Icons.message,
              targetRoute: FaqListScreen.routeName),
        ),
        // PopupMenuItem(
        //   value: 5,
        //   child: DrawTile(
        //       tileText: 'Exercises',
        //       tileIcon: Icons.explore,
        //       targetRoute: ExcerciseListScreen.routeName),
        // ),

        PopupMenuItem(
            value: 6,
            child: Consumer<CurrentPlayerModel>(
                builder: (context, currentPlayerModel, child) {
              return DrawTile(
                  tileText: 'PC Play',
                  tileIcon: Icons.computer_sharp,
                  targetRoute: currentPlayerModel.currentPlayerId != null
                      ? RemotePlay.routeName
                      : null);
            })),
        PopupMenuItem(
          value: 3,
          child: DrawTile(
              tileText: 'Settings',
              tileIcon: FontAwesomeIcons.cog,
              targetRoute: SettingsPage.routeName),
        ),
      ],
    );
  }

  Widget addPlayerWidgetOnAppBar() {
    return Consumer3<AllPlayersModel, UserModel, PlayerOnBoardingStateModel>(
      builder: (context, allPlayersModel, userModel, playerOnBoardingStateModel,
          child) {
        playerOnBoardingStateModel.addListener(() {
          if (playerOnBoardingStateModel.playerAddedState !=
              PlayerAddedState.DEFAULT) {
            YipliUtils.showNotification(
                context: context,
                msg: playerOnBoardingStateModel.playerAddedState ==
                        PlayerAddedState.NEW_PLAYER_ADDED
                    ? "New Player Added."
                    : "First player added and made default.",
                type: SnackbarMessageTypes.SUCCESS);
            playerOnBoardingStateModel.playerAddedState =
                PlayerAddedState.DEFAULT;
          }
        });
        return FlatButton(
          onPressed: () async {
            if (!playerOnBoardingStateModel.isInProgress) {
              if (YipliUtils.appConnectionStatus ==
                  AppConnectionStatus.CONNECTED) {
                print(
                    "Number of players currently : ${allPlayersModel.allPlayers.length}");
                playerOnBoardingStateModel.isInProgress = true;
                PlayerPageArguments playerArgs = new PlayerPageArguments(
                    allPlayerDetails: allPlayersModel.allPlayers,
                    flowValue: UserOnBoardingFlows.NA);
                YipliUtils.goToPlayerOnBoardingPage(playerArgs);
              } else {
                YipliUtils.showNotification(
                    context: context,
                    msg: "Internet Connectivity is required to add new player.",
                    type: SnackbarMessageTypes.ERROR,
                    duration: SnackbarDuration.MEDIUM);
              }
            } else {
              YipliUtils.showNotification(
                  context: context,
                  msg: "Player addition is in process. Kindly wait.",
                  type: SnackbarMessageTypes.WARN,
                  duration: SnackbarDuration.MEDIUM);
            }
          },
          child: DescribedFeatureOverlay(
            featureId: YipliConstants.featureDiscoveryAddNewPlayerId,
            tapTarget: Icon(
              Icons.add,
              color: Theme.of(context).accentColor,
            ),
            title: Text('Add Player'),
            description: Text('\nAdd a new player to begin playing!'),
            backgroundColor: Theme.of(context).accentColor,
            contentLocation: ContentLocation.below,
            child: Icon(
              Icons.add,
              color: Theme.of(context).accentColor,
            ),
          ),
        );
      },
    );
  }

  ///bottom navigation bar

  Widget buildBottomNavigationBar() {
    var currentPlayerModel = Provider.of<CurrentPlayerModel>(context);
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40.0),
        child: AdventureGamingVideoWatchedValidator(
            playerModel: currentPlayerModel.player,
            builder: (context, hasPlayerWatchedVideoSnapshot) {
              return BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                currentIndex: _selectedPage,
                unselectedItemColor:
                    Theme.of(context).primaryColorLight.withOpacity(0.6),
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.6),
                type: BottomNavigationBarType.fixed,
                selectedItemColor: widget.isBottomBarInactive
                    ? Theme.of(context).primaryColorLight.withOpacity(0.7)
                    : yipliLogoOrange,
                onTap: (int index) {
                  if (currentPlayerModel.currentPlayerId != null) {
                    setState(() {
                      if (_selectedPage != index) {
                        print('selected page - $_selectedPage');
                        if (index == 1 &&
                            hasPlayerWatchedVideoSnapshot.connectionState !=
                                ConnectionState.waiting) {
                          String pageOptionForRouting =
                              (hasPlayerWatchedVideoSnapshot?.data ?? false)
                                  ? AdventureGaming.routeName
                                  : StartJourney.routeName;
                          _pageOptions[1] = pageOptionForRouting;
                          YipliUtils.goToRoute(
                            pageOptionForRouting,
                            true,
                          );
                        }
                        if (index != 4) {
                          _selectedPage = index;
                          YipliUtils.goToRoute(_pageOptions[index], true);
                        } else
                          SwitchPlayerModalButton.showAndSetSwitchPlayerModal(
                              currentPlayerModel, context);
                      } else {
                        if (widget.isBottomBarInactive) {
                          if (index != 4)
                            YipliUtils.goToRoute(_pageOptions[index], true);
                        }
                        print('Not changing the tab');
                      }
                    });
                  } else
                    YipliUtils.showNotification(
                        context: context,
                        msg: "Please add player and check again.",
                        type: SnackbarMessageTypes.ERROR,
                        duration: SnackbarDuration.MEDIUM);
                },
                items: [
                  ///BNBI - fitness gaming
                  BottomNavigationBarItem(
                    icon:
                        // DescribedFeatureOverlay(
                        //     contentLocation: ContentLocation.above,
                        //     featureId: YipliConstants.featureFitnessGamingId,
                        //     tapTarget: const Icon(FontAwesomeIcons.gamepad),
                        //     title: Text('Yipli Player Fitness gaming'),
                        //     description:
                        //         Text('Here you would see your Fitness games!'),
                        //     backgroundColor: Theme.of(context).accentColor,
                        //     child:
                        Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Icon(
                            FontAwesomeIcons.gamepad,
                            size: 20,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text('Games',
                            style: Theme.of(context)
                                .textTheme
                                .overline
                                .copyWith(letterSpacing: 0)),
                      ],
                    ),
                    // ),
                    label: ('Games'),
                  ),

                  ///BNBI - adventure gaming
                  BottomNavigationBarItem(
                    icon:
                        //  DescribedFeatureOverlay(
                        //     contentLocation: ContentLocation.above,
                        //     featureId: YipliConstants.featureAdventureGamingId,
                        //     tapTarget: const Icon(FontAwesomeIcons.hiking),
                        //     title: Text('Yipli Player Adventure gaming'),
                        //     description: Text(
                        //         'Here you would see your adventure gaming journey!'),
                        //     backgroundColor: Theme.of(context).accentColor,
                        //     child:
                        Column(
                      children: [
                        Icon(
                          FontAwesomeIcons.hiking,
                          size: 20,
                        ),
                        SizedBox(height: 5),
                        Text('Adventure',
                            style: Theme.of(context)
                                .textTheme
                                .overline
                                .copyWith(letterSpacing: 0)),
                      ],
                      // )
                    ),
                    label: 'Adventure Gaming',
                  ),

                  ///BNBI - place holder
                  BottomNavigationBarItem(icon: Container(), label: ""),

                  ///BNBI - yipli feed
                  BottomNavigationBarItem(
                    icon:
                        // DescribedFeatureOverlay(
                        //     contentLocation: ContentLocation.above,
                        //     featureId: YipliConstants.featureDiscoveryYipliFeedId,
                        //     tapTarget: const Icon(FontAwesomeIcons.list),
                        //     title: Text('Yipli Feed'),
                        //     description: Text('Here you would find Yipli Feed!'),
                        //     backgroundColor: Theme.of(context).accentColor,
                        //     child:
                        Column(
                      children: [
                        Icon(EvaIcons.list),
                        SizedBox(height: 5),
                        Text('Feed',
                            style: Theme.of(context)
                                .textTheme
                                .overline
                                .copyWith(letterSpacing: 0))
                      ],
                      // )
                    ),
                    label: 'Yipli Feed',
                  ),

                  ///BNBI - switch player
                  BottomNavigationBarItem(
                      label: 'Switch Player',
                      icon: Consumer2<UserModel, CurrentPlayerModel>(
                        builder: (BuildContext currentContext,
                            UserModel currentUser,
                            CurrentPlayerModel currentPlayerModel,
                            Widget child) {
                          return
                              // DescribedFeatureOverlay(
                              //     featureId:
                              //         YipliConstants.featureDiscoverySwitchPlayerId,
                              //     tapTarget: Icon(
                              //       EvaIcons.swapOutline,
                              //     ),
                              //     title: Text('Switch Player'),
                              //     description: Text(
                              //         'Tap here to switch the current player!'),
                              //     backgroundColor: Theme.of(context).accentColor,
                              //     child:
                              Column(
                            children: [
                              Icon(
                                EvaIcons.swapOutline,
                              ),
                              SizedBox(height: 5),
                              Text('Switch',
                                  style: Theme.of(context)
                                      .textTheme
                                      .overline
                                      .copyWith(letterSpacing: 0))
                            ],
                          );

                          //                      SwitchPlayerModalButton(
                          //                        screenSize: screenSize,
                          //                        playerId: currentUser.currentPlayerId,
                          //                      ),
                          // );
                        },
                      )),
                ],
              );
            }),
      ),
    );
  }

  getTitleWidget(BuildContext context, Widget title) {
    if (title is Text) {
      return Text(title.data,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Theme.of(context).accentColor));
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    _pageOptions = [
      FitnessGaming.routeName, // index = 0
      "", // index = 1
      PlayerProfilePage.routeName, // index = 2 hidden
      YipliFeed.routeName, //index = 3
      //SwitchPlayerModalButton.routeName //index = 4
    ];

    checkFeaturesAndShow(context);
    var currentPlayerModel = Provider.of<CurrentPlayerModel>(context);
    bool hasParentPage = Navigator.of(context).canPop();
    print("YipliPageFrame for ${widget.title} -- $hasParentPage");
    return DefaultTabController(
      length: widget.tabsCount,
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            centerTitle: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            backgroundColor: appbackgroundcolor,
            title: getTitleWidget(context, widget.title),
            leading: widget.showDrawer
                ?
                // DescribedFeatureOverlay(
                // featureId: YipliConstants.featureDiscoveryDrawerButtonId,
                // tapTarget: Icon(Icons.menu),
                // title: Text('Add new Mats and Players'),
                // description: Text(
                //     '\nUnder Menu go to \'My Mats\' to add a new mat\n\nAnd then go to \'Players\' to add a new player '),
                // backgroundColor: Theme.of(context).accentColor,
                // child:
                buildDrawerButton()
                // )
                : (hasParentPage
                    ? IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    : null),
            actions: <Widget>[
              widget.widgetOnAppBar != null
                  ? (widget.widgetOnAppBar)
                  : Container()
            ],
          ),
          body: Stack(
            children: <Widget>[
              Container(
                color: (widget.backgroundMode == YipliBackgroundMode.light)
                    ? Theme.of(context).primaryColorLight
                    : Theme.of(context).backgroundColor,
              ),
              widget.child,
            ],
          ),
          bottomNavigationBar: (widget.toShowBottomBar)
              ? Stack(
                  children: <Widget>[
                    IgnorePointer(
                      ignoring: true,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          transform: GradientRotation(pi / 2),
                          // EEE,0; 818181,46; 383838,76;222,86; 101010,93;000, 100
                          colors: [
                            Color(0xFF101010).withOpacity(0.0),
                            Color(0xFF101010).withOpacity(0.0),
                            Color(0xFF000000),
                            Color(0xFF101010)
                          ],
                          stops: [0, 0.3, 0.6, 1],
                        )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.2),
                      child: BottomAppBar(
                        shape: CircularNotchedRectangle(),
                        notchMargin: 4,
                        color: Colors.transparent,
                        clipBehavior: Clip.antiAlias,
                        child: buildBottomNavigationBar(),
                      ),
                    ),
                  ],
                )
              : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: (widget.toShowBottomBar)
              ? Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.47),
                  child: Material(
                    type: MaterialType.transparency,
                    child: Ink(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: _selectedPage == 2
                                ? yipliLogoOrange
                                : Theme.of(context)
                                    .primaryColorLight
                                    .withOpacity(0.7),
                            width: 3.0),
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width * 0.12,
                        width: MediaQuery.of(context).size.width * 0.12,
                        child: FloatingActionButton(
                          backgroundColor: appbackgroundcolor,
                          heroTag: 'bottom-bar-profile-pic',
                          onPressed: () {
                            print('printing selected page on pressed');

                            if (currentPlayerModel.currentPlayerId != null) {
                              YipliUtils.navigatorKey.currentState
                                  .pushReplacementNamed(
                                      PlayerProfilePage.routeName);
                            } else {
                              YipliUtils.showNotification(
                                  context: context,
                                  msg: "Please add player and check again.",
                                  type: SnackbarMessageTypes.ERROR,
                                  duration: SnackbarDuration.MEDIUM);
                            }
                          },
                          child: Consumer<CurrentPlayerModel>(
                            builder: (context, currentPlayerModel, child) {
                              return DescribedFeatureOverlay(
                                featureId: YipliConstants
                                    .featureDiscoveryPlayerProfileId,
                                tapTarget: YipliUtils.getProfilePicImageIcon(
                                    context,
                                    currentPlayerModel.player.profilePicUrl,
                                    _selectedPage == 2),
                                title: Text('Yipli Profile Page'),
                                description: Text(
                                    'Here you would find your Yipli Profile!'),
                                backgroundColor: Theme.of(context).accentColor,
                                child: YipliUtils.getProfilePicImageIcon(
                                    context,
                                    currentPlayerModel.player.profilePicUrl,
                                    _selectedPage == 2),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    // onPressed: () {},
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
