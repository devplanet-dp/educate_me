import 'package:flutter/material.dart';

import '../shared/app_colors.dart';
import '../shared/ui_helpers.dart';


class BackgroundOverlayWidget extends StatelessWidget {
  final bool isDark;

  const BackgroundOverlayWidget({Key? key, this.isDark = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.screenHeight(percent: 1),
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            !isDark
                ? kcPrimaryColor.withOpacity(.8)
                : kBgDark.withOpacity(.8),
            !isDark
                ? kcPrimaryColor.withOpacity(.6)
                : kBgDark.withOpacity(.6)
          ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
    );
  }
}