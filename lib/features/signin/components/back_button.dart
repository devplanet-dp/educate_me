import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/utils/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Get.back(),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        primary: kButtonColor,
        elevation: 0,
        shape: const CircleBorder(),
        minimumSize: Size(48.h, 48.h)
      ),
      child: SvgPicture.asset(kIcBack),
    );
  }
}
