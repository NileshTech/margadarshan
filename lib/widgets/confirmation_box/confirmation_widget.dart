import 'package:flutter/material.dart';
import 'package:margadarshan/helpers/color_scheme.dart';

import '../buttons.dart';

// ignore: must_be_immutable
class ProcessCancelConfirmationDialog extends StatelessWidget {
  final String titleText;
  final String subTitleText;
  final String buttonText;
  final String pressToExitText;
  YipliButton pressToContinueButton;
  Function onExitPressed;

  ProcessCancelConfirmationDialog({
    this.titleText,
    this.subTitleText,
    this.buttonText,
    this.pressToExitText,
  });

  // this is used to handle onClick function of exit button.
  void setClickHandler(Function onPressed) {
    this.onExitPressed = onPressed;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    pressToContinueButton = new YipliButton(
      buttonText,
      null,
      null,
      screenSize.width * 0.6,
    );
    pressToContinueButton.setClickHandler(() {
      Navigator.pop(context);
    });

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        height: screenSize.height / 3,
        width: screenSize.width * 0.7,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            border: Border.all(
              color: yipliErrorRed,
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(titleText,
                    style: Theme.of(context).textTheme.headline5),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(subTitleText,
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center),
              ),
            ),
            pressToContinueButton,
            Expanded(
              child: FlatButton(
                child: Text(
                  pressToExitText,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: yipliErrorRed),
                ),
                onPressed: () => onExitPressed(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
