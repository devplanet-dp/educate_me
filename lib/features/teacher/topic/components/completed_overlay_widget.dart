import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/constants/app_assets.dart';

class CompletedOverlayWidget extends StatelessWidget {
  const CompletedOverlayWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Image.asset(
        kImgCompleted,
        height: 42.h,
        width: 180.w,
      ),
    );
  }
}
