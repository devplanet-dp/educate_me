import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/widgets/app_network_image.dart';
import 'package:educate_me/core/widgets/background_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import 'app_round_button.dart';

class ImageSliderAppBar extends StatelessWidget {
  final String images;
  final String title;

  const ImageSliderAppBar({
    Key? key,
    required this.images, required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.h,
      floating: false,
      pinned: true,
      leading: AppRoundButton(
        icon: Icons.arrow_back_sharp,
        onTap: () => Get.back(),
      ).paddingOnly(left: 8, top: 8),
      flexibleSpace: FlexibleSpaceBar(
          background: Stack(
        children: [
          Positioned.fill(
            child: AppNetworkImage(
              path: images,
              thumbHeight: Get.height * 0.25,
              thumbWidth: Get.width * .4,
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: BackgroundOverlayWidget(
              isDark: true,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(title,style: kBodyStyle.copyWith(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 18.sp),),
          )
        ],
      )),
    );
  }
}
