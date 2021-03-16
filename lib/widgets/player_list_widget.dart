import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'a_widgets_index.dart';

enum PlayerListWidgetMode { listMode, profileMode, rewardsMode }

class PlayerListWidget extends StatefulWidget {
  final PlayerDetails playerTile;
  final bool bIsCurrentPlayer;
  final PlayerListWidgetMode mode;
  final bool bIsPlayerProfileFromBottomNav;

  PlayerListWidget(this.playerTile, this.bIsCurrentPlayer, this.mode,
      {this.bIsPlayerProfileFromBottomNav = false});

  @override
  _PlayerListWidgetState createState() => _PlayerListWidgetState();
}

class _PlayerListWidgetState extends State<PlayerListWidget> {
  GlobalKey<State<StatefulWidget>> _drawerKey;

  Future<void> deleteButtonPress(PlayerDetails playerTile) async {
    print("Delete player Pressed!");
    try {
      Players newPlayer =
          new Players.createDBPlayerFromPlayerDetails(playerTile);
      await newPlayer.deleteRecord();
      Navigator.pop(context);
      YipliUtils.goToPlayersPage();
    } catch (error) {
      print(error);
      print('Error : Delete player');
    }
  }

  Future<void> makeDefaultPlayer(String currentPlayerId) async {
    print("Make Default player Pressed!");
    try {
      await Users.changeCurrentPlayer(currentPlayerId);
      //Utils.goToHomeScreen();
    } catch (error) {
      print(error);
      print('Error : Make Default player');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int points = 0;

    //below is done to convert the points in k format 1000(1k)
    try {
      points = int.parse(widget.playerTile.activityStats.strTotalFitnessPoints);
    } catch (e) {
      print('error from saurabh phone - ${e.toString()}');
    }

    var _fitnesspointsint = NumberFormat.compact().format(points);

    return InkWell(
      onTap: () {
        //print("MODE: ${widget.mode}");
        if (widget.mode == PlayerListWidgetMode.listMode) {
          YipliUtils.goToPlayerProfile(widget.playerTile);
        } else {
          YipliUtils.goToViewImageScreen(widget.playerTile.profilePicUrl);
        }
      },
      child: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      alignment: Alignment.center,
                      image: YipliUtils.getProfilePicImage(
                          widget.playerTile.profilePicUrl),
                      fit: BoxFit.cover))),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: (widget.bIsCurrentPlayer)
                    ? Border.all(width: 2, color: Theme.of(context).accentColor)
                    : null,
                gradient: LinearGradient(
                  transform: GradientRotation(pi / 2),
                  // EEE,0; 818181,46; 383838,76;222,86; 101010,93;000, 100
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Color(0xFF101010).withOpacity(0.8),
//                      Color(0xFF383838).withOpacity(0.46),
//                      Color(0xFF101010).withOpacity(0.93),
                    Color(0xFF000000),
                  ],
                  stops: [0, 0.2, 0.6, 1],
                )),
          ),
          Column(
            children: <Widget>[
              Expanded(flex: 1, child: Container()),
              Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: <Widget>[
                              (Text(
                                widget.playerTile.playerName,
                                style: Theme.of(context).textTheme.headline6,
                              ))
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: FaIcon(
                                          FontAwesomeIcons.birthdayCake,
                                          size: 18,
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: (Text(widget.playerTile.dob)),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: (widget.mode !=
                                          PlayerListWidgetMode.rewardsMode)
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, top: 4),
                                              child: YipliCoin(
                                                coinPadding: 0.0,
                                              ),
                                            ),
                                            (Text(_fitnesspointsint)),
                                          ],
                                        )
                                      : Container(),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
          Container(
              child: (widget.mode == PlayerListWidgetMode.listMode)
                  ? Positioned(
                      top: 0,
                      right: 0,
                      child: widget.bIsCurrentPlayer
                          ? buildActivePlayerIndicator()
                          : buildDrawerButton(widget.playerTile),
                    )
                  : (widget.mode == PlayerListWidgetMode.profileMode)
                      ? Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Theme.of(context).primaryColorLight,
                              ),
                              onPressed: () {
                                YipliUtils.goToEditPlayersPage(
                                    PlayerProfileArguments(widget.playerTile,
                                        widget.bIsPlayerProfileFromBottomNav));
                              }),
                        )
                      : Container()),
        ],
      ),
    );
  }

  Widget buildActivePlayerIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Chip(
        label: Text("Active",
            style: Theme.of(context).textTheme.caption.copyWith(shadows: [
              Shadow(
                blurRadius: 15.0,
                color: Colors.black,
                offset: Offset(0.0, 0.0),
              )
            ])),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }

  Widget buildDrawerButton(PlayerDetails playerTile) {
    _drawerKey = new GlobalKey();
    return Container(
      child: GestureDetector(
          //splashColor: Colors.transparent,
          onTap: () {
            print("Opening drawer!");
            dynamic state = _drawerKey.currentState;
            state.showButtonMenu();
          },
          child: buildPopupMenuButton(playerTile)),
    );
  }

  PopupMenuButton<int> buildPopupMenuButton(PlayerDetails playerTile) {
    return PopupMenuButton<int>(
      key: _drawerKey,
      //Todo @Ameet - Transition to be changed
      icon: FaIcon(
        FontAwesomeIcons.ellipsisV,
        size: 20.0,
        color: Theme.of(context).primaryColorLight,
      ),

      elevation: 24,
      color: Theme.of(context).primaryColor,
      offset: Offset.fromDirection(1.5708, 120.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      itemBuilder: (context) {
        List<PopupMenuItem<int>> listOfPopupMenuItems = [];
        if (!widget.bIsCurrentPlayer)
          listOfPopupMenuItems.addAll([
            PopupMenuItem(
              value: 1,
              child: PlayerPopUpMenu(
                tileText: 'Activate',
                onTap: () {
                  Navigator.pop(context);
                  YipliUtils.showNotification(
                      context: context,
                      msg: "${playerTile.playerName} is the new active player!",
                      type: SnackbarMessageTypes.SUCCESS);

                  makeDefaultPlayer(widget.playerTile.playerId);
                },
              ),
            ),
            PopupMenuItem(
              value: 2,
              child: PlayerPopUpMenu(
                tileText: 'Remove',
                onTap: () {
                  var alertBox = AlertDialog(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    backgroundColor: Theme.of(context).primaryColor,
                    title: Center(
                      child: Container(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Center(child: YipliLogoAnimatedSmall()),
                      ),
                    ),
                    content: Container(
                      child: Text(
                          "All records for ${widget.playerTile.playerName} will be lost"
                          "\n\nAre you sure you want to delete ${widget.playerTile.playerName}",
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.start),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      FlatButton(
                        child: Text(
                          "Okay",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          deleteButtonPress(widget.playerTile);
                          Navigator.pop(context);
                          YipliUtils.showNotification(
                              context: context,
                              msg:
                                  "${playerTile.playerName} successfully removed!",
                              type: SnackbarMessageTypes.SUCCESS);
                        },
                      ),
                    ],
                  );

                  showDialog(
                    context: context,
                    //child: alertBox,
                    builder: (_) {
                      return alertBox;
                    },
                    barrierDismissible: true,
                  );
                },
              ),
            ),
          ]);
        return listOfPopupMenuItems;
      },
    );
  }
}
