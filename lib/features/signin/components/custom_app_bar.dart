import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/widgets/avatar_widget.dart';
import 'package:educate_me/features/student/navigation/component/user_account_tile.dart';
import 'package:educate_me/features/student/navigation/navigation_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/shared/shared_styles.dart';
import '../../../core/utils/constants/app_assets.dart';
import 'back_button.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return [
      const CustomBackButton(),
      const Expanded(child: SizedBox()),
      Image.asset(
        kAppLogoOutlined,
        width: 48.h,
        height: 48.h,
      ),
    ].toRow().paddingOnly(top: 12);
  }
}

class SwitchUserAppBar extends ViewModelWidget<NavigationViewModel> {
  const SwitchUserAppBar({Key? key, required this.title,required this.onUserUpdated}) : super(key: key);
  final String title;
  final VoidCallback onUserUpdated;

  @override
  Widget build(BuildContext context, NavigationViewModel model) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      title: Text(
        title.tr,
        style: kSubheadingStyle.copyWith(fontWeight: FontWeight.bold),
      ),
      actions: [
        PopupMenuButton(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          itemBuilder: (context) =>
          [
            PopupMenuItem(child: Text('text026'.tr, style: kBodyStyle.copyWith(
                color: Colors.black, fontWeight: FontWeight.w700),)),
            ..._buildPopTiles(model)
          ]
          ,
          child: AvatarView(
              path: model.controller.currentChild?.profileUrl ?? '',
              userName: model.controller.currentChild?.name ?? 'E')
              .paddingAll(8),
        ),
      ],
    ).decorated(
      color: Colors.white,
      borderRadius: kBorderSmall,
      boxShadow: [
        const BoxShadow(
          color: Color.fromRGBO(0,0, 0, 0.05),
          blurRadius: 9,
          offset: Offset(0, 1), // Shadow position
        ),
      ],
    );
  }

  List<PopupMenuItem> _buildPopTiles(NavigationViewModel model) {
    return List.generate(model.controller.appChild.length, (index) {
      var c = model.controller.appChild[index];
      return PopupMenuItem(
        onTap: (){
          model.onSwitchProfile(c);
          onUserUpdated();
          model.controller.update();
        },
          child: UserAccountTile(
            isSelected: c == model.controller.currentChild,
            user: c,
            isBusy: model.isBusy,
          ).paddingSymmetric(vertical: 8));
    });
  }

}
