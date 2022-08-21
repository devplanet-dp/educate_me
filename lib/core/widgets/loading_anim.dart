import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../core/utils/constants/app_assets.dart';


class LoadingAnim extends StatelessWidget {
  const LoadingAnim({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(kAnimLoading,height: Get.height*.3,width: Get.width*.3);
  }
}
