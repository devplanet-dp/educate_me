import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/core/utils/constants/app_assets.dart';
import 'package:educate_me/features/student/language/lan_change_view.dart';
import 'package:educate_me/features/student/settings/components/category_tile_widget.dart';
import 'package:educate_me/features/student/settings/settings_view_model.dart';
import 'package:educate_me/features/student/support/support_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../../../core/shared/shared_styles.dart';
import '../../../core/utils/device_utils.dart';
import '../../signin/components/custom_app_bar.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.reactive(
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: SwitchUserAppBar(
                title: 'text025'.tr,
                onUserUpdated:()=>vm.notifyListeners(),
              ),
            ),
            body: SingleChildScrollView(
              padding: fieldPadding,
              child: Column(
                children: [
                  vSpaceMedium,
                  CategoryTileWidget(
                      icon: kIcAccount,
                      backgroundColor: Colors.blue,
                      title: 'text046',
                      onTap: () {}),
                  const Divider(
                    color: kcTextGrey,
                  ),
                  CategoryTileWidget(
                      icon: kIcLang,
                      backgroundColor: Colors.orange,
                      title: 'text047',
                      onTap: () =>Get.to(()=>const LanChangeView())),
                  const Divider(
                    color: kcTextGrey,
                  ),
                  CategoryTileWidget(
                      icon: kIcHelp,
                      backgroundColor: Colors.green,
                      title: 'text048',
                      onTap: () =>Get.to(()=>const SupportView())),
                  const Divider(
                    color: kcTextGrey,
                  ),
                  CategoryTileWidget(
                      icon: kIcCredit,
                      backgroundColor: Colors.blue,
                      title: 'text049',
                      onTap: () {}),
                  const Divider(
                    color: kcTextGrey,
                  ),
                  CategoryTileWidget(
                      icon: kIcAcce,
                      backgroundColor: const Color(0xFF0979FE),
                      title: 'text050',
                      onTap: () {}),
                  const Divider(
                    color: kcTextGrey,
                  ),
                  CategoryTileWidget(
                      icon: kIcAbout,
                      backgroundColor: const Color(0xFF6C68FF),
                      title: 'text051',
                      onTap: () {}),
                  const Divider(
                    color: kcTextGrey,
                  ),
                  CategoryTileWidget(
                      icon: kIcLogout,
                      backgroundColor: const Color(0xFF0479FA),
                      title: 'text052',
                      onTap: () =>vm.signOut()),
                  const Divider(
                    color: kcTextGrey,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => SettingViewModel(),
    );
  }
}
