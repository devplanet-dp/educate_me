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
  final double? height;
  final double? width;
  final double contentPaddingTop;
  const AppDialog({
    Key? key,
    required this.title,
    required this.image,
    this.onNegativeTap,
    this.onPositiveTap,
    this.singleSelection = false,
    this.subtitle,
    this.positiveText,
    this.height,
    this.width, this.contentPaddingTop=0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, _) {
      return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: _.isTablet ? 350 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            vSpaceTiny,
            _buildDialogContent(),
            vSpaceMedium,
            _buildDialogController(),
          ],
        ).paddingSymmetric(horizontal: 24, vertical: 16).card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: _.isTablet ? kBorderLarge : kBorderSmall,
            ),
            elevation: 4),
      );
    });
  }

  Widget _buildDialogController() {
    return singleSelection
        ? ResponsiveBuilder(builder: (context, _) {
            return BoxButtonWidget(
                    buttonText: positiveText ?? '',
                    radius: _.isTablet ? 18 : 8,
                    onPressed: onPositiveTap ?? () => Get.back())
                .paddingSymmetric(
                    horizontal: _.isTablet ? Get.width * 0.08 : Get.width * .2);
          })
        : [
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
        ? ResponsiveBuilder(builder: (context, _) {
            return SvgPicture.asset(
              image,
              height: _.isTablet ? 160 : height ?? 148.h,
              width: _.isTablet ? 160 : width ?? 148.w,
            );
          })
        : ResponsiveBuilder(builder: (context, _) {
            return Image.asset(
              image,
              fit: BoxFit.contain,
              height: _.isTablet ? 200 : 148.h,
              width: _.isTablet ? 250 : 148.w,
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
                  ? kBody1Style.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: _.isTablet ? 24 : 16)
                  : kSubheadingStyle.copyWith(
                      fontSize: _.isTablet ? 10.sp : 25.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
            );
          }),
          subtitle != null
              ? Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: kBody1Style.copyWith(
                      fontWeight: FontWeight.w600, color: kcTextGrey),
                )
              : emptyBox()
        ],
      ).paddingOnly(top: contentPaddingTop);
}

class AppDialogWithInput extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String image;
  final VoidCallback? onNegativeTap;
  final Function(String)? onPositiveTap;
  final Widget? secondaryActionWidget;
  final bool isFailed;

  const AppDialogWithInput({
    Key? key,
    required this.title,
    required this.image,
    this.onNegativeTap,
    this.onPositiveTap,
    this.subtitle,
    this.secondaryActionWidget,
    required this.isFailed,
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
        insetPadding: EdgeInsets.symmetric(horizontal: _.isTablet ? 350 : 16),
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
        ).paddingSymmetric(horizontal: _.isTablet ? 32 : 12).card(
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
                }
              }
            }),
      ),
    ].toRow();
  }

  Widget _buildHeader() {
    return widget.image.split('.')[1].contains('svg')
        ? ResponsiveBuilder(builder: (context, _) {
            return SvgPicture.asset(
              widget.image,
              height: _.isTablet ? 185 : 105.h,
              width: _.isTablet ? 180 : 71.w,
            );
          })
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
                  ? kBody1Style.copyWith(fontWeight: FontWeight.w600)
                  : kSubheadingStyle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: _.isTablet ? 32 : 25.sp),
            ),
            widget.subtitle != null
                ? Text(
                    widget.subtitle!,
                    textAlign: TextAlign.center,
                    style: kBody1Style.copyWith(
                        fontWeight: FontWeight.w500,
                        color: widget.isFailed ? kcIncorrectAns : kcTextGrey,
                        fontSize: _.isTablet ? 18 : 12.sp),
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
        insetPadding: EdgeInsets.symmetric(horizontal: _.isTablet ? 400 : 16),
        backgroundColor: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            vSpaceSmall,
            _buildHeader(),
            vSpaceSmall,
            _buildSubtitle(),
            vSpaceMedium,
            _buildDialogContent(),
            vSpaceMedium,
            _buildDialogController(_.isTablet),
            vSpaceSmall,
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

  Widget _buildDialogController(bool isTab) {
    return BoxButtonWidget(
            buttonText: positiveText ?? '',
            radius: isTab ? 16 : 8,
            onPressed: onPositiveTap ?? () => Get.back())
        .paddingSymmetric(horizontal: isTab ? 72 : 24);
  }

  Widget _buildHeader() => ResponsiveBuilder(builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: kBodyStyle.copyWith(
                  fontSize: _.isTablet ? 38 : 25.sp,
                  fontWeight: FontWeight.w600),
            ),
            image == null
                ? const SizedBox.shrink()
                : Image.asset(
                    image!,
                    fit: BoxFit.fill,
                    height: _.isTablet ? 120 : 148.h,
                    width: _.isTablet ? 120 : 148.w,
                  )
          ],
        );
      });

  Widget _buildSubtitle() => ResponsiveBuilder(builder: (context, _) {
        return Text(
          subtitle,
          textAlign: TextAlign.center,
          style: kBodyStyle.copyWith(
              fontSize: _.isTablet ? 24 : 16.sp, fontWeight: FontWeight.w400),
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
              color: kcTextGrey, fontSize: _.isTablet ? 6.sp : 13.5.sp),
        ).paddingSymmetric(horizontal: 16);
      });
}
