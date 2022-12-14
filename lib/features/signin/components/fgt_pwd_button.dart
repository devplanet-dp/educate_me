import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/shared/app_colors.dart';


class ForgotPwdButton extends StatelessWidget {
  const ForgotPwdButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () => Get.to(() => const ForgotPwdView()),
      child: Text(
        'text007'.tr,
        style: kBodyStyle.copyWith(color: kcTextSecondary),
      ),
    );
  }
}
