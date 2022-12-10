import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
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
  final bool singleSelection;

  const AppDialog({
    Key? key,
    required this.title,
    required this.image,
    this.onNegativeTap,
    this.onPositiveTap,
    this.singleSelection=false,
    this.subtitle,
    this.positiveText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, _) {
      return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(_.isTablet ? kTabPaddingHorizontal : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            vSpaceSmall,
            _buildDialogContent(),
            vSpaceMedium,
            _buildDialogController(),
          ],
        ).paddingSymmetric(horizontal: 24, vertical: 24).card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: _.isTablet ? kBorderLarge : kBorderSmall,
            ),
            elevation: 4),
      );
    });
  }

  Widget _buildDialogController() {
    return singleSelection? BoxButtonWidget(
        buttonText: positiveText ?? '',
        radius: 8,
        onPressed: onPositiveTap ?? () => Get.back())
        .paddingSymmetric(horizontal: Get.width * .2):[
      Expanded(
        child: BoxButtonWidget(
            buttonText: 'text043'.tr,
            radius: 8,
            fontSize: 16,
            buttonColor: kButtonDisabledColor,
            textColor: kcTextDarkGrey,
            onPressed: onNegativeTap ?? () => Get.back()),
      ),
      hSpaceSmall,
      Expanded(
        child: BoxButtonWidget(
            buttonText: positiveText ?? 'text044'.tr,
            radius: 8,
            fontSize: 16,
            onPressed: onPositiveTap ?? () => Get.back()),
      ),
    ].toRow();
  }

  Widget _buildHeader() {
    return image.split('.')[1].contains('svg')
        ? SvgPicture.asset(image)
        : ResponsiveBuilder(builder: (context, _) {
            return Image.asset(
              image,
              fit: BoxFit.contain,
              height: _.isTablet ? 120.h : 148.h,
              width: _.isTablet ? 120.w : 148.w,
            );
          });
  }

  _buildDialogContent() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ResponsiveBuilder(builder: (context, _) {
            return Text(
              title,
              textAlign: TextAlign.center,
              style: subtitle == null
                  ? kBody1Style.copyWith(fontWeight: FontWeight.bold)
                  : kSubheadingStyle.copyWith(
                      fontSize: _.isTablet ? 12.sp : 25.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
            ).paddingAll(12);
          }),
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
  final Widget? secondaryActionWidget;

  const AppDialogWithInput({
    Key? key,
    required this.title,
    required this.image,
    this.onNegativeTap,
    this.onPositiveTap,
    this.subtitle,
    this.secondaryActionWidget,
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
    return ResponsiveBuilder(builder: (context, _) {
      return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(_.isTablet ? kTabPaddingHorizontal : 16),
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
            widget.secondaryActionWidget ?? emptyBox(),
            vSpaceMedium,
            _buildDialogController(),
            vSpaceMedium,
          ],
        ).paddingSymmetric(horizontal: 12).card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: _.isTablet ? kBorderLarge : kBorderSmall,
            ),
            elevation: 4),
      );
    });
  }

  Widget _buildDialogController() {
    return [
      Expanded(
        child: BoxButtonWidget(
            buttonText: 'text043'.tr,
            radius: 8,
            fontSize: 16,
            buttonColor: kButtonDisabledColor,
            textColor: kcTextDarkGrey,
            onPressed: widget.onNegativeTap ?? () => Get.back()),
      ),
      hSpaceSmall,
      Expanded(
        child: BoxButtonWidget(
            buttonText: 'text079'.tr,
            radius: 8,
            fontSize: 16,
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

  _buildDialogContent() => ResponsiveBuilder(builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: widget.subtitle == null
                  ? kBody1Style.copyWith(fontWeight: FontWeight.bold)
                  : kSubheadingStyle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: _.isTablet ? 15.sp : 25.sp),
            ),
            widget.subtitle != null
                ? Text(
                    widget.subtitle!,
                    textAlign: TextAlign.center,
                    style: kBody1Style.copyWith(
                        fontWeight: FontWeight.w500,
                        color: kcTextGrey,
                        fontSize: _.isTablet ? 8.sp : 12.sp),
                  )
                : emptyBox()
          ],
        ).paddingSymmetric(horizontal: 16);
      });

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

class AppDialogSingle extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? content;
  final String? image;
  final VoidCallback? onPositiveTap;
  final String? positiveText;

  const AppDialogSingle({
    Key? key,
    required this.title,
    required this.content,
    this.onPositiveTap,
    required this.subtitle,
    this.positiveText,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, _) {
      return Dialog(
        elevation: 0,
        insetPadding: EdgeInsets.all(_.isTablet ? kTabPaddingHorizontal : 16),
        backgroundColor: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            vSpaceSmall,
            _buildSubtitle(),
            vSpaceSmall,
            _buildDialogContent(),
            vSpaceMedium,
            _buildDialogController(),
          ],
        ).paddingSymmetric(horizontal: 12, vertical: 18).card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: _.isTablet ? kBorderLarge : kBorderSmall,
            ),
            elevation: 4),
      );
    });
  }

  Widget _buildDialogController() {
    return BoxButtonWidget(
            buttonText: positiveText ?? '',
            radius: 8,
            onPressed: onPositiveTap ?? () => Get.back())
        .paddingSymmetric(horizontal: Get.width * .2);
  }

  Widget _buildHeader() => ResponsiveBuilder(builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: kBodyStyle.copyWith(
                  fontSize: _.isTablet ? 12.sp : 25.sp,
                  fontWeight: FontWeight.w600),
            ),
            image == null
                ? const SizedBox.shrink()
                : Image.asset(
                    image!,
                    fit: BoxFit.fill,
                    height: _.isTablet ? 120.h : 148.h,
                    width: _.isTablet ? 120.w : 148.w,
                  )
          ],
        );
      });

  Widget _buildSubtitle() => ResponsiveBuilder(builder: (context, _) {
        return Text(
          subtitle,
          textAlign: TextAlign.center,
          style: kBodyStyle.copyWith(
              fontSize: _.isTablet ? 12.sp : 16.sp,
              fontWeight: FontWeight.w400),
        ).paddingAll(8).decorated(
          color: Colors.white,
          borderRadius: kBorderSmall,
          boxShadow: [
            const BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.08),
              blurRadius: 9,
              offset: Offset(0, 1), // Shadow position
            ),
          ],
        );
      });

  _buildDialogContent() => ResponsiveBuilder(builder: (context, _) {
        return Text(
          content ?? '',
          textAlign: TextAlign.center,
          style: kCaptionStyle.copyWith(
              color: kcTextGrey, fontSize: _.isTablet ? 8.sp : 13.5.sp),
        );
      });
}
