import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/shared/app_colors.dart';
import '../../../../core/shared/shared_styles.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../drawing/drawing_view.dart';

class DrawBrushWidget extends StatelessWidget {
  const DrawBrushWidget({Key? key, required this.qns, required this.enableDraw}) : super(key: key);
  final String qns;
  final bool enableDraw;

  @override
  Widget build(BuildContext context) {
    return       InkWell(
      borderRadius: kBorderLarge,
      onTap: () =>
          Get.dialog(
              enableDraw ? DrawQnsView(question: qns) : const DisableDraw(),
              barrierDismissible: false),
      child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: enableDraw ? Colors.white : kErrorRed.withOpacity(.3),
            boxShadow: [
              BoxShadow(
                color: kcTextGrey.withOpacity(.2),
                blurRadius: 10,
                offset: const Offset(0, 1), // Shadow position
              ),
            ],
          ),
          child: Image.asset(
            kIcBrush,
            height: 20.h,
            width: 20.h,
            color: enableDraw ? Colors.black : kErrorRed,
          ).paddingAll(8)).paddingSymmetric(vertical: 12),
    );
  }
}
