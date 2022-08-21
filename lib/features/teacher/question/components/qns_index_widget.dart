import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

class QnsIndexWidget extends StatelessWidget {
  final int index;

  const QnsIndexWidget({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      getIndexName(index),
      style: kBody1Style.copyWith(
          color: kcPrimaryColor, fontWeight: FontWeight.w800),
    ).paddingAll(10).card(shape: const CircleBorder(), elevation: 2);
  }
}
