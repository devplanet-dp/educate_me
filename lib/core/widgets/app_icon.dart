import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

class AppIconWidget extends StatelessWidget {
  final IconData iconData;
  final Color iconColor;
  final Color bgColor;
  final VoidCallback onTap;

  const AppIconWidget({
    Key? key,
    required this.iconData,
    this.iconColor = Colors.white,
    required this.bgColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(
        iconData,
        color: iconColor,
      ),
    ).paddingAll(4).card(shape: const CircleBorder(), color: bgColor);
  }
}
