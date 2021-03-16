import 'a_pages_index.dart';

class VerificationScreenInput {
  final String email;
  final String displayName;
  User loggedInUser;

  VerificationScreenInput({this.loggedInUser, this.email, this.displayName});
}

class VerificationScreen extends StatefulWidget {
  static const String routeName = "/email_verification_screen";

  @override
  State<StatefulWidget> createState() => new _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    VerificationScreenInput inputArgs =
        ModalRoute.of(context).settings.arguments;
    print('inputArgs - $inputArgs');
    return YipliPageFrame(
      title: YipliLogoAnimatedSmall(),
      showDrawer: false,
      child: Container(
        child: ModalProgressHUD(
          progressIndicator: YipliLoader(),
          inAsyncCall: _isLoading,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Icon(
                    Icons.verified_user,
                    color: IconTheme.of(context).color,
                    size: 72,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        inputArgs.email,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'has not been verified yet. \nClick the link in your inbox to verify.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: YipliUtils.buildBigButton(context,
                              icon: Icons.check_circle,
                              text: "Check",
                              text2: "verification",
                              onTappedFunction: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            print('Check verification');
                            await inputArgs.loggedInUser.reload();
                            await AuthService.signOut();
                            if (AuthService.credential != null) {
                              UserCredential result = await AuthService.mobAuth
                                  .signInWithCredential(AuthService.credential);
                              inputArgs.loggedInUser = result.user;
                              setState(() {
                                _isLoading = false;
                              });
                              if (inputArgs.loggedInUser.emailVerified) {
                                YipliUtils.showNotification(
                                    context: context,
                                    msg: "Email verified. Thank you!");
                                YipliUtils.goToHomeScreen();
                              } else {
                                YipliUtils.showNotification(
                                    context: context,
                                    msg: "Email not yet verified.");
                                print("Not yet verified...");
                              }
                            } else {
                              YipliUtils.showNotification(
                                  context: context,
                                  msg: "Please login again for verification",
                                  type: SnackbarMessageTypes.INFO);
                              YipliUtils.goToLoginScreen();
                            }
                          })),
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: YipliUtils.buildBigButton(context,
                              icon: Icons.refresh,
                              text: "Resend",
                              text2: "Email", onTappedFunction: () async {
                            print('send Verftn email pressed');

                            inputArgs.loggedInUser.sendEmailVerification();
                            YipliUtils.showNotification(
                                context: context,
                                msg:
                                    "Email for verification sent for the above email.");
                          })),
                    ),
                  ],
                ),
                //
                Padding(
                  padding:
                      const EdgeInsets.only(top: 12.0, left: 48, right: 48),
                  child: YipliUtils.buildBigButton(context,
                      icon: Icons.arrow_back,
                      text: "Back to Sign Up",
                      text2: "", onTappedFunction: () {
                    YipliUtils.goToLogoutScreen();
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
