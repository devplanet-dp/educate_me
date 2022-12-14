import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/widgets/app_network_image.dart';
import 'package:educate_me/core/widgets/background_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'app_round_button.dart';

class ImageSliderAppBar extends StatelessWidget {
  final String images;
  final String title;

  const ImageSliderAppBar({
    Key? key,
    required this.images,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deviceType = getDeviceType(MediaQuery.of(context).size);
    return SliverAppBar(
      expandedHeight: 200.h,
      floating: true,
      pinned: true,
      leadingWidth: deviceType == DeviceScreenType.tablet ? 72 : 60,
      leading: AppRoundButton(
        icon: Icons.arrow_back_sharp,
        onTap: () => Get.back(),
      ).paddingOnly(
          left: deviceType == DeviceScreenType.tablet ? 16 : 8,
          top: deviceType == DeviceScreenType.tablet ? 2 : 8),
      flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          background: Stack(
            children: [
              Positioned.fill(
                child: AppNetworkImage(
                  path: images,
                  thumbHeight: Get.height,
                  thumbWidth: Get.width,
                ),
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: BackgroundOverlayWidget(
                  isDark: true,
                ),
              ),
              ResponsiveBuilder(builder: (context, _) {
                return Align(
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: kBodyStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: _.isTablet ? 32 : 18),
                  ),
                );
              })
            ],
          )),
    );
  }
}

class ImageSliderAppBarNonFloating extends StatelessWidget {
  final String images;
  final String title;
  final VoidCallback onTap;

  const ImageSliderAppBarNonFloating({
    Key? key,
    required this.images,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deviceType = getDeviceType(MediaQuery.of(context).size);
    return AppBar(
      leading: AppRoundButton(
        icon: Icons.arrow_back_sharp,
        onTap: onTap,
      ).paddingOnly(left: 8, top: deviceType == DeviceScreenType.tablet ? 2 : 8),
      leadingWidth: deviceType == DeviceScreenType.tablet ? 75 : 56,
      flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          background: Stack(
            children: [
              Positioned.fill(
                child: AppNetworkImage(
                  path: images,
                  thumbHeight: Get.height,
                  thumbWidth: Get.width,
                ),
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: BackgroundOverlayWidget(
                  isDark: true,
                ),
              ),
              ResponsiveBuilder(builder: (context, _) {
                return Align(
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: kBodyStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: _.isTablet ? 32 : 18),
                  ),
                );
              })
            ],
          )),
    );
  }
}
