import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/core/widgets/text_field_widget.dart';
import 'package:educate_me/features/teacher/question/components/add_qn_dialog.dart';
import 'package:educate_me/features/teacher/question/components/add_qn_widget.dart';
import 'package:educate_me/features/teacher/question/qns_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../../../core/utils/device_utils.dart';
import '../../../core/widgets/busy_button.dart';
import 'components/qns_type_selector.dart';

class AddQuestionView extends StatelessWidget {
  final String id;

  const AddQuestionView({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QnsViewModel>.reactive(
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: Scaffold(
          bottomNavigationBar: BoxButtonWidget(
            buttonText: 'Add',
            isLoading: vm.isBusy,
            isEnabled: vm.isMultipleChoice
                ? vm.addedQns.where((e) => e.option?.isEmpty ?? false).isEmpty
                : true,
            onPressed: () => vm.addQuestion(id),
          ).paddingAll(8),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text(
              'Create your question',
            ),
          ),
          body: Form(
            key: vm.formKey,
            child: SingleChildScrollView(
              padding: fieldPadding,
              child: Column(
                children: [
                  vSpaceSmall,
                  const QnsTypeSelector(),
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
                  AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: vm.isMultipleChoice
                          ? const _MultipleQns()
                          : const _AnswerInput()),
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
            onTap: () => Get.bottomSheet(AddQnDialog(
                  onQuestionAdded: (qns) => model.updateQn(qns),
                  question: model.addedQns[index],
                )),
            child: AddQnWidget(model.addedQns[index])),
        itemCount: model.addedQns.length);
  }
}

class _AnswerInput extends ViewModelWidget<QnsViewModel> {
  const _AnswerInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, QnsViewModel model) {
    return AppTextField(
        controller: model.ansTEC,
        hintText: 'Enter the answer',
        borderRadius: kRadiusSmall,
        minLine: 3,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please add an answer';
          }
          return null;
        },
        label: 'Answer');
  }
}
