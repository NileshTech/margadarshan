import 'package:flutter/material.dart';
import 'package:margadarshan/helpers/utils.dart';

class DrawTile extends StatelessWidget {
  final String tileText;
  final IconData tileIcon;
  final String targetRoute;
  final bool shouldReplaceViewStack;

  DrawTile(
      {this.tileText,
      this.tileIcon,
      this.targetRoute,
      this.shouldReplaceViewStack = false});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return ListTile(
      title: Container(
        width: screenSize.width / 3.5,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              tileIcon,
              // size: 18,
              color: Theme.of(context).accentColor,
            ),
            SizedBox(
              width: 15,
            ),
            Text(tileText,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Theme.of(context).accentColor)),
          ],
        ),
      ),
      onTap: () {
        if (shouldReplaceViewStack) {
          Navigator.of(context).pushReplacementNamed(targetRoute);
        } else {
          Navigator.of(context).pop();
          targetRoute == null
              ? YipliUtils.showNotification(
                  context: context,
                  msg: "Please add player and check again.",
                  type: SnackbarMessageTypes.ERROR,
                  duration: SnackbarDuration.MEDIUM)
              : Navigator.of(context).pushNamed(targetRoute);
        }
      },
    );
  }
}
