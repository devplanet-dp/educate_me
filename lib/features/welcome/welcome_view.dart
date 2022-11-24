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
    return Scaffold(
      body: Stack(
        children: const [_BackgroundUnion(), _WelcomeTitle()],
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
    return ResponsiveBuilder(builder: (context, _) {
      return _.isDesktop ? _buildDesktop() : _buildForMobile();
    });
  }

  Positioned _buildForMobile() {
    return Positioned(
        left: 18,
        bottom: 0,
        right: 18,
        child: [
          Text(
            'Let’s Get \nStarted',
            style: kHeading1Style.copyWith(
                fontWeight: FontWeight.bold, fontSize: 48.sp),
          ),
          const Text('We Math-welcome you :)'),
          vSpaceMedium,
          BoxButtonWidget(
            onPressed: () => Get.to(() => const SignInView()),
            buttonText: 'Join now',
          ).width(Get.width * 1),
          vSpaceMedium
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start));
  }

  Row _buildDesktop() {
    return Row(
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Let’s Get \nStarted',
              style: kHeading1Style.copyWith(
                  fontWeight: FontWeight.bold, fontSize: 18.sp),
            ),
            const Text('We Math-welcome you :)'),
          ],
        )),
        Expanded(
            child: BoxButtonWidget(
          onPressed: () => Get.to(() => const SignInView()),
          buttonText: 'Join now',
        )).width(Get.width / 3),
        SizedBox(
          width: 16.w,
        )
      ],
    );
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
            height: Get.height * .48,
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
