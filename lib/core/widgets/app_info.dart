import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';

class AppInfoWidget extends StatelessWidget {
  final String translateKey;
  final IconData iconData;
  final bool isDark;
  final Widget? icon;

  const AppInfoWidget(
      {Key? key,
      required this.translateKey,
      required this.iconData,
      this.isDark = false,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: !isDark ? kcAccent.withOpacity(.4) : kcTextSecondary.withOpacity(0.8),
          radius: 32,
          child: icon ??
              Icon(
                iconData,
                size: 24,
                color: kcTextSecondary,
              ),
        ),
        vSpaceSmall,
        Text(
          translateKey.tr,
          style: kBody2Style.copyWith(color: isDark ? kAltWhite : kAltBg),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
