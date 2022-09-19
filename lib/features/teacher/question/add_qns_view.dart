import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/core/widgets/text_field_widget.dart';
import 'package:educate_me/data/question.dart';
import 'package:educate_me/features/teacher/question/components/add_qn_dialog.dart';
import 'package:educate_me/features/teacher/question/components/add_qn_widget.dart';
import 'package:educate_me/features/teacher/question/qns_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stacked/stacked.dart';

import '../../../core/utils/device_utils.dart';
import '../../../core/widgets/busy_button.dart';
import 'components/qns_type_selector.dart';

class AddQuestionView extends StatelessWidget {
  final String levelId;
  final String? topicId;
  final String? subTopicId;
  final String? lessonId;
  final QuestionModel? question;
  final bool isStartUp;

  const AddQuestionView(
      {Key? key,
      required this.levelId,
      this.question,
      required this.topicId,
      required this.subTopicId,
      required this.lessonId,
      this.isStartUp = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QnsViewModel>.reactive(
      onModelReady: (model) {
        model.setQuestionData(question);
      },
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: Scaffold(
          bottomNavigationBar: BoxButtonWidget(
            buttonText: question == null ? 'Add' : 'Update',
            isLoading: vm.isBusy,
            isEnabled: vm.isMultipleChoice
                ? vm.addedQns.where((e) => e.option?.isEmpty ?? false).isEmpty
                : true,
            onPressed: () => vm.addQuestion(
                levelId: levelId,
                question: question,
                topicId: topicId,
                subtopicId: subTopicId,
                lessonId: lessonId,
                isStartup: isStartUp),
          ).paddingAll(8),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text(
              'Create your question',
            ),
            actions: [
              question != null
                  ? IconButton(
                      onPressed: () => vm.removeQuestion(
                          levelId: levelId,
                          qId: question!.id,
                          lessonId: lessonId,
                          isStartUp: isStartUp,
                          topicId: topicId,
                          subTopicId: subTopicId),
                      icon: const Icon(
                        Iconsax.trash,
                        color: kErrorRed,
                      ))
                  : emptyBox()
            ],
          ),
          body: Form(
            key: vm.formKey,
            child: SingleChildScrollView(
              padding: fieldPadding,
              child: Column(
                children: [
                  // vSpaceSmall,
                  // const QnsTypeSelector(),
                  vSpaceSmall,
                  AppTextField(
                    controller: vm.qnsTEC,
                    borderRadius: kRadiusSmall,
                    hintText: 'Enter question',
                    label: 'Question',
                    minLine: 3,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Question is mandatory';
                      }
                      return null;
                    },
                  ),
                  vSpaceMedium,
                  const _MultipleQns(),
                  vSpaceMedium,
                  vSpaceMedium,
                ],
              ),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => QnsViewModel(),
    );
  }
}

class _MultipleQns extends ViewModelWidget<QnsViewModel> {
  const _MultipleQns({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, QnsViewModel model) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) => InkWell(
            borderRadius: kBorderSmall,
            onTap: () => Get.bottomSheet(
                AddQnDialog(
                  onQuestionAdded: (qns) => model.updateQn(qns),
                  question: model.addedQns[index],
                ),
                isScrollControlled: true),
            child: AddQnWidget(model.addedQns[index])),
        itemCount: model.addedQns.length);
  }
}

