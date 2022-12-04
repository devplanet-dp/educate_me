import 'package:educate_me/core/widgets/text_field_widget.dart';
import 'package:educate_me/features/signup/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/widgets/busy_button.dart';
import '../../../core/widgets/busy_button.dart';

class AddChildWidget extends ViewModelWidget<SignUpViewModel> {
  const AddChildWidget({Key? key,this.isAddAccount=false}) : super(key: key);
  final bool isAddAccount;

  @override
  Widget build(BuildContext context, SignUpViewModel model) {
    return ResponsiveBuilder(
      builder: (context,_) {
        return Form(
          key: model.formKey,
          child: Column(
            children: List.generate(
                model.childCount.length, (index) => _inputFields(model, index))..add(BoxButtonWidget(
              buttonText: isAddAccount?'text016.2'.tr :'text016'.tr,
              isLoading: model.isBusy,
              fontSize: _.isTablet?32:24,
              onPressed: () =>model.addUsers(),
            ).paddingSymmetric(vertical: _.isTablet?Get.width*.1: 12,horizontal: _.isTablet?Get.width*.1:0)),
          ),
        );
      }
    );
  }

  Widget _inputFields(SignUpViewModel model, int index) =>
      Builder(builder: (context) {
        var controller = model.childCount[index];
        return [
          AppTextField(
            controller: controller.nameTEC,
            hintText: '${isAddAccount?'Profile':'User'} #${index + 1}\'s name',
            label: '',
            validator: (value) {
              if (value!.isEmpty) {
                return '${isAddAccount?'Profile':'User'} #${index + 1}\'s name';
              }
              return null;
            },
          ),
          AppTextField(
              controller: controller.ageTEC,
              hintText: '${isAddAccount?'Profile':'User'} #${index + 1}\'s age',
              isNumber: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return '${isAddAccount?'Profile':'User'} #${index + 1}\'s age';
                }
                return null;
              },
              label: ''),
        ].toColumn();
      });
}
