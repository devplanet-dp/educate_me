import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/features/student/drawing/drawing_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:signature/signature.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class DrawQnsView extends StatelessWidget {
  const DrawQnsView({Key? key, required this.question}) : super(key: key);
  final String question;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DrawingViewModel>.reactive(
      builder: (context, vm, child) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            question,
            style: kBodyStyle.copyWith(fontWeight: FontWeight.bold),
          ).paddingAll(8).card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: kBorderSmall),
              clipBehavior: Clip.antiAlias),
          vSpaceMedium,
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Iconsax.close_circle),
                ),
              ),
              Signature(
                controller: vm.signatureController,
                width: Get.width,
                height: 300.h,
                backgroundColor: Colors.white,
              )
            ],
          ).card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: kBorderSmall),
              clipBehavior: Clip.antiAlias),
        ],
      ),
      viewModelBuilder: () => DrawingViewModel(),
    );
  }
}
