import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../shared/app_colors.dart';

class AppRoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? bgColor;
  final bool isLarge;

  const AppRoundButton({Key? key, required this.icon, required this.onTap, this.bgColor,  this.isLarge=false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      clipBehavior: Clip.antiAlias,
      style: ElevatedButton.styleFrom(
          onPrimary: kAltWhite,
          primary: bgColor?? Colors.white.withOpacity(.8),
          onSurface:kAltBg.withOpacity(.4),
          elevation: 0,
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          shape: const CircleBorder(),
          side: const BorderSide(color: kcStroke)),
      child: Icon(
        icon,
        color: kcTextSecondary,
      ).paddingAll(isLarge?16:8),
    );
  }
}
