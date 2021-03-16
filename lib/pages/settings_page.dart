import 'package:package_info/package_info.dart';

import 'a_pages_index.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/settings_page';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  PackageInfo _packageInfo = PackageInfo(
    version: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return YipliPageFrame(
      title: Text("Settings"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //app tour button
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                child: Container(
                  height: screenSize.width / 8,
                  padding: EdgeInsets.all(2.0),
                  width: MediaQuery.of(context).size.width * .95,
                  decoration: new BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20.0, // soften the shadow
                        spreadRadius: 0.0, //extend the shadow
                        offset: Offset(
                          0.0, // Move to right horizontally
                          0.75, // Move to bottom Vertically
                        ),
                      )
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      print("reset app tour pressed");
                      FeatureDiscovery.clearPreferences(
                        context,
                        {
                          YipliConstants.featureFitnessGamingId,
                          YipliConstants.featureAdventureGamingId,
                          YipliConstants.featureDiscoveryPlayerProfileId,
                          YipliConstants.featureDiscoveryYipliFeedId,
                          YipliConstants.featureDiscoverySwitchPlayerId,
                          YipliConstants.featureDiscoveryDrawerButtonId,
                          YipliConstants.featureDiscoveryAddNewMatId,
                          YipliConstants.featureDiscoveryAddNewPlayerId,
                        },
                      );
                      YipliUtils.initializeApp();
                    },
                    child: Center(
                      child: Text(
                        'Take app tour',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                ),
              ),

              //logout button
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                child: Container(
                  height: screenSize.width / 8,
                  padding: EdgeInsets.all(2.0),
                  width: MediaQuery.of(context).size.width * .95,
                  decoration: new BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20.0, // soften the shadow
                        spreadRadius: 0.0, //extend the shadow
                        offset: Offset(
                          0.0, // Move to right horizontally
                          0.75, // Move to bottom Vertically
                        ),
                      )
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      YipliUtils.goToLogoutScreen();
                    },
                    child: Center(
                      child: Text(
                        'Logout',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: yipliOrange.withOpacity(1.0)),
                      ),
                    ),
                  ),
                ),
              ),

              //app tour button
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
              //   child: FlatButton(
              //       color: Theme.of(context).primaryColor,
              //       child: Text(
              //         "Take the app tour again",
              //         style: TextStyle(
              //             color: Theme.of(context).textTheme.bodyText1.color),
              //       ),
              //       onPressed: () {
              //         print("reset app tour pressed");
              //         FeatureDiscovery.clearPreferences(
              //           context,
              //           {
              //             YipliConstants.featureFitnessGamingId,
              //             YipliConstants.featureAdventureGamingId,
              //             YipliConstants.featureDiscoveryPlayerProfileId,
              //             YipliConstants.featureDiscoveryYipliFeedId,
              //             YipliConstants.featureDiscoverySwitchPlayerId,
              //             YipliConstants.featureDiscoveryDrawerButtonId,
              //             YipliConstants.featureDiscoveryAddNewMatId,
              //             YipliConstants.featureDiscoveryAddNewPlayerId,
              //           },
              //         );
              //         YipliUtils.initializeApp();
              //       }),
              // ),
              //logout button
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
              //   child: FlatButton(
              //     color: Colors.red.shade900,
              //     onPressed: () {
              //       YipliUtils.goToLogoutScreen();
              //     },
              //     child: Text(
              //       "Logout",
              //       style: TextStyle(
              //           color: Theme.of(context).textTheme.bodyText1.color),
              //     ),
              //   ),
              // ),
              // reward button
              // Padding(
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
              //     child: FlatButton(
              //       color: Colors.blue.shade900,
              //       onPressed: () {
              //         showDialog(
              //           context: context,
              //           barrierDismissible: true,
              //           builder: (BuildContext context) => AdventureRewardPopUp(),
              //         );
              //       },
              //       child: Text(
              //         'reward card',
              //         style: TextStyle(
              //             color: Theme.of(context).textTheme.bodyText1.color),
              //       ),
              //     )),

              //reset local cache
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
              //   child: FlatButton(
              //     color: Colors.amber.shade900,
              //     onPressed: () {
              //       YipliAppLocalStorage.reset().then((value) {
              //         YipliUtils.showNotification(
              //           context: context,
              //           msg: "Local app cache cleared successfully!",
              //           type: SnackbarMessageTypes.SUCCESS,
              //         );
              //       }).catchError(() {
              //         YipliUtils.showNotification(
              //           context: context,
              //           msg: "Local app cache NOT cleared!",
              //           type: SnackbarMessageTypes.ERROR,
              //         );
              //       });
              //     },
              //     child: Text(
              //       "Reset Local Cache",
              //       style: TextStyle(
              //           color: Theme.of(context).textTheme.bodyText1.color),
              //     ),
              //   ),
              // ),

              //select world
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
              //   child: FlatButton(
              //       color: Theme.of(context).primaryColor,
              //       child: Text(
              //         "Questioner Pages",
              //         style: TextStyle(
              //             color: Theme.of(context).textTheme.bodyText1.color),
              //       ),
              //       onPressed: () {
              //         print("Questioner Pages");
              //         YipliUtils.goToPlayerQuestioner();
              //       }),
              // ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 50, 10, 20),
            child: Text(
              "App Version : " + _packageInfo.version,
              textAlign: TextAlign.end,
              style:
                  Theme.of(context).textTheme.headline6.copyWith(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
