import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

// Box Decorations

BoxDecoration fieldDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: kBorderLarge,
  border: Border.all(color: kcStroke),
  boxShadow: shadow
);
BoxDecoration fieldDecorationSelected = BoxDecoration(
  color: Colors.white,
  borderRadius: kBorderLarge,
  border: Border.all(color: kcPrimaryColor, width: 2),
);
List<BoxShadow> shadow = [
  const BoxShadow(
    color: kcStroke,
    blurRadius: 5,
    offset: Offset(1, 0),
  ),
];

Border kBorder = Border.all(color: kcStroke);

BoxDecoration disabledFieldDecortaion = BoxDecoration(
    borderRadius: BorderRadius.circular(5), color: Colors.grey[100]);

// Field Variables

const double fieldHeight = 55;
const double smallFieldHeight = 40;
const double inputFieldBottomMargin = 30;
const double inputFieldSmallBottomMargin = 0;
const EdgeInsets fieldPadding = EdgeInsets.symmetric(horizontal: 15);
 EdgeInsets fieldPaddingDesktop = EdgeInsets.symmetric(horizontal: 64.w);
const EdgeInsets fieldPaddingAll = EdgeInsets.all(10.0);
 EdgeInsets kLargeFieldPadding =
    EdgeInsets.symmetric(horizontal: 48.w, vertical: 24);

//Radius
const double kRadiusSmall = 8;
const double kRadiusMedium = 12;
const double kRadiusLarge = 18;
const double kRadiusAvatar = 40.0;

///border radius
BorderRadius kBorderSmall =
    const BorderRadius.all(Radius.circular(kRadiusSmall));
BorderRadius kBorderMedium =
    const BorderRadius.all(Radius.circular(kRadiusMedium));
BorderRadius kBorderLarge =
    const BorderRadius.all(Radius.circular(kRadiusLarge));

/// text themes
// To make it clear which weight we are using, we'll define the weight even for regular
// fonts
const TextStyle kHeading1Style =
    TextStyle(fontSize: 34, fontWeight: FontWeight.w400, color: kcTextPrimary);

const TextStyle kHeading2Style =
    TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: kcTextPrimary);

const TextStyle kHeading3Style =
    TextStyle(fontSize: 25, fontWeight: FontWeight.w600, color: kcTextPrimary);

const TextStyle kHeadlineStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: kcTextPrimary);

const TextStyle kBodyStyle =
    TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: kcTextPrimary);

const TextStyle kBody1Style =
    TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: kcTextPrimary);

const TextStyle kBody2Style =
    TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: kcTextPrimary);

const TextStyle kLabelStyle =
TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: kcTextPrimary);

const TextStyle kSubheadingStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: kcTextPrimary);

const TextStyle kCaptionStyle =
    TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kcTextPrimary);

//shaders
final Shader goldGradient = const LinearGradient(
  colors: <Color>[Color(0xFFfcf29f), Color(0xFFe5c469)],
).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
