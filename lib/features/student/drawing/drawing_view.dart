import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/core/utils/constants/app_assets.dart';
import 'package:educate_me/features/student/drawing/drawing_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../../core/shared/app_colors.dart';
import '../../../core/widgets/busy_button.dart';

class DrawQnsView extends StatelessWidget {
  const DrawQnsView({Key? key, required this.question}) : super(key: key);
  final String question;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DrawingViewModel>.reactive(
      builder: (context, vm, child) =>

          Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              question,
              textAlign: TextAlign.center,
              style: kBodyStyle.copyWith(fontWeight: FontWeight.bold),
            )
                .center()
                .paddingAll(16)
                .card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: kBorderSmall),
                    clipBehavior: Clip.antiAlias)
                .width(Get.width),
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

                SfSignaturePad(
                  key: vm.signatureGlobalKey,
                  strokeColor: vm.selectedStroke ?? vm.strokeColors[0],
                  backgroundColor: Colors.white,
                ),
                const _DrawingController(),
              ],
            ).card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: kBorderSmall),
                clipBehavior: Clip.antiAlias),
          ],
        ),
      ),
      viewModelBuilder: () => DrawingViewModel(),
    );
  }
}

class _DrawingController extends ViewModelWidget<DrawingViewModel> {
  const _DrawingController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, DrawingViewModel model) {
    return [
      IconButton(
          onPressed: () => model.signatureGlobalKey.currentState!.clear(),
          icon: SvgPicture.asset(kIcTrash)),
      _buildColorPallets(model),
      IconButton(onPressed: () {}, icon: SvgPicture.asset(kIcEraser)),
    ].toRow();
  }

  Widget _buildColorPallets(DrawingViewModel model) => Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              model.strokeColors.length,
              (index) => InkWell(
                    borderRadius: kBorderLarge,
                    onTap: () => model.onColorSelected(index),
                    child: Container(
                      height: 28.h,
                      width: 28.w,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: model.strokeColors[index]),
                    ).paddingSymmetric(horizontal: 8),
                  )),
        ),
      );
}

class DisableDraw extends StatelessWidget {
  const DisableDraw({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: kBorderMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            kIcBrush,
            height: 88.h,
            width: 88.h,
          ),
          vSpaceSmall,
          Text(
            'Sorry!',
            style: kHeading3Style.copyWith(fontWeight: FontWeight.w700),
          ),
          vSpaceSmall,
          Text(
            'text092'.tr,
            textAlign: TextAlign.center,
            style: kCaptionStyle.copyWith(color: kcTextGrey),
          ),
          vSpaceSmall,
          BoxButtonWidget(
              buttonText: 'text079'.tr, radius: 8, onPressed: () => Get.back()).paddingSymmetric(horizontal: 48),
          vSpaceSmall
        ],
      ).paddingAll(16),
    );
  }
}
