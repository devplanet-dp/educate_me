import 'package:educate_me/features/signup/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/shared/app_colors.dart';
import '../../../core/shared/shared_styles.dart';

class CreateAccountText extends StatelessWidget {
  const CreateAccountText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => const SignUpView()),
      child: Text(
        'text008'.tr,
        style: kBodyStyle.copyWith(color: kcTextSecondary),
      ),
    );
  }
}
