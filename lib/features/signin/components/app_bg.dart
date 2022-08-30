import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBgWidget extends StatelessWidget {
  const AppBgWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: Stack(
        children: [

        ],
      ),
    );
  }
}
