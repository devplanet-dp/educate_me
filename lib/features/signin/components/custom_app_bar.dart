import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/utils/constants/app_assets.dart';
import 'back_button.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return [
      const CustomBackButton(),
      const Expanded(child: SizedBox()),
      Image.asset(
        kAppLogoOutlined,
        width: 63.h,
        height: 63.h,
      ),
    ].toRow().paddingOnly(top: 12);
  }
}
