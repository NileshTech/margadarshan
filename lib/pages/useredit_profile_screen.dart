import 'a_pages_index.dart';

class UserEditProfile extends StatefulWidget {
  static const String routeName = '/useredit_profile_screen';

  @override
  _UserEditProfileState createState() => _UserEditProfileState();
}

class _UserEditProfileState extends State<UserEditProfile> {
  String _userId;
  String _profilePicUrl;
  String _displayName;
  String _email;
  String _contactNo;
  String _location;
  bool _hasSubscribed;

  bool _isScreenLoading = false;
  bool _isProfileImageLoading = false;

  FileImage _profilePic;

  String _oldPhoneNo;

  BuildContext _currentContext;

  String _defaultPic = "assets/images/default_image_placeholder.jpg";

  GlobalKey<FormState> _addNewPlayerFormKey;
  File image;
  final YipliButton submitButton = new YipliButton("Submit");
  bool _isUploading = false;
  ProfilePicCaptureAndUploadResult result;
  BuildContext editProfileContext;

  Future<void> submitButtonPress() async {
    if (YipliUtils.appConnectionStatus == AppConnectionStatus.CONNECTED) {
      print("Submit player Pressed!");
      final FormState form = _addNewPlayerFormKey.currentState;
      if (_addNewPlayerFormKey.currentState.validate()) {
        form.save();
        if (_oldPhoneNo != _contactNo) {
          print("New phone not same ... ");
          YipliUtils.showPhoneVerificationDialog(_currentContext, _contactNo,
              () async {
            await saveUserProfileData(_contactNo);

            //YipliUtils.goToUserProfilePage();
            YipliUtils.navigatorKey.currentState.pop();
            YipliUtils.showNotification(
              context: _currentContext,
              msg: "Your number was verified!",
              type: SnackbarMessageTypes.INFO,
            );
          }, () async {
            await saveUserProfileData(_oldPhoneNo);
          });
        } else {
          print("New phone IS same ... ");
          await saveUserProfileData(_contactNo);
          YipliUtils.navigatorKey.currentState.pop();
        }
      }
    } else {
      YipliUtils.showNotification(
          context: context,
          msg: "No Internet Connectivity",
          type: SnackbarMessageTypes.ERROR,
          duration: SnackbarDuration.MEDIUM);
    }
  }

  Future saveUserProfileData(String phone) async {
    if (YipliUtils.appConnectionStatus == AppConnectionStatus.CONNECTED) {
      try {
        setState(() {
          _isScreenLoading = true;
        });
        User user = FirebaseAuth.instance.currentUser;
        print(
            'Adding new Player with following details :${user.uid}  $_displayName $_email $_contactNo $_location $_profilePicUrl $_profilePicUrl');

        UserDetails userTile = new UserDetails(
          userName: _displayName,
          userMailId: _email,
          userId: user.uid,
          contactNo: phone,
          userLocation: _location,
          profilePicUrl: _profilePicUrl,
        );

        Users newUser = new Users.createDBUserFromUserDetails(userTile);
        await newUser.persistRecord();
        setState(() {
          _isScreenLoading = false;
        });
      } catch (error) {
        setState(() {
          _isScreenLoading = false;
        });
        print(error);
        print('Error Aaya -  user');
      }
    } else {
      YipliUtils.showNotification(
          context: context,
          msg: "No Internet Connectivity",
          type: SnackbarMessageTypes.ERROR,
          duration: SnackbarDuration.MEDIUM);
    }
  }

  Future saveUserProfilePic() async {
    if (YipliUtils.appConnectionStatus == AppConnectionStatus.CONNECTED) {
      try {
        setState(() {
          _isScreenLoading = true;
        });
        User user = FirebaseAuth.instance.currentUser;
        print(
            'Adding new Player with following details :${user.uid}  $_displayName $_email $_contactNo $_location $_profilePicUrl $_profilePicUrl');

        UserDetails userTile = new UserDetails(
          userId: user.uid,
          profilePicUrl: _profilePicUrl,
        );

        Users newUser = new Users.createDBUserFromUserDetails(userTile);
        await newUser.persistProfilePic();
        setState(() {
          _isScreenLoading = false;
        });
      } catch (error) {
        setState(() {
          _isScreenLoading = false;
        });
        print(error);
        print('Error Aaya -  user');
      }
    } else {
      YipliUtils.showNotification(
          context: context,
          msg: "No Internet Connectivity",
          type: SnackbarMessageTypes.ERROR,
          duration: SnackbarDuration.MEDIUM);
    }
  }

  @override
  void initState() {
    super.initState();
    submitButton.setClickHandler(submitButtonPress);
    _addNewPlayerFormKey = GlobalKey<FormState>();
  }

  Widget _buildProfileImage(BuildContext context) {
    editProfileContext = context;
    print("Building the user profile image in edit mode ");
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Center(
        child: GestureDetector(
            child: Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    width: YipliConstants.getProfilePicDimensionsLarge(context)
                        .width,
                    height: YipliConstants.getProfilePicDimensionsLarge(context)
                        .height,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: _profilePicUrl == null
                            ? AssetImage(_defaultPic)
                            : _profilePic == null
                                ? FirebaseImage(
                                    "${FirebaseStorageUtil.profilepics}/$_profilePicUrl")
                                : _profilePic,
                      ),
                      borderRadius: BorderRadius.circular(90.0),
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 3.0,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.photo_camera,
                        color: IconTheme.of(context).color,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    height: YipliConstants.getProfilePicDimensionsLarge(context)
                        .height,
                    width: YipliConstants.getProfilePicDimensionsLarge(context)
                        .width,
                    child: CircularProgressIndicator(
                      strokeWidth: 4.0,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context)
                              .primaryColorLight
                              .withOpacity(_isUploading ? 1.0 : 0)),
                    ),
                  ),
                )
              ],
            ),
            onTap: () async {
              if (YipliUtils.appConnectionStatus ==
                  AppConnectionStatus.CONNECTED) {
                var fileName = Uuid().v4();
                print("FILENAME : $fileName");
                Size sizeToUpload = new Size(512, 512);
                if (result != null) {
                  result.uploadTask.cancel();
                }
                result = await ProfilePicManager.captureAndUpload(
                    context, sizeToUpload, fileName);
                if (result != null) {
                  setState(() {
                    _isUploading = true;
                  });
                  result.uploadTask.events.listen((uploadTaskEvent) async {
                    switch (uploadTaskEvent.type) {
                      case StorageTaskEventType.resume:
                        break;
                      case StorageTaskEventType.progress:
                        setState(() {
                          _isUploading = true;
                        });

                        break;
                      case StorageTaskEventType.pause:
                        break;
                      case StorageTaskEventType.success:
                        setState(() {
                          _isUploading = false;
                          _profilePicUrl = fileName;
                          _profilePic = FileImage(result.imageFile);
                        });
                        YipliUtils.showNotification(
                          context: editProfileContext,
                          msg:
                              "Picture uploaded successfully. Tap submit to save.",
                          duration: SnackbarDuration.SHORT,
                          type: SnackbarMessageTypes.SUCCESS,
                        );

                        await saveUserProfilePic();
                        break;
                      case StorageTaskEventType.failure:
                        setState(() {
                          _isUploading = false;
                        });

                        YipliUtils.showNotification(
                          context: editProfileContext,
                          msg: "Picture upload failed. Please retry.",
                          duration: SnackbarDuration.SHORT,
                          type: SnackbarMessageTypes.ERROR,
                        );
                        break;
                    }
                  });
                }
              } else {
                YipliUtils.showNotification(
                    context: context,
                    msg: "Internet Connectivity is required to change Profile.",
                    type: SnackbarMessageTypes.ERROR,
                    duration: SnackbarDuration.MEDIUM);
              }
            }),
      ),
    );
  }

  //OnSaved Functions for al the Input fields
  void onSavedDisplayName(String displayName) {
    _displayName = displayName;
    print("FullName : $_displayName saved");
  }

  void onSavedEmail(String email) {
    _email = email;
    print("Email : $_email saved");
  }

  void onSavedContactNo(String contactNo) {
    _contactNo = contactNo;
    print("Contact $_contactNo saved");
  }

  void onSavedLocation(String weight) {
    _location = weight;
    print("location: $_location saved");
  }

  @override
  Widget build(BuildContext context) {
    _currentContext = context;
    final Size screenSize = MediaQuery.of(context).size;

    UserModel userProfileElements = ModalRoute.of(context).settings.arguments;
    if (userProfileElements != null) {
      _userId = _userId ?? userProfileElements.id;
      _profilePicUrl = _profilePicUrl ?? userProfileElements.profilePicUrl;
      _displayName = _displayName ?? userProfileElements.displayName;
      _email = _email ?? userProfileElements.email;
      _contactNo = _contactNo ?? userProfileElements.contactNo;
      _oldPhoneNo = _contactNo;
      _location = _location ?? userProfileElements.location;
    }

    YipliTextInput _nameInput = new YipliTextInput(
        "Name",
        "Family name*",
        Icons.account_circle,
        false,
        YipliValidators.validateName,
        onSavedDisplayName,
        _displayName);
    YipliTextInput _emailInput = new YipliTextInput(
        "Email",
        "Email*",
        Icons.email,
        false,
        YipliValidators.validateEmail,
        onSavedEmail,
        _email,
        false);
    YipliTextInput _contactNoInput = new YipliTextInput(
        "Contact No.",
        "Contact Number",
        Icons.phone,
        false,
        null,
        onSavedContactNo,
        _contactNo);
    _contactNoInput.inputType = TextInputType.numberWithOptions(decimal: true);
    _contactNoInput.addWhitelistingTextFormatter(
        FilteringTextInputFormatter.allow(
            RegExp(r"^\d{1,10}|\d{0,5}\.\d{1,2}$")));
    YipliTextInput _locationInput = new YipliTextInput("Location", "Location",
        Icons.location_city, false, null, onSavedLocation, _location);

    return YipliPageFrame(
      title: Text('Edit Profile'),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              //list tile of all the player data
              ModalProgressHUD(
                progressIndicator: YipliLoader(),
                inAsyncCall: _isScreenLoading,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height:
                            YipliConstants.getProfilePicDimensionsLarge(context)
                                    .height *
                                0.84,
                      ),
                      Form(
                        key: _addNewPlayerFormKey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: screenSize.width * 0.9,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: screenSize.height / 80,
                                    ),
                                    _nameInput,
                                    SizedBox(
                                      height: screenSize.height / 80,
                                    ),
                                    _emailInput,
                                    SizedBox(
                                      height: screenSize.height / 80,
                                    ),
                                    _contactNoInput,
                                    SizedBox(
                                      height: screenSize.height / 80,
                                    ),
                                    _locationInput,
                                    SizedBox(
                                      height: screenSize.height / 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenSize.height / 10,
                      ),
                      submitButton,
                    ],
                  ),
                ),
              ),
              //Profile picture
              Container(
                child: ModalProgressHUD(
                  inAsyncCall: _isProfileImageLoading,
                  progressIndicator: YipliLoader(),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: screenSize.height / 600,
                      ),
                      _buildProfileImage(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePicCaptureAndUploadResult {
  final StorageUploadTask uploadTask;
  final File imageFile;

  ProfilePicCaptureAndUploadResult({this.uploadTask, this.imageFile});
}

class ProfilePicManager {
  static Future<ProfilePicCaptureAndUploadResult> captureAndUpload(
      BuildContext context, Size sizeToUpload, String fileName) async {
    File imageToUpload = await YipliUtils.getImage(context);
    if (imageToUpload != null) {
      File croppedImage = await ImageCropper.cropImage(
        sourcePath: imageToUpload.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        maxHeight: sizeToUpload.width.round(),
        maxWidth: sizeToUpload.height.round(),
        cropStyle: CropStyle.circle,
        compressQuality: 35,
        androidUiSettings: AndroidUiSettings(
            backgroundColor: Theme.of(context).backgroundColor,
            statusBarColor: Theme.of(context).primaryColor,
            toolbarTitle: "That's a Yipli picture!",
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Theme.of(context).primaryColorLight,
            lockAspectRatio: true),
      );

      if (croppedImage != null) {
        StorageUploadTask uploadTask = FirebaseStorageUtil.upload(context,
            croppedImage, FirebaseStorageUtil.profilePicsRef, fileName);

        ProfilePicCaptureAndUploadResult result =
            ProfilePicCaptureAndUploadResult(
          uploadTask: uploadTask,
          imageFile: croppedImage,
        );
        return result;
      }
      return null;
    }
    return null;
  }
}
