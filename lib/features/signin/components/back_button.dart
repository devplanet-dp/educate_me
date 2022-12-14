import 'package:educate_me/core/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({Key? key, this.onBack}) : super(key: key);
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onBack ?? () => Get.back(),
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          primary: kButtonColor,
          elevation: 0,
          shape: const CircleBorder(),
          minimumSize: Size(40.h, 40.h)),
      child: const Icon(
        Icons.arrow_back,
        color: Color(0xff8E8E8E),
      ),
    );
  }
}
