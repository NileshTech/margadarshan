import 'package:bot_toast/bot_toast.dart';
import 'package:margadarshan/page_models/reward_model.dart';
import 'package:margadarshan/pages/user_on_boaring/user_on_boarding_final_page.dart';

import 'helpers/helper_index.dart';
import 'pages/a_pages_index.dart';

ThemeData _buildYipliTheme() {
  final ThemeData base = ThemeData.light();
  final ThemeData yipliTheme = base.copyWith(
    backgroundColor: appbackgroundcolor,
    accentColor: accentcolor,
    primaryColor: primarycolor,
    primaryColorLight: justwhite,
    unselectedWidgetColor: primarycolor,
    primaryColorDark: appbackgroundcolor,
    disabledColor: justwhite,
    buttonColor: accentcolor,
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: accentcolor,
    ),
    scaffoldBackgroundColor: justwhite,
    iconTheme: IconThemeData(color: accentcolor),
    textTheme: TextTheme(
      headline5: base.textTheme.headline5.copyWith(
        color: justwhite,
        fontFamily: 'Lato',
      ),
      subtitle1: base.textTheme.subtitle1.copyWith(
        color: justwhite,
        fontFamily: 'Lato',
      ),
      subtitle2: base.textTheme.subtitle2.copyWith(
        color: justwhite,
        fontFamily: 'Lato',
      ),
      bodyText2: base.textTheme.bodyText2.copyWith(
        color: justwhite,
        fontFamily: 'Lato',
      ),
      bodyText1: base.textTheme.bodyText1.copyWith(
        color: justwhite,
        fontFamily: 'Lato',
      ),
      button: base.textTheme.button.copyWith(
        color: justwhite,
        fontFamily: 'Lato',
      ),
      caption: base.textTheme.caption.copyWith(
        color: justwhite,
        fontFamily: 'Lato',
      ),
      overline: base.textTheme.overline.copyWith(
        color: justwhite,
        fontFamily: 'Lato',
      ),
      headline4: base.textTheme.headline4.copyWith(
        color: justwhite,
        fontFamily: 'Lato',
      ),
      headline3: base.textTheme.headline3.copyWith(
        color: justwhite,
        fontFamily: 'Lato',
      ),
      headline2: base.textTheme.headline2.copyWith(
        color: justwhite,
        fontFamily: 'Lato',
      ),
      headline1: base.textTheme.headline1.copyWith(
        color: justwhite,
        fontFamily: 'Lato',
      ),
      headline6: base.textTheme.headline6.copyWith(
        color: justwhite,
        fontFamily: 'Lato',
      ),
    ),
  );

  return yipliTheme;
}

void main() {
  /*initializeApp(
      apiKey: "AIzaSyA6j97oUtRMB8Cp9JPC8c__Hwc9oW3ByPM",
      authDomain: "yipli-project.firebaseapp.com",
      databaseURL: "https://yipli-project.firebaseio.com",
      projectId: "yipli-project",
      storageBucket: "yipli-project.appspot.com");*/

  String flare = "assets/flare/yipli_rive.flr";
  timeDilation = 1.0;

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(YipliApp(flare: flare));
  });
}

class YipliApp extends StatefulWidget {
  const YipliApp({
    Key key,
    @required this.flare,
  }) : super(key: key);

  final String flare;

  @override
  _YipliAppState createState() => _YipliAppState();
}

class _YipliAppState extends State<YipliApp> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire

  @override
  Widget build(BuildContext context) {
    //* Show error message if initialization failed
    if (_error) {
      print('Error on main page is - $_error');
      (YipliUtils.appConnectionStatus == AppConnectionStatus.DISCONNECTED)
          ? NoNetworkPage()
          : NotPageFound();
    }

    final botToastBuilder = BotToastInit();

    //* checking if the app is online or offline

    YipliUtils.manageAppConnectivity(context);
    return MultiProvider(
      child: FeatureDiscovery(
        child: FutureBuilder<List>(
            future: YipliAppInitializer.initialize(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return (YipliUtils.appConnectionStatus ==
                        AppConnectionStatus.DISCONNECTED)
                    ? NoNetworkPage()
                    : NotPageFound();
              }
              if (snapshot.connectionState == ConnectionState.done) {
                print(
                    "Last App Opened from Local Storage: ${YipliAppLocalStorage.getData(YipliConstants.lastOpenedDateTime)}");
                return MaterialApp(
                  builder: (context, child) {
                    child = botToastBuilder(context, child);
                    return child;
                  },
                  theme: _buildYipliTheme(),
                  debugShowCheckedModeBanner: false,
                  color: _buildYipliTheme().primaryColor,
                  title: 'Yipli',
                  onGenerateRoute: (settings) {
                    switch (settings.name) {
                      case ForgotPassword.routeName:
                        return PageTransition(
                          child: ForgotPassword(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case Login.routeName:
                        return PageTransition(
                          child: Login(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case SignUp.routeName:
                        return PageTransition(
                          child: SignUp(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case UserProfile.routeName:
                        return PageTransition(
                          child: UserProfile(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case UserEditProfile.routeName:
                        return PageTransition(
                          child: UserEditProfile(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case PlayerPage.routeName:
                        return PageTransition(
                          child: PlayerPage(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case PlayerEditProfile.routeName:
                        return PageTransition(
                          child: PlayerEditProfile(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case PlayerRewards.routeName:
                        return PageTransition(
                          child: PlayerRewards(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case PlayerPassport.routeName:
                        return PageTransition(
                          child: PlayerPassport(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case PlayerOnBoarding.routeName:
                        return PageTransition(
                          child: PlayerOnBoarding(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case RegisterMatPage.routeName:
                        return PageTransition(
                          child: RegisterMatPage(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case AddNewMatPage.routeName:
                        return PageTransition(
                          child: AddNewMatPage(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case MatMenuPage.routeName:
                        return PageTransition(
                          child: MatMenuPage(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case Logout.routeName:
                        return PageTransition(
                          child: Logout(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case ViewImage.routeName:
                        return PageTransition(
                          child: ViewImage(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case PlayerAdd.routeName:
                        return PageTransition(
                          child: PlayerAdd(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case ComingSoonPage.routeName:
                        return PageTransition(
                          child: ComingSoonPage(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case IntroScreen.routeName:
                        return PageTransition(
                          child: IntroScreen(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case VerificationScreen.routeName:
                        return PageTransition(
                          child: VerificationScreen(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case FitnessGaming.routeName:
                        return PageTransition(
                          child: FitnessGaming(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case FaqListScreen.routeName:
                        return PageTransition(
                          child: FaqListScreen(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case ExcerciseListScreen.routeName:
                        return PageTransition(
                          child: ExcerciseListScreen(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;

                      case PlayerProfilePage.routeName:
                        return PageTransition(
                          child: PlayerProfilePage(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case AdventureGaming.routeName:
                        return PageTransition(
                          child: AdventureGaming(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case RemotePlay.routeName:
                        return PageTransition(
                          child: RemotePlay(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case StartJourney.routeName:
                        return PageTransition(
                          child: StartJourney(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case YipliFeed.routeName:
                        return PageTransition(
                          child: YipliFeed(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case SettingsPage.routeName:
                        return PageTransition(
                          child: SettingsPage(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case NoNetworkPage.routeName:
                        return PageTransition(
                          child: NoNetworkPage(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case WorldSelectionPage.routeName:
                        return PageTransition(
                          child: WorldSelectionPage(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                      case UserOnBoardingFinalPage.routeName:
                        return PageTransition(
                          child: UserOnBoardingFinalPage(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;

                      case PlayerQuestioner.routeName:
                        return PageTransition(
                          child: PlayerQuestioner(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;

                      default:
                        return PageTransition(
                          child: NotPageFound(),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 375),
                          settings: settings,
                        );
                        break;
                    }
                  },
                  navigatorKey: YipliUtils.navigatorKey,
                  home: Padding(
                    padding: const EdgeInsets.all(45.0),
                    child: SplashScreen.callback(
                      isLoading: false,
                      fit: BoxFit.contain,
                      name: widget.flare,
                      startAnimation: 'yipliflare',
                      loopAnimation: 'yipliflare',
                      backgroundColor: yipliBlack,
                      onSuccess: (data) {
                        // YipliUtils.navigatorKey.currentState
                        //     .pushReplacementNamed(FitnessGaming.routeName);
                        YipliUtils.navigatorKey.currentState
                            .pushReplacementNamed(FitnessGaming.routeName);
                      },
                      onError: (error, stacktrace) {
                        YipliUtils.navigatorKey.currentState
                            .pushReplacementNamed(FitnessGaming.routeName);
                      },
                    ),
                  ),
                );
              } else {
                return MaterialApp(
                  color: appbackgroundcolor,
                  home: Center(
                    child: YipliLoaderMini(
                      loadingMessage: 'Loading Yipli App',
                    ),
                  ),
                );
              }
            }),
      ),
      providers: [
        ChangeNotifierProvider<PlayerOnBoardingStateModel>(
          create: (context) {
            PlayerOnBoardingStateModel playerOnBoardingStateModel =
                new PlayerOnBoardingStateModel();
            return playerOnBoardingStateModel;
          },
        ),
        ChangeNotifierProvider<UserModel>(
          create: (BuildContext context) {
            UserModel currentUser = new UserModel();
            currentUser.initialize();
            return currentUser;
          },
        ),
        ChangeNotifierProxyProvider<UserModel, CurrentPlayerModel>(
            create: (playerModelCtx) {
          CurrentPlayerModel currentPlayerModel = new CurrentPlayerModel();

          print("Returned CURRENT player model - MAIN");
          return currentPlayerModel;
        }, update:
                (updateCurrentPlayerModelCtx, currentUser, currentPlayerModel) {
          currentPlayerModel.currentPlayerId = currentUser.currentPlayerId;
          currentPlayerModel.initialize();
          return currentPlayerModel;
        }),
        ChangeNotifierProxyProvider<UserModel, AllPlayersModel>(
            create: (allPlayersModelCtx) {
          AllPlayersModel allPlayersModel = new AllPlayersModel();
          print("Returned ALL player model - MAIN");
          return allPlayersModel;
        }, update: (updateAllPlayerModelCtx, currentUser, allPlayersModel) {
          allPlayersModel.initialize();
          return allPlayersModel;
        }),
        ChangeNotifierProxyProvider<UserModel, MatsModel>(
            create: (matsModelCtx) {
          MatsModel matsModel = new MatsModel.initialize();
          print("Returned ALL player model - MAIN");
          return matsModel;
        }, update: (updateAllPlayerModelCtx, currentUser, matsModel) {
          matsModel = new MatsModel.initialize();
          return matsModel;
        }),
        ChangeNotifierProxyProvider<UserModel, CurrentMatModel>(
            create: (currentMatModelCtx) {
          CurrentMatModel currentMatModel = CurrentMatModel(null);
          return currentMatModel;
        }, update: (updateAllPlayerModelCtx, currentUser, currentMatModel) {
          currentMatModel.currentMatId = currentUser.currentMatId;
          return currentMatModel;
        }),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
