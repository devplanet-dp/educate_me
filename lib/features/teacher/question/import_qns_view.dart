import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/core/widgets/text_field_widget.dart';
import 'package:educate_me/features/teacher/question/qns_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../../../core/utils/device_utils.dart';
import '../../../core/widgets/busy_button.dart';

class ImportQnsView extends StatelessWidget {
  final String levelId;
  final String? topicId;
  final String? subTopicId;
  final String? lessonId;
  final bool isStartUp;
  final bool isPractice;

  const ImportQnsView(
      {Key? key,
      required this.levelId,
      required this.topicId,
      required this.subTopicId,
      required this.lessonId,
      this.isPractice = false,
      this.isStartUp = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QnsViewModel>.reactive(
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text(
              'Import question',
            ),
          ),
          body: Form(
            key: vm.formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  vSpaceMedium,
                  AppTextFieldSecondary(
                    controller: vm.importTEC,
                    borderRadius: kRadiusSmall,
                    hintText: 'text086'.tr,
                    label: 'text087'.tr,
                    minLine: 10,
                    onChanged: (value) {
                      vm.notifyListeners();
                    },
                    maxLength: 500000,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This field is mandatory';
                      }
                      return null;
                    },
                  ),
                  vSpaceMedium,
                  BoxButtonWidget(
                    buttonText: 'Import',
                    isLoading: vm.isBusy,
                    isEnabled: vm.importTEC.text.isNotEmpty,
                    onPressed: () => vm.importQnsFromText(
                        levelId: levelId,
                        topicId: topicId,
                        subtopicId: subTopicId,
                        lessonId: lessonId, isPractice: isPractice),
                  ),
                  vSpaceMedium,
                ],
              ).paddingSymmetric(horizontal: 16),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => QnsViewModel(),
    );
  }
}


