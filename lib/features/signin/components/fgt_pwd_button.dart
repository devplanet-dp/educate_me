import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/shared/app_colors.dart';
import '../../../core/shared/shared_styles.dart';
import '../../../core/shared/ui_helpers.dart';

class ForgotPwdButton extends StatelessWidget {
  const ForgotPwdButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () => Get.to(() => const ForgotPwdView()),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Iconsax.message_question,
            color: kErrorRed,
          ),
          hSpaceSmall,
          Text(
            'text007'.tr,
            style: kCaptionStyle.copyWith(color: kAltWhite),
          )
        ],
      ),
    );
  }
}
