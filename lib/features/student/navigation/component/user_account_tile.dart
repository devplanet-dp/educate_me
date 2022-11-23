import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/core/utils/app_controller.dart';
import 'package:educate_me/core/widgets/avatar_widget.dart';
import 'package:educate_me/data/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

class UserAccountTile extends GetView<AppController> {
  const UserAccountTile(
      {Key? key,
      required this.user,
      required this.isBusy})
      : super(key: key);
  final UserModel user;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final selected = controller.currentChild?.userId == user.userId;
    return [
      AvatarView(
        path: user.profileUrl ?? '',
        userName: user.name ?? 'E',
        height: 32.h,
        widget: 32.w,
      ),
      hSpaceSmall,
      Expanded(
        child: [
          Text(
            user.name ?? '',
            maxLines: 1,
            style: kCaptionStyle.copyWith(fontWeight: FontWeight.w500),
          ),
          Text(
            'text039'.tr,
            style: kLabelStyle.copyWith(
                color: selected ? kcTextGrey : Colors.transparent,fontWeight: FontWeight.w300,fontStyle: FontStyle.italic),
          )
        ].toColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min),
      ),
      hSpaceMedium,
      isBusy
          ? const SizedBox(
              height: 24, width: 24, child: CupertinoActivityIndicator())
          : const Icon(
              Icons.keyboard_arrow_right_sharp,
              color: kcTextGrey,
              size: 24,
            )
    ]
        .toRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center)
        .paddingAll(8)
        .decorated(
            borderRadius: const BorderRadius.all(Radius.circular(56)),
            border: Border.all(
                color:
                selected ? kcPrimaryColor : kcTextGrey.withOpacity(.4)));
  }
}

class AddAccount extends StatelessWidget {
  const AddAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return [
      const Icon(
        Icons.add,
        color: Colors.black,
      ).decorated(
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(0.1),
      ).height(32).width(32),
      hSpaceSmall,
      Expanded(
        child: Text(
          'text103'.tr,
          maxLines: 1,
          style: kCaptionStyle.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    ]
        .toRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center)
        .paddingAll(8);
  }
}
