import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/constants/app_assets.dart';

class AppLogoWidget extends StatelessWidget {
  final double radius;
  final double elevation;

  const AppLogoWidget({Key? key, this.radius = 4, this.elevation = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      kAppLogo,
      width: 95.05.w,
      height: 87.01.h,
    );
  }
}
