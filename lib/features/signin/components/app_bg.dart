import 'package:educate_me/core/utils/constants/app_assets.dart';
import 'package:educate_me/features/signin/components/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

class AppBgWidget extends StatelessWidget {
  const AppBgWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: Stack(
        children: [
          Positioned(
              bottom: 0,
              left: 0,
              child: SvgPicture.asset(
                kImgUnionFaded,
                width: Get.width * .2,
                height: Get.height * .68,
              )),
          ]

      ),
    );
  }
}
