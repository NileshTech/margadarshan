import 'a_pages_index.dart';

AuthService authService;

class Login extends StatelessWidget {
  static const String routeName = "/login_screen";
  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool bIsTandCChecked = true;

//  final TextEditingController _emailController = new TextEditingController();
//  final TextEditingController _passwordFilter = new TextEditingController();

  GlobalKey<FormState> _formKey;

  YipliTextInput emailInput;

  YipliTextInput passwordInput;
// login email details, and password

  Future<void> onLogInPress() async {
    print('login button pressed');
    setState(() {
      isLoginButtonPressed = true;
      _saving = true;
    });
    {
      {
        print("LOGIN Up Press!");

        final FormState form = _formKey.currentState;
        if (_formKey.currentState.validate()) {
          if (bIsTandCChecked == true) {
            if (YipliUtils.appConnectionStatus ==
                AppConnectionStatus.CONNECTED) {
              form.save();
              print("Logging in user!");

              try {
                print(_email + " -- " + _password);
                setState(() {
                  _saving = true;
                });

                User loggedInUser =
                    await authService.emailSignIn(_email, _password);

                setState(() {
                  _saving = false;
                });

                if (loggedInUser != null) {
                  YipliUtils.initializeApp();
                } else {
                  print("Invalid - ");
                }
              } catch (e) {
                setState(() {
                  _saving = false;
                });
                print(e);
                switch (e.code) {
                  case "ERROR_INVALID_CREDENTIAL":
                  case "invalid-credential":
                    YipliUtils.showNotification(
                        context: context,
                        msg:
                            "The supplied auth credential is malformed or has expired.",
                        type: SnackbarMessageTypes.ERROR);
                    break;
                  case "ERROR_INVALID_EMAIL":
                  case "invalid-email":
                    YipliUtils.showNotification(
                        context: context,
                        msg: "The email address is badly formatted.",
                        type: SnackbarMessageTypes.ERROR);
                    break;
                  case "ERROR_WRONG_PASSWORD":
                  case "invalid-password":
                  case "wrong-password":
                    YipliUtils.showNotification(
                        context: context,
                        msg:
                            "The password is invalid or the user does not have a password.",
                        type: SnackbarMessageTypes.ERROR);
                    break;
                  case "ERROR_REQUIRES_RECENT_LOGIN":
                    YipliUtils.showNotification(
                        context: context,
                        msg:
                            "This operation is sensitive and requires recent authentication. Log in again before retrying this request.",
                        type: SnackbarMessageTypes.ERROR);
                    break;
                  case "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL":
                  case "invalid-credential":
                    YipliUtils.showNotification(
                        context: context,
                        msg:
                            "An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.",
                        type: SnackbarMessageTypes.ERROR);
                    break;
                  case "ERROR_EMAIL_ALREADY_IN_USE":
                  case "ERROR_CREDENTIAL_ALREADY_IN_USE":
                  case "email-already-exists":
                    YipliUtils.showNotification(
                        context: context,
                        msg:
                            "This credential is already associated with a different user account.",
                        type: SnackbarMessageTypes.ERROR);
                    break;
                  case "ERROR_USER_DISABLED":
                  case "invalid-disabled-field":
                    YipliUtils.showNotification(
                        context: context,
                        msg:
                            "The user account has been disabled by an administrator.",
                        type: SnackbarMessageTypes.ERROR);
                    break;
                  case "ERROR_USER_NOT_FOUND":
                  case "user-not-found":
                    YipliUtils.showNotification(
                        context: context,
                        msg:
                            "There is no user record corresponding to this identifier. The user may have been deleted.",
                        type: SnackbarMessageTypes.ERROR);
                    break;
                  default:
                    YipliUtils.showNotification(
                        context: context,
                        msg:
                            "There was an error logging you in at the moment. If error persists, please contact Yipli Support.",
                        type: SnackbarMessageTypes.ERROR);

                    break;
                }
                print('Error Aala - Login');
              } catch (otherError) {}
            } else {
              YipliUtils.showNotification(
                  context: context,
                  msg: "No Internet Connectivity",
                  type: SnackbarMessageTypes.ERROR,
                  duration: SnackbarDuration.MEDIUM);
            }
          } else {
            showTermsAndConditionsAlert();
          }
        }
      }
    }
    setState(() {
      _saving = false;
    });
  }

  static void onEmailSaved(String email) {
    _email = email;
    print('Email $email saved');
  }

  static void onPasswordSaved(String password) {
    _password = password;
    print('Password $password saved');
  }

  YipliButton logInButton;

  void onSignUpPress() async {
    if (bIsTandCChecked == true) {
      print('signup button pressed');
      setState(() {
        _saving = true;
      });
      {
        print("LOGIN -- ON Sign Up Press!");
        Navigator.of(context).pushNamed('/signup_screen');
      }
      setState(() {
        _saving = false;
      });
    } else {
      showTermsAndConditionsAlert();
    }
  }

  YipliButton signUpButton;

  @override
  void initState() {
    //Call the Class constructor and initialize the object
    _formKey = GlobalKey<FormState>();
    authService = new AuthService();
    //signUpButton.setClickHandler(onSignUpPress);
    isLoginButtonPressed = false;
    super.initState();
  }

  static String _email = "";
  static String _password = "";

  bool isLoginButtonPressed;

  String validateOnlyAfterLoginPress(String value) {
    if (!isLoginButtonPressed)
      return null;
    else
      return YipliValidators.validateEmail(value);
  }

  String validatePasswordAfterLoginPress(String value) {
    if (!isLoginButtonPressed)
      return null;
    else if (value.length < 1)
      return 'Enter valid password';
    else
      return null;
  }

  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    signUpButton = new YipliButton("Register",
        Theme.of(context).primaryColorLight, Theme.of(context).primaryColor);
    signUpButton.setClickHandler(onSignUpPress);
    emailInput = new YipliTextInput(
      "",
      "Email",
      FontAwesomeIcons.at,
      false,
      validateOnlyAfterLoginPress,
      onEmailSaved,
      null,
      true,
      null,
    );

    passwordInput = new YipliTextInput(
      "",
      "Password",
      FontAwesomeIcons.lock,
      true,
      validatePasswordAfterLoginPress,
      onPasswordSaved,
      null,
      true,
      null,
    );
    logInButton = new YipliButton(
      "Login",
      null,
      null,
      screenSize.width / 4,
    );
    logInButton.setClickHandler(onLogInPress);
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ModalProgressHUD(
            inAsyncCall: _saving,
            progressIndicator: YipliLoader(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        primarycolor,
                        appbackgroundcolor,
                      ],
                      stops: [0.4, 0.7],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 0.05 * screenSize.height,
                            child: Container(),
                          ),
                          SizedBox(
                            height: 0.15 * screenSize.height,
                            child: Hero(
                              tag: "yipli-logo",
                              child: YipliLogoAnimatedSmall(),
                            ),
                          ),
                          SizedBox(
                            height: 0.02 * screenSize.height,
                            child: Container(),
                          ),
                          SizedBox(
                              height: 0.2 * screenSize.height,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  buildFacebookButton(screenSize, context),
                                  buildGoogleButton(screenSize, context)
                                ],
                              )),
                          SizedBox(
                            height: 0.3 * screenSize.height,
                            child: _buildTextFields(context),
                          ),
                          SizedBox(
                            height: 0.1 * screenSize.height,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                      child: buildRegisterLink(context)),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                      child: buildForgotPasswordLink(context)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              height: 0.05 * screenSize.height,
                              child: buildTermsAndConditionsLink(context)),
                          SizedBox(
                              height: 0.05 * screenSize.height,
                              child: buildPrivacyPolicyLink(context)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFields(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
          vertical: 8,
        ),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: emailInput,
              ),
              Flexible(child: passwordInput),
              Flexible(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: logInButton,
                  // child: RaisedButton(
                  //   onPressed: () {
                  //   },
                  //   child: Text("submit"),
                  // ),
                ),
              ),
            ],
          ),
        ));
  }

  Center buildTermsAndConditionsLink(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Theme(
            data: Theme.of(context)
                .copyWith(unselectedWidgetColor: Theme.of(context).accentColor),
            child: Checkbox(
              checkColor: Theme.of(context).primaryColorLight,
              activeColor: Theme.of(context).accentColor,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: bIsTandCChecked,
              onChanged: (value) {
                setState(() {
                  bIsTandCChecked = value;
                });
              },
            ),
          ),
          FlatButton(
            padding: EdgeInsets.all(0),
            child: Text(
              'Terms and Conditions',
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    decoration: TextDecoration.none,
                    color: Theme.of(context).accentColor,
                  ),
            ),
            onPressed: () async {
              const url = 'https://playyipli.com/termsconditions.html';
              if (await canLaunch(url)) {
                await launch(url, forceSafariVC: false);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
        ],
      ),
    );
  }

  Center buildPrivacyPolicyLink(BuildContext context) {
    return Center(
      child: FlatButton(
        padding: EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 2.0),
        child: Text(
          'Privacy Policy',
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                decoration: TextDecoration.none,
                color: Theme.of(context).accentColor,
              ),
        ),
        onPressed: () async {
          const url = 'https://playyipli.com/privacypolicy.html';
          if (await canLaunch(url)) {
            await launch(url, forceSafariVC: false);
          } else {
            throw 'Could not launch $url';
          }
        },
      ),
    );
  }

  // Widget buildRegisterLink(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 0.0),
  //     child: FlatButton(
  //       child: Align(
  //         alignment: Alignment.centerLeft,
  //         child: Text(
  //           'Register',
  //           style: Theme.of(context).textTheme.bodyText2.copyWith(
  //                 color: Theme.of(context).accentColor,
  //               ),
  //         ),
  //       ),
  //       onPressed: () {
  //         Navigator.of(context).pushNamed(SignUp.routeName);
  //       },
  //     ),
  //   );
  // }

  Widget buildRegisterLink(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(SignUp.routeName);
      },
      child: Text('Register',
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Theme.of(context).accentColor,
              )),
    );
  }

  Widget buildForgotPasswordLink(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(ForgotPassword.routeName);
      },
      child: Text('Forgot Password?',
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Theme.of(context).accentColor,
              )),
    );
  }

  // Widget buildForgotPasswordLink(BuildContext context) {
  //   return FlatButton(
  //     child: Text(
  //       'Forgot Password?',
  //       style: Theme.of(context).textTheme.bodyText2.copyWith(
  //             color: Theme.of(context).accentColor,
  //           ),
  //     ),
  //     onPressed: () {
  //       Navigator.of(context).pushNamed(ForgotPassword.routeName);
  //     },
  //   );
  // }

  GestureDetector buildGoogleButton(Size screenSize, BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColorLight),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  width: screenSize.height / 22,
                  height: screenSize.height / 22,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/Google.png"),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Center(
                      child: Text("Sign in with Google",
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold)))),
            ],
          ),
        ),
      ),
      onTap: () async {
        if (YipliUtils.appConnectionStatus == AppConnectionStatus.CONNECTED) {
          if (bIsTandCChecked == true) {
            print('google sign in');
            setState(() {
              _saving = true;
            });
            await AuthService.googleSignIn(context);
            setState(() {
              _saving = false;
            });
          } else {
            showTermsAndConditionsAlert();
          }
        } else {
          YipliUtils.showNotification(
              context: context,
              msg: "No Internet Connectivity",
              type: SnackbarMessageTypes.ERROR,
              duration: SnackbarDuration.MEDIUM);
        }
      },
    );
  }

  /// facebook button on login screen
  GestureDetector buildFacebookButton(Size screenSize, BuildContext context) {
    return GestureDetector(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColorLight),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                  ),
                  child: Container(
                    width: screenSize.height / 22,
                    height: screenSize.height / 22,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/Facebook.png"),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      "Continue with Facebook",
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () async {
          print('Facebook sign in');

          if (YipliUtils.appConnectionStatus == AppConnectionStatus.CONNECTED) {
            if (bIsTandCChecked == true) {
              try {
                setState(() {
                  _saving = true;
                });
                await authService.facebookSignIn(context);
                setState(() {
                  _saving = false;
                });
              } catch (error) {
                print("== Error Code ==" + error.code);
                setState(() {
                  _saving = false;
                });
                switch (error.code) {
                  case "account-exists-with-different-credential":
                    YipliUtils.showNotification(
                        context: context,
                        msg:
                            "The email used to login has been used using a different account. Please try Google or Email login.",
                        type: SnackbarMessageTypes.WARN);
                    break;
                  case "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL":
                    YipliUtils.showNotification(
                        context: context,
                        msg:
                            "The email used to login has been used using a different account. Please try Google or Email login.",
                        type: SnackbarMessageTypes.WARN);
                    break;
                  case "invalid-credential":
                    YipliUtils.showNotification(
                        context: context,
                        msg:
                            "The email used to login has been used using a different account. Please try Google or Email login.",
                        type: SnackbarMessageTypes.WARN);
                    break;
                  default:
                    YipliUtils.showNotification(
                        context: context,
                        msg:
                            "There was an error logging using Facebook. Please try again in some time.",
                        type: SnackbarMessageTypes.ERROR);
                    break;
                }
              }
            } else {
              showTermsAndConditionsAlert();
            }
          } else {
            YipliUtils.showNotification(
                context: context,
                msg: "No Internet Connectivity",
                type: SnackbarMessageTypes.ERROR,
                duration: SnackbarDuration.MEDIUM);
          }
        });
  }

  void showTermsAndConditionsAlert() {
    YipliUtils.showNotification(
        context: context,
        msg: "Please accept Terms & Conditions.",
        type: SnackbarMessageTypes.ERROR);
  }
}
