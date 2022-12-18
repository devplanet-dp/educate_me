import 'package:educate_me/core/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({Key? key, this.onBack}) : super(key: key);
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onBack ?? () => Get.back(),
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
    );
  }
}
