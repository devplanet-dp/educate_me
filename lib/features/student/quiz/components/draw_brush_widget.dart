import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../core/shared/app_colors.dart';
import '../../../../core/shared/shared_styles.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../drawing/drawing_view.dart';

class DrawBrushWidget extends StatelessWidget {
  const DrawBrushWidget(
      {Key? key,
      required this.qns,
      required this.enableDraw,
      required this.qid, required this.onDrawOpen})
      : super(key: key);
  final String qns;
  final String qid;
  final bool enableDraw;
  final VoidCallback onDrawOpen;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: kBorderLarge,
      onTap: (){
        if(enableDraw){
          onDrawOpen();
        }
        Get.dialog(
            enableDraw
                ? DrawQnsView(
              question: qns,
              qid: qid,
            )
                :  const DisableDraw(),
            barrierDismissible: false);
      },
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
          child: ResponsiveBuilder(
            builder: (context,_) {
              return Image.asset(
                kIcBrush,
                height:_.isTablet?24 :20.h,
                width:_.isTablet?24 :20.h,
                color: enableDraw ? Colors.black : kErrorRed,
              ).paddingAll(_.isTablet?16:8);
            }
          )),
    );
  }
}
