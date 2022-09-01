import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../shared/app_colors.dart';

class RoundButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget icon;
  final Color bgColor;

  const RoundButton({Key? key, required this.onTap, required this.icon, this.bgColor = kAltWhite})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      height: 64.h,
      minWidth: 64.w,
      shape: const CircleBorder(),
      elevation: 0,
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: icon,
      ),
    );
  }
}
