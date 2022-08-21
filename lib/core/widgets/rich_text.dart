import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';

class RichTextWidget extends StatelessWidget {
  final String firstTxt;
  final String secondTxt;
  final VoidCallback onTap;
  final bool isLight;

  const RichTextWidget(
      {Key? key,
        required this.firstTxt,
        required this.secondTxt,
        required this.onTap,  this.isLight=false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(

      text: TextSpan(
          text: firstTxt.tr,
          style: kBodyStyle.copyWith(color: kcTextPrimary),
          children: <TextSpan>[
            TextSpan(
                text: ' ${secondTxt.tr}',
                style: kBodyStyle.copyWith(
                    color: isLight?kAltBgDark: kcPrimaryColor),
                recognizer: TapGestureRecognizer()..onTap = onTap)
          ]),
    );
  }
}