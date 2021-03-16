import 'package:age/age.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:margadarshan/page_models/reward_model.dart';
import 'package:margadarshan/pages/a_pages_index.dart';
import 'package:margadarshan/pages/player_rewards_page.dart';
import 'package:margadarshan/widgets/scratch_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helper_index.dart';

enum ConfirmAction { NO, YES }
enum SnackbarMessageTypes { ERROR, INFO, WARN, DEFAULT, SUCCESS }
enum SnackbarDuration { SHORT, MEDIUM, LONG }
enum AdventureGamingCardState { PLAYED, NEXT, LOCKED }
enum AppConnectionStatus { CONNECTED, DISCONNECTED }

class YipliUtils {
  static final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  static AppConnectionStatus appConnectionStatus;
  static String _smsVerificationCode;

  static void goToHomeScreen() {
    navigatorKey.currentState.pushReplacementNamed(FitnessGaming.routeName);
  }

  static void goToWorldSelectionPage() {
    navigatorKey.currentState
        .pushReplacementNamed(WorldSelectionPage.routeName);
  }

  static void goToStartJourney() {
    navigatorKey.currentState.pushReplacementNamed(StartJourney.routeName);
  }

  static void goToNoNetworkPage() {
    navigatorKey.currentState.pushReplacementNamed(NoNetworkPage.routeName);
  }

  static void goToNoFoundPage() {
    navigatorKey.currentState.pushReplacementNamed(NotPageFound.routeName);
  }

  static void goToLogoutScreen() {
    navigatorKey.currentState.pushReplacementNamed(Logout.routeName);
  }

  static void goToPlayerQuestioner() {
    navigatorKey.currentState.pushReplacementNamed(PlayerQuestioner.routeName);
  }

  static void goToVerificationScreen(
      String displayName, String email, User loggedInUser) {
    navigatorKey.currentState.pushReplacementNamed(
      VerificationScreen.routeName,
      arguments: VerificationScreenInput(
        loggedInUser: loggedInUser,
        displayName: displayName,
        email: email,
      ),
    );
  }

  static void goToPlayersPage([playerList]) {
    navigatorKey.currentState
        .pushNamed(PlayerPage.routeName, arguments: playerList);
  }

  static void replaceWithPlayersPage([playerList]) {
    navigatorKey.currentState
        .pushReplacementNamed(PlayerPage.routeName, arguments: playerList);
  }

  static void goToPlayerOnBoardingPage(
    PlayerPageArguments playerPageArgs,
  ) {
    navigatorKey.currentState
        .pushNamed(PlayerOnBoarding.routeName, arguments: playerPageArgs);
  }

  static void goToPlayerRewards(PlayerModel playerDetails) {
    navigatorKey.currentState
        .pushNamed(PlayerRewards.routeName, arguments: playerDetails);
  }

  static void goToEditPlayersPage(
      PlayerProfileArguments playerProfileArguments) {
    navigatorKey.currentState.pushNamed(PlayerEditProfile.routeName,
        arguments: playerProfileArguments);
  }

  static void goToPlayerAddPage(List<PlayerModel> allPlayerDetails) {
    navigatorKey.currentState
        .pushNamed(PlayerAdd.routeName, arguments: allPlayerDetails);
  }

  static void goToAddMatScreen(MatPageArguments args) {
    navigatorKey.currentState
        .pushReplacementNamed(AddNewMatPage.routeName, arguments: args);
  }

  static void goToMatMenu() {
    navigatorKey.currentState.pushReplacementNamed(MatMenuPage.routeName);
  }

  static void gotoAdventureGaming() {
    navigatorKey.currentState.pushReplacementNamed(AdventureGaming.routeName);
  }

  static void goToPlayerProfile(PlayerDetails playerTile) {
    navigatorKey.currentState
        .pushNamed(PlayerProfilePage.routeName, arguments: playerTile);
  }

  static void goToPlayerProfileBottomNavigation() {
    navigatorKey.currentState.pushNamed(
      PlayerProfilePage.routeName,
    );
  }

//  static void goToBuddyRequestPage(Players currentPlayer) {
//    navigatorKey.currentState
//        .pushNamed(BuddyRequest.routeName, arguments: currentPlayer);
//  }

  static void goToRewardsPage(String currentPlayerId) {
    navigatorKey.currentState
        .pushNamed(RewardsPage.routeName, arguments: currentPlayerId);
  }

  static void goToRewardsModelPage(String currentPlayerId) {
    navigatorKey.currentState.pushNamed(
        RewardsModel.getModelRef(currentPlayerId),
        arguments: currentPlayerId);
  }

  static void goToLoginScreen() {
    navigatorKey.currentState.pushReplacementNamed(Login.routeName);
  }

  static void goToIntroSliderPage() {
    navigatorKey.currentState.pushReplacementNamed(IntroScreen.routeName);
  }

  static void goToUserProfilePage() {
    navigatorKey.currentState.pushNamed(UserProfile.routeName);
  }

  static void goToEditUserScreen([UserModel userProfile]) {
    navigatorKey.currentState
        .pushNamed(UserEditProfile.routeName, arguments: userProfile);
  }

  static void goToViewImageScreen(image) {
    navigatorKey.currentState.pushNamed(ViewImage.routeName, arguments: image);
  }

  static void gotoAddMatPageFromOnBoardingPage(flowNumber) {
    navigatorKey.currentState
        .pushNamed(RegisterMatPage.routeName, arguments: flowNumber);
  }

  static Future<String> inputDialogAsync(BuildContext context, String title,
      String inputLabel, String inputHint, String actionButtonLabel) async {
    String inputTextFromUser = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 10.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: YipliLogoLarge(heightScaleDownFactor: 10),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                cursorColor: Theme.of(context).primaryColorLight,
                autofocus: true,
                decoration: new InputDecoration(
                    hintStyle: Theme.of(context).textTheme.caption,
                    labelStyle: Theme.of(context).textTheme.bodyText2,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            width: 2.0,
                            color: Theme.of(context)
                                .primaryColorLight
                                .withOpacity(0.8))),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            width: 2.0,
                            color: Theme.of(context)
                                .primaryColorLight
                                .withOpacity(0.5))),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            width: 2.0,
                            color: Theme.of(context)
                                .primaryColorLight
                                .withOpacity(0.8))),
                    disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            width: 2.0,
                            color: Theme.of(context)
                                .primaryColorLight
                                .withOpacity(0.3))),
                    labelText: inputLabel,
                    hintText: inputHint),
                onChanged: (value) {
                  inputTextFromUser = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(actionButtonLabel,
                  style: Theme.of(context).textTheme.bodyText2),
              onPressed: () {
                if (inputTextFromUser.length < 3) {
                  YipliUtils.showNotification(
                      //context: context,
                      msg:
                          "Please name your mat with more than 2 letters. Be creative!",
                      type: SnackbarMessageTypes.WARN);
                } else {
                  Navigator.of(context).pop(inputTextFromUser);
                }
              },
            ),
            FlatButton(
              child:
                  Text('Cancel', style: Theme.of(context).textTheme.bodyText2),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<File> getImage(BuildContext context) async {
    File image;
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.transparent,
              content: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ///for camera
                    FlatButton(
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        onPressed: () {
                          Navigator.pop(context, ImageSource.camera);
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.camera,
                              color: IconTheme.of(context).color,
                            ),
                            Text(
                              "Take a picture",
                              style: Theme.of(context).textTheme.bodyText2,
                            )
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15.0),
                      child: Divider(
                        height: 3,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),

                    ///for gallery
                    FlatButton(
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        onPressed: () {
                          Navigator.pop(context, ImageSource.gallery);
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.image,
                              color: IconTheme.of(context).color,
                            ),
                            Text("Pick from gallery",
                                style: Theme.of(context).textTheme.bodyText2)
                          ],
                        )),
                  ],
                ),
              ),
            ));

    if (imageSource != null) {
      PickedFile pickedImage =
          await ImagePicker().getImage(source: imageSource);
      image = File(pickedImage.path);
      if (image != null) {
        return image;
      }
    }
    return null;
  }

  static Future<void> showErrorAlert(
      BuildContext context, String s, List<Map<String, Object>> actionButtons) {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        List<Widget> actionButtonsList = new List();
        for (var actionButton in actionButtons) {
          actionButtonsList.add(FlatButton(
            child: Text(actionButton["buttonText"]),
            onPressed: actionButton["onPressed"],
          ));
        }

        return AlertDialog(
          title: Text("Yipli"),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: Container(
                child: Text(s),
              ))
            ],
          ),
          actions: actionButtonsList,
        );
      },
    );
  }

  static _smsCodeSent(String verificationId, List<int> code) {
    // set the verification code so that we can use it to log the user in
    print("CODE SENT! !");
    _smsVerificationCode = verificationId;
  }

  static _codeAutoRetrievalTimeout(String verificationId) {
    // set the verification code so that we can use it to log the user in
    print("CODE AUTO TIMEOUT! !");

    _smsVerificationCode = verificationId;
  }

  static Future<ConfirmAction> showPhoneVerificationDialog(BuildContext ctx,
      String phoneNumber, Function onSuccess, Function onFailed) async {
    final YipliTextInput otpInput = new YipliTextInput(
        "One Time Passcode",
        "Enter your OTP here",
        Icons.security,
        false,
        YipliValidators.validateOTP,
        null,
        null,
        true,
        TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        Theme.of(ctx).primaryColorLight.withOpacity(0.8));

    otpInput
        .addWhitelistingTextFormatter(FilteringTextInputFormatter.digitsOnly);

    print("Verification for +91$phoneNumber started ... ");
    return showDialog<ConfirmAction>(
        context: ctx,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          AuthService.mobAuth.verifyPhoneNumber(
            phoneNumber: "+91" + phoneNumber,
            timeout: Duration(seconds: 15),
            verificationCompleted: (AuthCredential phoneCredential) async {
              print("Verification complete!");

              User currentLoggedInUser = AuthService.getLoggedFirebaseUser();

              await currentLoggedInUser.updatePhoneNumber(phoneCredential);
              onSuccess();
            },
            verificationFailed: (FirebaseAuthException exception) {
              //Todo Handle phone verification error
              print(
                  "Verification FAILED! - ${exception.code} -- ${exception.message}");

              onFailed();
            },
            codeSent: (verificationId, [code]) =>
                _smsCodeSent(verificationId, [code]),
            codeAutoRetrievalTimeout: (verificationId) =>
                _codeAutoRetrievalTimeout(verificationId),
          );

          return AlertDialog(
            titlePadding: EdgeInsets.all(0),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            backgroundColor: Theme.of(ctx).primaryColor,
            elevation: 10.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: YipliLogoLarge(heightScaleDownFactor: 10),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Please enter OTP sent on $phoneNumber.",
                      style: Theme.of(ctx).textTheme.bodyText2),
                  otpInput
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Verify', style: Theme.of(ctx).textTheme.bodyText2),
                onPressed: () async {
                  //Verified
                  try {
                    String code = otpInput.getText();
                    AuthCredential _authCredential =
                        PhoneAuthProvider.credential(
                            verificationId: _smsVerificationCode,
                            smsCode: code);
                    User currentLoggedInUser =
                        AuthService.getLoggedFirebaseUser();

                    print("AuthService.firebaseUser = " +
                        currentLoggedInUser.toString());
                    await currentLoggedInUser
                        .updatePhoneNumber(_authCredential);
                    Navigator.of(dialogContext).pop(ConfirmAction.YES);
                    onSuccess();
                  } on PlatformException catch (exception) {
                    YipliUtils.showNotification(
                        context: ctx,
                        msg: "Verification failed! ${exception.message}",
                        type: SnackbarMessageTypes.ERROR);
                  }
                },
              ),

              //TODO - @Sangram - The cancel button on OTP has no fall back, the number still gets saved even if OTP is not entered.
              FlatButton(
                child: Text('Cancel', style: Theme.of(ctx).textTheme.bodyText2),
                onPressed: () {
                  Navigator.of(dialogContext).pop(ConfirmAction.NO);
                },
              )
            ],
          );
        });
  }

  static Future<ConfirmAction> asyncConfirmDialog(
      BuildContext context, String confirmationText) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 10.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: YipliLogoLarge(heightScaleDownFactor: 10),
          content: Text(confirmationText,
              style: Theme.of(context).textTheme.bodyText2),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes', style: Theme.of(context).textTheme.bodyText2),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.YES);
              },
            ),
            FlatButton(
              child:
                  Text('Cancel', style: Theme.of(context).textTheme.bodyText2),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.NO);
              },
            ),
          ],
        );
      },
    );
  }

  static openAppWithArgs(String url, args) async {
    if (Platform.isAndroid) {
      try {
        AndroidIntent intent = AndroidIntent(
          action: 'android.intent.action.SEND', // intent to send data
          package: url,
          arguments:
              args, // actual data we are sending. In this case it will be json data.
          type: "text/json",
        );
        await intent.launch();
      } catch (exp) {
        print("Exception caught in AndroidIntent : ");
        print(exp.toString());
        throw exp;
      }
    } else if (Platform.isIOS) {
      //Todo
    }
  }

  static InkWell buildBigButton(BuildContext context,
      {IconData icon,
      @required String text,
      @required String text2,
      Function onTappedFunction}) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTappedFunction,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Icon(
                        icon,
                        size: 30.0,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          text,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        (text2.length > 0)
                            ? Text(
                                text2,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontWeight: FontWeight.w600),
                              )
                            : Padding(padding: EdgeInsets.all(0)),
                      ],
                    ),
                    flex: 2,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  static InkWell buildVeryBigButton(BuildContext context,
      {IconData icon,
      @required String text,
      @required String text2,
      @required Widget anim,
      @required String infoText,
      Function onTappedFunction}) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTappedFunction,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: Icon(
                          icon,
                          size: 30.0,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            text,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          (text2.length > 0)
                              ? Text(
                                  text2,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(fontWeight: FontWeight.w600),
                                )
                              : Padding(padding: EdgeInsets.all(0)),
                        ],
                      ),
                      flex: 2,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: anim,
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  infoText,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> ResetSharedPref(String strKey) async {
    print("About to delete SharedPref : $strKey");
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    sharedPreference.setBool(strKey, false);
  }

  static void initializeApp() {
    if (navigatorKey.currentState.canPop()) {
      navigatorKey.currentState.popUntil((route) => route.isFirst);
    }
    ResetSharedPref('mat_add_skipped');
    ResetSharedPref('player_add_skipped');

    navigatorKey.currentState.pushReplacementNamed(FitnessGaming.routeName);
  }

  static ClipOval getPlayerProfilePicIcon(
      context, String playerProfilePicUrl, double sizeScaleDownFactor) {
    return ClipOval(
      child: Container(
        height: (MediaQuery.of(context).size.height) / sizeScaleDownFactor,
        width: (MediaQuery.of(context).size.width) / sizeScaleDownFactor,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: playerProfilePicUrl == null || playerProfilePicUrl == ""
            ? Image.asset("assets/images/placeholder_image.png")
            : FadeInImage(
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 100),
                image: FirebaseImage(
                    "${FirebaseStorageUtil.profilepics}/$playerProfilePicUrl"),
                placeholder: AssetImage('assets/images/img_loading.gif'),
              ),
      ),
    );
  }

  static Widget getPlayerProfilePicIconWithoutConstraints(
      context, String playerProfilePicUrl,
      [bool showBorder = false]) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Align(
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
                height: constraints.maxHeight,
                width: constraints.maxHeight,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: showBorder
                        ? Border.all(color: yipliLogoOrange, width: 3)
                        : null),
                child: ClipOval(
                  child: playerProfilePicUrl == null ||
                          playerProfilePicUrl == ""
                      ? Image.asset("assets/images/placeholder_image.png")
                      : Image(
                          image: FirebaseImage(
                              "${FirebaseStorageUtil.profilepics}/$playerProfilePicUrl")),
                )),
          ),
        );
      },
    );
  }

  static Widget getPlayerProfilePicIconRect(context, String playerProfilePicUrl,
      [bool showBorder = false]) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
            height: constraints.maxHeight,
            width: constraints.maxHeight,
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: showBorder
                    ? Border.all(color: Theme.of(context).accentColor, width: 3)
                    : null),
            child: Image(image: getProfilePicImage(playerProfilePicUrl)));
      },
    );
  }

  static ImageProvider getProfilePicImage(String playerProfilePicUrl) {
    return playerProfilePicUrl == null || playerProfilePicUrl == ""
        ? AssetImage("assets/images/placeholder_image.png")
        : FirebaseImage(
            "${FirebaseStorageUtil.profilepics}/$playerProfilePicUrl");
  }

  static void showNotification(
      {BuildContext context,
      String msg,
      Function onClose,
      SnackbarMessageTypes type = SnackbarMessageTypes.DEFAULT,
      SnackbarDuration duration = SnackbarDuration.MEDIUM}) {
    Color snackBarBackgroundColor = getSnackBarBackgroundColor(type, context);
    int durationForNotification = getNotificationDuration(duration);
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      barBlur: 3.0,
      messageText: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              msg,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
      ),
      //message: ,
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      backgroundColor: snackBarBackgroundColor,
      duration: Duration(seconds: durationForNotification),
      onStatusChanged: (FlushbarStatus status) {
        if (status == FlushbarStatus.DISMISSED) {
          if (onClose != null) {
            onClose();
          }
        }
      },
    )..show(context);
  }

  static Color getSnackBarBackgroundColor(
      SnackbarMessageTypes type, BuildContext context) {
    switch (type) {
      case SnackbarMessageTypes.ERROR:
        return Colors.red[600].withOpacity(0.8);
      case SnackbarMessageTypes.WARN:
        return Colors.red[800].withOpacity(0.8);
      case SnackbarMessageTypes.INFO:
        return Theme.of(context).accentColor.withOpacity(0.8);
      case SnackbarMessageTypes.SUCCESS:
        return Colors.blue[800].withOpacity(0.8);
      case SnackbarMessageTypes.DEFAULT:
        return Colors.black12.withOpacity(0.8);
    }
    return Colors.black12.withOpacity(0.8);
  }

  static void goToRoute(String pageOption,
      [bool replaceStack = false, dynamic arguments]) {
    if (replaceStack) {
      navigatorKey.currentState
          .pushReplacementNamed(pageOption, arguments: arguments);
    } else
      navigatorKey.currentState.pushNamed(pageOption, arguments: arguments);
  }

  static int getNotificationDuration(SnackbarDuration duration) {
    switch (duration) {
      case SnackbarDuration.SHORT:
        return 1;
      case SnackbarDuration.MEDIUM:
        return 3;

      case SnackbarDuration.LONG:
        return 5;
    }
    return 3;
  }

  static Widget getProfilePicImageIcon(
      BuildContext context, String profilePicUrl, bool isSelected) {
    return Container(
      padding: EdgeInsets.all(0),
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.contain,
          image: FirebaseImage(
              "${FirebaseStorageUtil.profilepics}/$profilePicUrl"),
        ),
      ),
    );
  }

  static getNetworkConnectivityStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      // API
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      // API
      return true;
    } else {
      return false;
    }
  }

  static showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Updating..'),
      ),
    );
  }

  static manageAppConnectivity(BuildContext context) {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult event) {
      processChangedConnectivity(event, context);
    });
  }

  static void processChangedConnectivity(
      ConnectivityResult event, BuildContext context) {
    switch (event) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        // TODO: Handle this case.
        FirebaseDatabase.instance.goOnline().then((value) {
          YipliUtils.appConnectionStatus = AppConnectionStatus.CONNECTED;
          try {
            BotToast.showSimpleNotification(
              title: "You are connected to the network.",
              backgroundColor: Colors.blue[800].withOpacity(0.8),
              hideCloseButton: true,
            );
          } catch (e) {
            print('expection for bottoast - $e');
          }
          if (YipliUtils.navigatorKey.currentState != null)
            YipliUtils.navigatorKey.currentState
                .pushReplacementNamed(FitnessGaming.routeName);
        });
        break;
      case ConnectivityResult.none:
        // TODO: Handle this case.
        FirebaseDatabase.instance.goOffline().then((value) {
          YipliUtils.appConnectionStatus = AppConnectionStatus.DISCONNECTED;
          try {
            BotToast.showSimpleNotification(
              title: "Please connect to the network and check again.",
              backgroundColor: Colors.red[600].withOpacity(0.8),
              hideCloseButton: true,
            );
          } catch (e) {
            print('expection for bottoast - $e');
          }

          YipliUtils.navigatorKey.currentState
              .pushReplacementNamed(NoNetworkPage.routeName);
        });
        break;
    }
  }

  static double getImageHeight(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return screenSize.height / 4;
  }
//* --------- AdventureGameCardContent widgets start here ----------

  static IconData getIconForCardState(
      AdventureGamingCardState adventureGamingCardState) {
    switch (adventureGamingCardState) {
      case AdventureGamingCardState.PLAYED:
        return Icons.check_circle;
      case AdventureGamingCardState.NEXT:
        return Icons.location_on;
      case AdventureGamingCardState.LOCKED:
        return Icons.fiber_manual_record;
    }
    return null;
  }

  static IconData getIconForButton(
      AdventureGamingCardState adventureGamingCardState) {
    switch (adventureGamingCardState) {
      case AdventureGamingCardState.PLAYED:
        return Icons.refresh;
      case AdventureGamingCardState.NEXT:
        return Icons.play_arrow;
      case AdventureGamingCardState.LOCKED:
        return Icons.lock;
    }
    return null;
  }

  static getColorForCardState(
      AdventureGamingCardState adventureGamingCardState) {
    switch (adventureGamingCardState) {
      case AdventureGamingCardState.PLAYED:
        return yipliLogoBlue;
      case AdventureGamingCardState.NEXT:
        return yipliLogoOrange;
      case AdventureGamingCardState.LOCKED:
        return accentLightGray;
    }
    return null;
  }

  static getBorderColorForCardState(
      AdventureGamingCardState adventureGamingCardState) {
    switch (adventureGamingCardState) {
      case AdventureGamingCardState.PLAYED:
      case AdventureGamingCardState.LOCKED:
        return primarycolor;
      case AdventureGamingCardState.NEXT:
        return yipliLogoOrange;
    }
    return null;
  }

  static getButtonColor(AdventureGamingCardState adventureGamingCardState) {
    switch (adventureGamingCardState) {
      case AdventureGamingCardState.PLAYED:
      case AdventureGamingCardState.NEXT:
        return yipliLogoBlue;
      case AdventureGamingCardState.LOCKED:
        return accentLightGray;
    }
    return null;
  }

  static Widget getLockedOverlay(
      AdventureGamingCardState adventureGamingCardState) {
    switch (adventureGamingCardState) {
      case AdventureGamingCardState.PLAYED:
      case AdventureGamingCardState.NEXT:
        return IgnorePointer(child: Container());

      case AdventureGamingCardState.LOCKED:
        return Stack(children: [
          Container(
            decoration: BoxDecoration(
              //borderRadius: BorderRadius.circular(8.0),
              color: appbackgroundcolor.withOpacity(0.8),
            ),
          ),
          Positioned.fill(
            child: Icon(Icons.lock, color: accentLightGray),
          ),
        ]);
    }
    return null;
  }

  static Widget getImageLockedOverlay(
      AdventureGamingCardState adventureGamingCardState) {
    switch (adventureGamingCardState) {
      case AdventureGamingCardState.PLAYED:
      case AdventureGamingCardState.NEXT:
        return IgnorePointer(child: Container());

      case AdventureGamingCardState.LOCKED:
        return Container(
          decoration: BoxDecoration(
            //shape: BoxShape.circle,
            color: appbackgroundcolor.withOpacity(0.8),
          ),
        );
    }
    return null;
  }

  static showButton(AdventureGamingCardState adventureGamingCardState) {
    switch (adventureGamingCardState) {
      case AdventureGamingCardState.PLAYED:
      case AdventureGamingCardState.NEXT:
        return Positioned(
          bottom: 50,
          right: 5,
          child: FloatingActionButton(
            heroTag: DateTime.now().toString(),
            mini: true,
            backgroundColor: getButtonColor(adventureGamingCardState),
            child: FaIcon(getIconForButton(adventureGamingCardState), size: 18),
            onPressed: () {},
          ),
        );

      case AdventureGamingCardState.LOCKED:
        return Positioned.fill(
          child: Center(
            child: Icon(Icons.lock, size: 30, color: accentLightGray),
          ),
        );
    }
  }

  static String getLocalStorageKeyForPlayer(String id) {
    return "player-data-$id";
  }

  static Widget showTipOfTheDay() {
    /// this is for tips category and tips
    Query tipsDBRef = FirebaseDatabaseUtil()
        .rootRef
        .child("inventory")
        .child("tips")
        .child("list")
        .orderByChild("category");
    print('tipsDBRef from utils - $tipsDBRef');

    /// this is for tips tips count
    Query tipsCountDBRef = FirebaseDatabaseUtil()
        .rootRef
        .child("inventory")
        .child("tips")
        .orderByChild("count");

    print('tipsCountDBRef from utils - ${(tipsCountDBRef).onValue}');
    return StreamBuilder<Event>(
        stream: tipsCountDBRef.onValue,
        builder: (context, event1) {
          if ((event1.connectionState == ConnectionState.waiting) ||
              event1.hasData == null)
            return YipliLoaderMini(loadingMessage: 'Loading Tip');
          int randomListLengthStream1 =
              (event1?.data?.snapshot?.value ?? {'count': 0})['count'];
          // print('randomListLengthStream1 - $randomListLengthStream1');
          return StreamBuilder<Event>(
              stream: tipsDBRef.onValue,
              builder: (context, event2) {
                if ((event2.connectionState == ConnectionState.waiting) ||
                    event2.hasData == null)
                  return YipliLoaderMini(loadingMessage: 'Loading Tip');
                // print('on value - ${(tipsDBRef.onValue)}');
                int listLengthMax = randomListLengthStream1;
                int randomListLength = new Random().nextInt(listLengthMax);
                return TipOfTheDay(
                  tipHeadingText: (event2?.data?.snapshot?.value ??
                          [
                            {'category': ''}
                          ])
                      .elementAt(randomListLength)['category'],
                  imagePath: 'assets/images/healthTipImg.png',
                  healthTipText: (event2?.data?.snapshot?.value ??
                          [
                            {'tip': ''}
                          ])
                      .elementAt(randomListLength)['tip'],
                );
              });
        });
  }

  static Future<void> showDailyTipForCurrentPlayer(
      BuildContext context, String playerId) async {
    final keyIsDailyTipShownToPlayer = 'Daily_Tip_' + playerId;

    //checking if the player has seen the tip
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    int diffBetweenNextTip = 43200000; //half day daily tip time
    int tipLastShownTime = prefs.getInt(keyIsDailyTipShownToPlayer);
    print('tipLastShownTime - $tipLastShownTime');
    if (tipLastShownTime == null ||
        ((currentTime - tipLastShownTime) > diffBetweenNextTip)) {
      Future.delayed(YipliUtils.getNotificationDuration(SnackbarDuration.SHORT)
              .seconds)
          .then((value) => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => YipliUtils.showTipOfTheDay()));
      prefs.setInt(keyIsDailyTipShownToPlayer,
          new DateTime.now().millisecondsSinceEpoch);

      //prefs.setBool(keyIsDailyTipShownToPlayer, false);
    }
  }

  static Future<void> doNotShowDailyTipForRecentlyAddedPlayer(
      String playerId) async {
    final keyIsDailyTipShownToPlayer = 'Daily_Tip_' + playerId;

    //checking if the player has seen the tip
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(
        keyIsDailyTipShownToPlayer, new DateTime.now().millisecondsSinceEpoch);
  }

  static Widget showRewardOfTheDay(String playerId, int rewardLastShownTime) {
    return GiveScratchCard(playerId, rewardLastShownTime);
  }

  static Future<void> showDailyRewardsForCurrentPlayer(
      BuildContext context, String playerId) async {
    final keyIsDailyRewardShownToPlayer = 'Daily_Rewards_' + playerId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    int diffBetweenNextReward = 43200000; //half day daily tip time
    int rewardLastShownTime = prefs.getInt(keyIsDailyRewardShownToPlayer);
    print('rewardLastShownTime - $rewardLastShownTime');

    if (rewardLastShownTime == null ||
        ((currentTime - rewardLastShownTime) > diffBetweenNextReward)) {
      Future.delayed(YipliUtils.getNotificationDuration(SnackbarDuration.SHORT)
              .seconds)
          .then((value) => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return YipliUtils.showRewardOfTheDay(
                    playerId, rewardLastShownTime);
              }));
      prefs.setInt(keyIsDailyRewardShownToPlayer,
          new DateTime.now().millisecondsSinceEpoch);
    }
  }

  static int getAgeFromDOB(DateTime date) {
    print("In GetAgeFromDOB");
    DateTime today = DateTime.now();
    AgeDuration age;

    try {
      // Find out your age
      age = Age.dateDifference(
          fromDate: date, toDate: today, includeToDate: false);
    } catch (exp) {
      print("Exception In GetAgeFromDOB : $exp");
    }

    return int.parse(age.toString());
  }
}
