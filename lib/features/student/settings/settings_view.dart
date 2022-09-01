import 'package:educate_me/features/student/settings/settings_view_model.dart';
import 'package:educate_me/features/student/settings/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/utils/device_utils.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.reactive(
      builder: (context, vm, child) => GestureDetector(
        onTap: ()=>DeviceUtils.hideKeyboard(context),
        child: SafeArea(
          child: Scaffold(
            body: Container(),
          ),
        ),
      ),
      viewModelBuilder: () => SettingViewModel(),
    );
  }
}
