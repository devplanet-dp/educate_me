import 'package:educate_me/core/utils/textfield_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';

class AppTextField extends StatelessWidget {
  final String? initialValue, prefix, hintText;
  final String label;
  final TextEditingController controller;
  final Color textColor;
  final double margin;
  final Color? fillColor;
  final Color borderColor;
  final int minLine;
  final Widget? suffix, suffixIcon, prefixWidget, prefixIcon;
  final bool isEmail,
      isPhone,
      isEnabled,
      isPassword,
      isMoney,
      isDark,
      isNumber,
      isTextArea;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Function()? onEditingComplete;
  final bool isCapitalize;
  final int maxLength;
  final double verticalPadding;
  final TextInputAction textInputAction;
  final double borderRadius;

  const AppTextField({
    Key? key,
    this.initialValue,
    this.prefix,
    required this.controller,
    this.onTap,
    required this.hintText,
    this.maxLength = 1000,
    this.isEmail = false,
    this.isEnabled = true,
    this.isTextArea = true,
    this.margin = 0,
    this.isPhone = false,
    this.isPassword = false,
    this.isDark = false,
    this.isMoney = false,
    this.isNumber = false,
    this.isCapitalize = false,
    this.textColor = kcTextPrimary,
    this.suffix,
    this.prefixWidget,
    this.prefixIcon,
    this.onChanged,
    this.onEditingComplete,
    this.verticalPadding = 18,
    this.validator,
    this.minLine = 1,
    this.fillColor = kFillColor,
    this.borderColor = kcStroke,
    this.textInputAction = TextInputAction.next,
    this.borderRadius = 8,
    required this.label,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label.isNotEmpty
            ? emptyBox()
            : Text(
                label.tr,
                style: kBody1Style.copyWith(fontWeight: FontWeight.w700),
              ),
        label.isEmpty ? const SizedBox.shrink() : vSpaceSmall,
        TextFormField(
          textAlign: TextAlign.start,
          initialValue: controller == null ? initialValue : null,
          controller: controller,
          obscureText: isPassword,
          enabled: isEnabled,
          validator: validator,
          onChanged: onChanged,
          minLines: minLine,
          textInputAction: textInputAction,
          onTap: onTap,
          enableInteractiveSelection: isEnabled,
          maxLength: maxLength,
          textCapitalization: isCapitalize
              ? TextCapitalization.sentences
              : TextCapitalization.none,
          onEditingComplete: onEditingComplete,
          maxLines: isTextArea && !isPassword
              ? null
              : isPassword
                  ? 1
                  : 3,
          keyboardType: isEmail
              ? TextInputType.emailAddress
              : isPhone
                  ? TextInputType.phone
                  : isMoney
                      ? const TextInputType.numberWithOptions()
                      : TextInputType.multiline,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: isDark ? Colors.black : textColor),
          decoration: InputDecoration(
            hintText: initialValue,
            labelText: hintText,
            labelStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: isDark ? kcTextSecondary : textColor.withOpacity(0.4)),
            counterText: "",
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12, vertical: verticalPadding),
            fillColor: fillColor,
            prefixText: prefix,
            prefix: prefixWidget,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            suffix: suffix,
            errorStyle: TextStyle(
                fontWeight: FontWeight.w200,
                fontSize: 11,
                color: isDark ? kErrorRed : Colors.red),
            hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: isDark ? kcTextSecondary : Colors.black),
            filled: false,
          ),
        ),
      ],
    );
  }
}

class AppTextFieldSecondary extends StatelessWidget {
  final String? initialValue, prefix, hintText;
  final String label;
  final TextEditingController controller;
  final Color textColor;
  final double margin;
  final Color? fillColor;
  final Color borderColor;
  final int minLine;
  final Widget? suffix, suffixIcon, prefixWidget, prefixIcon;
  final bool isEmail,
      isPhone,
      isEnabled,
      isPassword,
      isMoney,
      isDark,
      isNumber,
      isTextArea;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Function()? onEditingComplete;
  final bool isCapitalize;
  final int maxLength;
  final double verticalPadding;
  final TextInputAction textInputAction;
  final double borderRadius;
  final TextAlign align;

  const AppTextFieldSecondary({
    Key? key,
    this.initialValue,
    this.prefix,
    required this.controller,
    this.onTap,
    required this.hintText,
    this.maxLength = 1000,
    this.isEmail = false,
    this.isEnabled = true,
    this.isTextArea = true,
    this.margin = 0,
    this.isPhone = false,
    this.isPassword = false,
    this.isDark = false,
    this.isMoney = false,
    this.isNumber = false,
    this.isCapitalize = false,
    this.align = TextAlign.start,
    this.textColor = kcTextPrimary,
    this.suffix,
    this.prefixWidget,
    this.prefixIcon,
    this.onChanged,
    this.onEditingComplete,
    this.verticalPadding = 4,
    this.validator,
    this.minLine = 1,
    this.fillColor = kFillColor,
    this.borderColor = kcStroke,
    this.textInputAction = TextInputAction.next,
    this.borderRadius = 8,
    required this.label,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context,_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            label.isEmpty
                ? emptyBox()
                : Text(
                    label.tr,
                    style: kBodyStyle.copyWith(fontWeight: FontWeight.w400,fontSize: _.isTablet?18: 14),
                  ),
            label.isEmpty ? const SizedBox.shrink() : vSpaceSmall,
            TextFormField(
              textAlign: align,
              initialValue: controller == null ? initialValue : null,
              controller: controller,
              obscureText: isPassword,
              enabled: isEnabled,
              validator: validator,
              onChanged: onChanged,
              minLines: minLine,
              textInputAction: textInputAction,
              onTap: onTap,
              enableInteractiveSelection: isEnabled,
              maxLength: maxLength,
              textCapitalization: isCapitalize
                  ? TextCapitalization.sentences
                  : TextCapitalization.none,
              onEditingComplete: onEditingComplete,
              maxLines: isTextArea && !isPassword
                  ? null
                  : isPassword
                      ? 1
                      : 3,
              keyboardType: isEmail
                  ? TextInputType.emailAddress
                  : isPhone
                      ? TextInputType.phone
                      : isMoney
                          ? const TextInputType.numberWithOptions()
                          : TextInputType.multiline,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: isDark ? Colors.black : textColor),
              decoration: InputDecoration(
                focusedBorder: DecoratedInputBorder(
                  child: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  shadow: BoxShadow(
                    color: kcTextGrey.withOpacity(.2),
                    blurRadius: 8,
                  ),
                ),
                disabledBorder:DecoratedInputBorder(
                  child: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  shadow: BoxShadow(
                    color: kcTextGrey.withOpacity(.2),
                    blurRadius: 8,
                  ),
                ) ,
                enabledBorder: DecoratedInputBorder(
                  child: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  shadow: BoxShadow(
                    color: kcTextGrey.withOpacity(.2),
                    blurRadius: 8,
                  ),
                ),
                border: DecoratedInputBorder(
                  child: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  shadow:const BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    blurRadius: 8,
                  ),
                ),
                labelText: hintText,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                alignLabelWithHint: false,
                labelStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: kcTextHint),
                counterText: "",
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: _.isTablet?18: verticalPadding),
                fillColor: fillColor,
                prefixText: prefix,
                prefix: prefixWidget,
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                suffix: suffix,
                errorStyle: TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 11,
                    color: isDark ? kErrorRed : Colors.red),
                hintStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: kcTextHint),
                filled: false,
              ),
            )
          ],
        );
      }
    );
  }
}
