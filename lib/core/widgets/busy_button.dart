import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:educate_me/core/utils/device_utils.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';

class BoxButtonWidget extends StatelessWidget {
  final String buttonText;
  final Color? buttonColor;
  final Color? textColor;
  final VoidCallback onPressed;
  final bool isLoading;
  final double? radius;
  final bool isEnabled;
  final double? fontSize;

  const BoxButtonWidget({
    Key? key,
    required this.buttonText,
    this.buttonColor,
    this.textColor,
    required this.onPressed,
    this.isLoading = false,
    this.radius,
    this.fontSize=14,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context,_) {
        return MaterialButton(
          padding: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          highlightElevation: 0,
          disabledColor: kcButtonDisabled,
          height:_.isTablet?48: 45.h,
          elevation: 0,
          color: isEnabled ? buttonColor ?? kcPrimaryColor : kButtonDisabledColor,
          shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius??30))),
          onPressed: isEnabled
              ? isLoading
                  ? null
                  : () {
                      DeviceUtils.hideKeyboard(context);
                      onPressed();
                    }
              : () {},
          child: AnimatedContainer(
              height: _.isTablet?60:53,
              duration: const Duration(milliseconds: 200),
              child: Center(
                  child: isLoading
                      ? const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(kAltWhite))
                      : AutoSizeText(
                          buttonText,
                          maxLines: 1,
                          style: kBodyStyle.copyWith(
                            fontWeight: FontWeight.w700,
                            color:  isEnabled? textColor?? Colors.white:Colors.white,
                            fontSize:_.isTablet?18: fontSize
                          ),
                        ))),
        );
      }
    );
  }
}
