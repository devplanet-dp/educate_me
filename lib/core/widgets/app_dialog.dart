import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/shared/ui_helpers.dart';
import '../shared/shared_styles.dart';
import 'busy_button.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String image;
  final VoidCallback? onNegativeTap;
  final VoidCallback? onPositiveTap;
  final String? positiveText;

  const AppDialog({
    Key? key,
    required this.title,
    required this.image,
    this.onNegativeTap,
    this.onPositiveTap,
    this.subtitle,
    this.positiveText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          vSpaceMedium,
          _buildHeader(),
          vSpaceMedium,
          _buildDialogContent(),
          vSpaceMedium,
          _buildDialogController(),
          vSpaceMedium,
        ],
      ).paddingSymmetric(horizontal: 12).card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: kBorderSmall,
          ),
          elevation: 4),
    );
  }

  Widget _buildDialogController() {
    return [
      Expanded(
        child: BoxButtonWidget(
            buttonText: 'text043'.tr,
            radius: 8,
            buttonColor: kButtonDisabledColor,
            textColor: kcTextDarkGrey,
            onPressed: onNegativeTap ?? () => Get.back()),
      ),
      hSpaceSmall,
      Expanded(
        child: BoxButtonWidget(
            buttonText: positiveText ?? 'text044'.tr,
            radius: 8,
            onPressed: onPositiveTap ?? () => Get.back()),
      ),
    ].toRow();
  }

  Widget _buildHeader() {
    return image.split('.')[1].contains('svg')
        ? SvgPicture.asset(image)
        : Image.asset(
            image,
            height: 105.h,
            width: 71.w,
          );
  }

  _buildDialogContent() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: subtitle == null
                ? kBody1Style.copyWith(fontWeight: FontWeight.bold)
                : kSubheadingStyle.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.black),
          ),
          subtitle != null
              ? Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: kBody1Style.copyWith(
                      fontWeight: FontWeight.bold, color: kcTextGrey),
                )
              : emptyBox()
        ],
      );
}

class AppDialogWithInput extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String image;
  final VoidCallback? onNegativeTap;
  final Function(String)? onPositiveTap;

  const AppDialogWithInput({
    Key? key,
    required this.title,
    required this.image,
    this.onNegativeTap,
    this.onPositiveTap,
    this.subtitle,
  }) : super(key: key);

  @override
  State<AppDialogWithInput> createState() => _AppDialogWithInputState();
}

class _AppDialogWithInputState extends State<AppDialogWithInput> {
  late TextEditingController controller;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          vSpaceMedium,
          _buildHeader(),
          vSpaceSmall,
          _buildDialogContent(),
          vSpaceMedium,
          _buildDialogInput(),
          vSpaceMedium,
          _buildDialogController(),
          vSpaceMedium,
        ],
      ).paddingSymmetric(horizontal: 12).card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: kBorderSmall,
          ),
          elevation: 4),
    );
  }

  Widget _buildDialogController() {
    return [
      Expanded(
        child: BoxButtonWidget(
            buttonText: 'text043'.tr,
            radius: 8,
            buttonColor: kButtonDisabledColor,
            textColor: kcTextDarkGrey,
            onPressed: widget.onNegativeTap ?? () => Get.back()),
      ),
      hSpaceSmall,
      Expanded(
        child: BoxButtonWidget(
            buttonText: 'text079'.tr,
            radius: 8,
            onPressed: () {
              if (formKey.currentState!.validate()) {
                if (widget.onPositiveTap != null) {
                  widget.onPositiveTap!(controller.text);
                  return Get.back();
                }
                return Get.back();
              }
            }),
      ),
    ].toRow();
  }

  Widget _buildHeader() {
    return widget.image.split('.')[1].contains('svg')
        ? SvgPicture.asset(widget.image)
        : Image.asset(
            widget.image,
            height: 105.h,
            width: 71.w,
          );
  }

  _buildDialogContent() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: widget.subtitle == null
                ? kBody1Style.copyWith(fontWeight: FontWeight.bold)
                : kSubheadingStyle.copyWith(
                    fontWeight: FontWeight.w600, color: Colors.black,fontSize: 25.sp),
          ),
          widget.subtitle != null
              ? Text(
                  widget.subtitle!,
                  textAlign: TextAlign.center,
                  style: kBody1Style.copyWith(
                      fontWeight: FontWeight.w500, color: kcTextGrey,fontSize: 12.sp),
                )
              : emptyBox()
        ],
      ).paddingSymmetric(horizontal: 16);

  _buildDialogInput() => Form(
    key: formKey,
    child: AppTextFieldSecondary(
        controller: controller,
        hintText: '',
        fillColor: Colors.white,
        isPassword: true,
        validator: (value) {
          if (value!.isEmpty) {
            return 'text080'.tr;
          }
          return null;
        },
        label: ''),
  );
}
