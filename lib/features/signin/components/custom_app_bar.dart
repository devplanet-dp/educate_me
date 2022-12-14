import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/utils/app_controller.dart';
import 'package:educate_me/core/widgets/avatar_widget.dart';
import 'package:educate_me/features/student/navigation/component/user_account_tile.dart';
import 'package:educate_me/features/student/navigation/navigation_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/shared/shared_styles.dart';
import '../../../core/utils/constants/app_assets.dart';
import '../../signup/create_account_view.dart';
import '../../teacher/home/teacher_home_view_model.dart';
import 'back_button.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key, this.onBack}) : super(key: key);
  final VoidCallback? onBack;
  @override
  Widget build(BuildContext context) {
    return [
       CustomBackButton(onBack: onBack,),
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
  const SwitchUserAppBar(
      {Key? key, required this.title, required this.onUserUpdated})
      : super(key: key);
  final String title;
  final VoidCallback onUserUpdated;

  @override
  Widget build(BuildContext context, NavigationViewModel model) {
    final AppController controller = Get.find<AppController>();
    return ResponsiveBuilder(builder: (context, _) {
      return AppBar(
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(size: _.isTablet ? 32 : 24),
        backgroundColor: Colors.white,
        title: Text(
          title.tr,
          style: kSubheadingStyle.copyWith(
              fontWeight: FontWeight.bold, fontSize: _.isTablet ? 32 : 20),
        ),
        actions: [
          Obx(() => PopupMenuButton(
                offset: const Offset(0, 60),
                onCanceled: () {
                  controller.popupMenuEnabled.value = false;
                },
                onSelected: (value) {
                  controller.popupMenuEnabled.value = false;
                  //on add account clicked
                  if (value == 0) {
                    Get.to(() => const CreateAccountView(
                          isAddAccount: true,
                        ));
                  }
                },
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                itemBuilder: (context) {
                  controller.popupMenuEnabled.value = true;
                  return [
                    PopupMenuItem(
                        child: Text(
                      'text026'.tr,
                      style: kBodyStyle.copyWith(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    )),
                    ..._buildPopTiles(model),
                    const PopupMenuItem(
                      value: 0,
                      child: AddAccount(),
                    ),
                  ];
                },
                child: AnimatedContainer(
                  duration: const Duration(microseconds: 300),
                  child: AvatarView(
                          path: model.controller.currentChild?.profileUrl ?? '',
                          height:_.isTablet?34: 34.h,
                          widget:_.isTablet?34: 34.w,
                          userName: model.controller.currentChild?.name ?? 'E')
                      .paddingAll(4)
                      .decorated(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: controller.popupMenuEnabled.value
                                  ? kcPrimaryColor
                                  : Colors.transparent))
                      .paddingAll(8),
                ),
              )),
        ],
      ).decorated(
        color: Colors.white,
        borderRadius: kBorderSmall,
        boxShadow: [
          const BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 9,
            offset: Offset(0, 1), // Shadow position
          ),
        ],
      );
    });
  }

  List<PopupMenuItem> _buildPopTiles(NavigationViewModel model) {
    return List.generate(model.controller.appChild.length, (index) {
      var c = model.controller.appChild[index];
      return PopupMenuItem(
          onTap: () {
            model.onSwitchProfile(c);
            onUserUpdated();
            model.controller.update();
          },
          child: UserAccountTile(
            user: c,
            isBusy: model.isBusy,
          ).paddingSymmetric(vertical: 8));
    });
  }
}

class AdminAppBar extends StatelessWidget {
  const AdminAppBar({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TeacherViewModel>.reactive(
      builder: (context, vm, child) => ResponsiveBuilder(builder: (context, _) {
        return AppBar(
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(size: _.isTablet ? 32 : 24),
          backgroundColor: Colors.white,
          title: Text(
            title.tr,
            style: kSubheadingStyle.copyWith(
                fontWeight: FontWeight.bold, fontSize: _.isTablet ? 32 : 20),
          ),
          actions: [
            PopupMenuButton(
                child: AvatarView(
                        path: '', height: 34.h, widget: 34.w, userName: 'Admin')
                    .paddingAll(4)
                    .decorated(
                      shape: BoxShape.circle,
                    ),
                itemBuilder: (_) => [
                      PopupMenuItem(
                        child: const Text('Sign out'),
                        onTap: () => vm.signOut(),
                      )
                    ])
          ],
        ).decorated(
          color: Colors.white,
          borderRadius: kBorderSmall,
          boxShadow: [
            const BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 9,
              offset: Offset(0, 1), // Shadow position
            ),
          ],
        );
      }),
      viewModelBuilder: () => TeacherViewModel(),
    );
  }
}
