import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/shared/app_colors.dart';
import '../../../core/shared/shared_styles.dart';
import '../../../core/shared/ui_helpers.dart';
import '../../../core/utils/constants/app_assets.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSignUp;
  final bool isBusy;

  const GoogleSignInButton(
      {Key? key,
      required this.onTap,
      this.isSignUp = false,
     required this.isBusy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: isBusy ? () {} : onTap,
      clipBehavior: Clip.antiAlias,
      elevation: 8,
      padding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Container(
        height: 50,
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: kBorderSmall,
          border: Border.all(color: kcStroke),
        ),
        child: isBusy
            ? const Center(
                child: FittedBox(
                child: CircularProgressIndicator(),
              ))
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    kIcGoogle,
                    height: 24,
                    width: 24,
                  ),
                  hSpaceMedium,
                  Text(
                    isSignUp ? 'text011'.tr : 'text010'.tr,
                    style: kBody1Style.copyWith(fontWeight: FontWeight.w500),
                  )
                ],
              ),
      ),
    ).card(
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))));
  }
}
