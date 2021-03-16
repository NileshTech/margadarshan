import 'dart:io';

import 'package:device_apps/device_apps.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:margadarshan/classes/InterAppCommunicationArguments.dart';
import 'package:margadarshan/helpers/utils.dart';
import 'package:margadarshan/page_models/current_mat_model.dart';
import 'package:margadarshan/page_models/current_player_model.dart';
import 'package:margadarshan/page_models/user_model.dart';
import 'package:margadarshan/widgets/cards/games_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:provider/provider.dart';

Tween<double> _scaleTween = Tween<double>(begin: 0.9, end: 1.0);

class GamesDisplayListItem extends StatelessWidget {
  final String description;
  final String intensity;
  final String name;
  final String imageLink;
  final double rating;
  final String iosURL;
  final String androidURL;
  final String windowsURL;
  const GamesDisplayListItem({
    Key key,
    this.description,
    this.intensity,
    this.name,
    this.imageLink,
    this.rating,
    this.iosURL,
    this.androidURL,
    this.windowsURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      bool isInstalled = false;
      return FutureBuilder(
        future: DeviceApps.isAppInstalled(androidURL),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          isInstalled = snapshot.data;
          return Consumer3<UserModel, CurrentPlayerModel, CurrentMatModel>(
            builder: (context, userModel, currentPlayerModel, currentMatModel,
                child) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: TweenAnimationBuilder(
                  tween: _scaleTween,
                  curve: Curves.easeIn,
                  duration: Duration(milliseconds: 750),
                  builder: (context, scale, child) {
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                            flex: 2,
                            child: Container(
                              // color: Colors.red,
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.centerLeft,
                              child: GameIcon(imageLink: imageLink),
                            )),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(
                                                  fontWeight: FontWeight.w800,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          description,
                                          style: Theme.of(context)
                                              .textTheme
                                              .overline
                                              .copyWith(letterSpacing: 0),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text("Intensity: $intensity",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .overline
                                                  .copyWith(letterSpacing: 0)),
                                        ),
                                      )
                                      /* Text(
                                        "Rating: ${rating.toStringAsFixed(1)}",
                                        style: TextStyle(fontSize: 12, color: Colors.white),
                                      ),*/
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: (isInstalled)
                              ? Column(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: InkWell(
                                        onTap: () {
                                          try {
                                            if (currentMatModel
                                                    .mat.macAddress ==
                                                null) {
                                              print('currentMatModel is null');
                                              return YipliUtils.showNotification(
                                                  context: context,
                                                  msg:
                                                      "Register your Yipli MAT to play.\nGo to Menu -> My Mats",
                                                  type: SnackbarMessageTypes
                                                      .ERROR,
                                                  duration:
                                                      SnackbarDuration.LONG);
                                            } else if (currentPlayerModel ==
                                                null) {
                                              print(
                                                  'currentPlayerModel is null');
                                              return YipliUtils.showNotification(
                                                  context: context,
                                                  msg:
                                                      "Add player to play.\nGo to Menu -> Players",
                                                  type: SnackbarMessageTypes
                                                      .ERROR,
                                                  duration:
                                                      SnackbarDuration.LONG);
                                            } else {
                                              InterAppCommunicationArguments
                                                  args;
                                              print(
                                                  "Launching Game with Arguments: ${currentPlayerModel.player.name} ${currentPlayerModel.player.dob} ${currentPlayerModel.player.height} ${currentPlayerModel.player.weight} ${currentMatModel.mat.matId} ${currentMatModel.mat.macAddress} ${currentPlayerModel.player.isMatTutDone}");

                                              args = new InterAppCommunicationArguments(
                                                  uId: userModel.id,
                                                  pId: currentPlayerModel
                                                      .player.id,
                                                  pName: currentPlayerModel
                                                      .player.name,
                                                  isMatTutDone: currentPlayerModel
                                                              .player
                                                              .isMatTutDone ==
                                                          null
                                                      ? ''
                                                      : currentPlayerModel
                                                          .player.isMatTutDone
                                                          .toString(),
                                                  pDOB: currentPlayerModel.player.dob ==
                                                          null
                                                      ? ''
                                                      : DateFormat('MM-dd-yyyy').format(
                                                          new DateFormat('dd-MMM-yyyy')
                                                              .parse(currentPlayerModel.player.dob)),
                                                  pHt: currentPlayerModel.player.height,
                                                  pWt: currentPlayerModel.player.weight,
                                                  pPicUrl: currentPlayerModel.player.profilePicUrl,
                                                  mId: currentMatModel.mat.matId,
                                                  mMac: currentMatModel.mat.macAddress);

                                              // SystemChannels.platform
                                              //     .invokeMethod('SystemNavigator.pop');
                                              print(
                                                  "Play pressed! Sending arguments : ${args.toJson()}");
                                              YipliUtils.openAppWithArgs(
                                                  androidURL, args.toJson());
                                            }
                                          } catch (e) {
                                            print("Error of arg!!!");
                                            print(e);
                                          }
                                        },
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        blurRadius: 5,
                                                        offset: Offset
                                                            .fromDirection(
                                                                1.5708, 4.0),
                                                        spreadRadius: 0)
                                                  ],
                                                ),
                                                alignment: Alignment.center,
                                                child: ClipRRect(
                                                  child: Icon(
                                                    FontAwesomeIcons.playCircle,
                                                    color: IconTheme.of(context)
                                                        .color,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text('Play',
                                          style: Theme.of(context)
                                              .textTheme
                                              .overline
                                              .copyWith(letterSpacing: 0)),
                                    )
                                  ],
                                )
                              : Column(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: InkWell(
                                        onTap: () {
                                          print("Install pressed!");
                                          OpenAppstore.launch(
                                              androidAppId: androidURL,
                                              iOSAppId: iosURL);
                                          // SystemChannels.platform
                                          //     .invokeMethod('SystemNavigator.pop');
                                        },
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.5),
                                                      blurRadius: 5,
                                                      offset:
                                                          Offset.fromDirection(
                                                              1.5708, 4.0),
                                                      spreadRadius: 0)
                                                ],
                                              ),
                                              child: ClipRRect(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: FlareActor(
                                                      "assets/flare/download_new.flr",
                                                      alignment:
                                                          Alignment.center,
                                                      fit: BoxFit.cover,
                                                      animation: "download",
                                                    ),
                                                  ),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text('Download',
                                          style: Theme.of(context)
                                              .textTheme
                                              .overline
                                              .copyWith(letterSpacing: 0)),
                                    )
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    }
    return Container();
  }
}
