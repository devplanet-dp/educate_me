import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/features/student/stats/stat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../../../core/utils/device_utils.dart';

class StatView extends StatelessWidget {
  const StatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StatViewModel>.reactive(
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.transparent,
              title: Text(
                'text023'.tr,
                style: kSubheadingStyle.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            body: Container(),
          ),
        ),
      ),
      viewModelBuilder: () => StatViewModel(),
    );
  }
}
