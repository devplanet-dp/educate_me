import 'package:auto_size_text/auto_size_text.dart';
import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/features/signup/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/widgets/round_button.dart';

class ChildControllerWidget extends ViewModelWidget<SignUpViewModel> {
  const ChildControllerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, SignUpViewModel model) {
    return ResponsiveBuilder(
      builder: (context,_) {
        return [
          RoundButton(
            bgColor: kcPrimaryColor,
            icon: const Icon(
              Iconsax.minus,
              color: Colors.white,
            ),
            onTap: () => model.decrementChildCount(),
          ),
          AutoSizeText(
            '${model.childCount.length}',
            style: kHeading1Style.copyWith(fontSize: _.isTablet?48:34),
            maxLines: 1,
          ).center().width(_.isTablet?72:64.w),
          RoundButton(
            bgColor: kcPrimaryColor,
            icon: const Icon(
              Iconsax.add,
              color: Colors.white,
            ),
            onTap: () => model.incrementChild(),
          )
        ].toRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center).decorated(color: Colors.white,borderRadius: BorderRadius.circular(60)).center();
      }
    );
  }
}
