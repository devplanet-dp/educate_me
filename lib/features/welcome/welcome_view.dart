import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/utils/constants/app_assets.dart';
import 'package:educate_me/features/signin/signin_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../core/shared/ui_helpers.dart';
import '../../core/widgets/busy_button.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: const [_BackgroundUnion(), _WelcomeTitle()],
        ),
      ),
    );
  }
}

class _WelcomeTitle extends StatelessWidget {
  const _WelcomeTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 18,
        bottom: Get.width * .02,
        right: 18,
        child: ResponsiveBuilder(builder: (context, _) {
          return [
            Text(
              'Let’s Get \nStarted',
              style: kHeading1Style.copyWith(
                  fontWeight: FontWeight.w600, fontSize: 64),
            ).paddingOnly(left: _.isTablet?48:0),
            Text('We Math-welcome you :)',
                style: kBodyStyle.copyWith(
                    fontSize: 20, fontWeight: FontWeight.w300)).paddingOnly(left: _.isTablet?48:0),
           _.isTablet? vSpaceMassive:vSpaceMedium,
            BoxButtonWidget(
              onPressed: () => Get.to(() => const SignInView()),
              buttonText: 'Join now',
              fontSize: _.isTablet ? 48 : 24,
              radius: _.isTablet ? 18 : 48,
            ).width(_.isTablet ? Get.width * .3 : Get.width * 1).center(),
            vSpaceMedium
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
        }));
  }
}

class _BackgroundUnion extends StatelessWidget {
  const _BackgroundUnion({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 0,
          child: SvgPicture.asset(
            kImgUnion,
            width: Get.width * .2,
            height: Get.height * .68,
          ),
        ),
        Positioned(
            top: 8,
            right: 8,
            child: Image.asset(
              kAppLogo,
              width: 69.h,
              height: 69.h,
            ))
      ],
    ).height(Get.height).width(Get.width);
  }
}
