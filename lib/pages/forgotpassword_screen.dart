import 'a_pages_index.dart';

class ForgotPassword extends StatelessWidget {
  static const String routeName = "/forgotpassword_screen";
  @override
  Widget build(BuildContext context) {
    return ForgotPasswordPage();
  }
}

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool _isLoading = false;
  BuildContext _currentContext;
  final YipliTextInput emailInput = new YipliTextInput(
    "",
    "Email",
    FontAwesomeIcons.at,
    false,
    YipliValidators.validateEmail,
    null,
    null,
    true,
    null,
  );

  YipliButton resetButton;

  void onResetPress() async {
    print("Rest -- ON Reset Press!");
    String emailReset = emailInput.getText();
    _isLoadingNow();

    if (emailReset != null && emailReset.length != 0) {
      if (YipliValidators.validateEmail(emailReset) == null) {
        if (YipliUtils.appConnectionStatus == AppConnectionStatus.CONNECTED) {
          AuthService.mobAuth
              .sendPasswordResetEmail(email: emailReset)
              .then((_) {
            _isNotLoading();
            return showDialog<ConfirmAction>(
              context: context,
              barrierDismissible:
                  false, // user must tap button for close dialog!
              builder: (BuildContext context) {
                return AlertDialog(
                  titlePadding: EdgeInsets.all(0),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  backgroundColor: Theme.of(context).primaryColor,
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: YipliLogoLarge(heightScaleDownFactor: 10),
                  ),
                  content: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                        "Link has been sent to your registered email.\nReset your password and login again.",
                        style: Theme.of(context).textTheme.bodyText2),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('ok',
                          style: Theme.of(context).textTheme.bodyText2),
                      onPressed: () {
                        Navigator.of(context).pop(ConfirmAction.YES);
                        YipliUtils.goToLoginScreen();
                      },
                    ),
                  ],
                );
              },
            );
          }).catchError((err) {
            _isNotLoading();
          });
        } else {
          YipliUtils.showNotification(
              context: context,
              msg: "No Internet Connectivity",
              type: SnackbarMessageTypes.ERROR,
              duration: SnackbarDuration.MEDIUM);
        }
      } else {
        YipliUtils.showNotification(
            context: _currentContext,
            msg: "Email is not correct. Please check the format and try again.",
            type: SnackbarMessageTypes.WARN);
      }
    } else {
      YipliUtils.showNotification(
          context: _currentContext,
          msg: "Please enter email Id associated with your account.",
          type: SnackbarMessageTypes.WARN);
    }
  }

  void _isLoadingNow() {
    setState(() {
      _isLoading = true;
    });
  }

  void _isNotLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _currentContext = context;
    final Size screenSize = MediaQuery.of(context).size;
    resetButton = new YipliButton("Reset", null,
        Theme.of(context).primaryColorLight, screenSize.width / 4);
    resetButton.setClickHandler(onResetPress);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: ModalProgressHUD(
              progressIndicator: YipliLoader(),
              inAsyncCall: _isLoading,
              child: Column(
                children: <Widget>[
                  Hero(
                    tag: "yipli-logo",
                    child: YipliLogoAnimatedLarge(
                      heightVariable: 5,
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      height: screenSize.height / 20,
                    ),
                  ),
                  Text('Enter your registered email id \n to reset password.',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center),
                  Center(
                    child: SizedBox(
                      height: screenSize.height / 20,
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: emailInput),
                  SizedBox(
                    height: screenSize.height / 20,
                  ),
                  resetButton,
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: FlatButton(
                      child: Text(
                        'Go back to login',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(decoration: TextDecoration.underline
                                //fontFamily: 'Tri',
                                ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/login_screen');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
