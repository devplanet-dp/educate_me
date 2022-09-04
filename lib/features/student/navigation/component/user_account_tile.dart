import 'package:auto_size_text/auto_size_text.dart';
import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/core/widgets/avatar_widget.dart';
import 'package:educate_me/data/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

class UserAccountTile extends StatelessWidget {
  const UserAccountTile(
      {Key? key,
      required this.user,
      required this.isSelected})
      : super(key: key);
  final UserModel user;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return [
      AvatarView(path: user.profileUrl ?? '', userName: user.name ?? 'E'),
      hSpaceSmall,
      Expanded(
        child: [
          Text(user.name ?? '',maxLines: 1,style: kCaptionStyle.copyWith(fontWeight: FontWeight.w500),),
          Text(
            'text039'.tr,
            style: kLabelStyle.copyWith(
                color: isSelected ? kcTextGrey : Colors.transparent),
          )
        ].toColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min),
      ),
      hSpaceMedium,
      const Icon(
        Icons.keyboard_arrow_right_sharp,
        color: kcTextGrey,
        size: 24,
      )
    ]
        .toRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center).paddingAll(8)
        .decorated(
            borderRadius: const BorderRadius.all(Radius.circular(56)),
            border:
                Border.all(color: isSelected ? kcPrimaryColor : kcTextGrey.withOpacity(.4)));
  }
}
