import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/shared/app_colors.dart';

class LockedOverlayWidget extends StatelessWidget {
  const LockedOverlayWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: Container(
      color: Colors.black54.withOpacity(.5),
      child: Icon(
        Iconsax.lock,
        color: kcPrimaryColor,
        size: 32.h,
      ),
    ));
  }
}
