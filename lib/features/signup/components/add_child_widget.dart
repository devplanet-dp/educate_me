import 'package:educate_me/core/widgets/text_field_widget.dart';
import 'package:educate_me/features/signup/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class AddChildWidget extends ViewModelWidget<SignUpViewModel> {
  const AddChildWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, SignUpViewModel model) {
    return Form(
      key: model.formKey,
      child: Column(
        children: List.generate(
            model.childCount.length, (index) => _inputFields(model, index)),
      ),
    );
  }

  Widget _inputFields(SignUpViewModel model, int index) =>
      Builder(builder: (context) {
        var controller = model.childCount[index];
        return [
          AppTextField(
            controller: controller.nameTEC,
            hintText: 'User #${index + 1}\'s name',
            label: '',
            validator: (value) {
              if (value!.isEmpty) {
                return 'User #${index + 1}\'s name';
              }
              return null;
            },
          ),
          AppTextField(
              controller: controller.ageTEC,
              hintText: 'User #${index + 1}\'s age',
              isNumber: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'User #${index + 1}\'s age';
                }
                return null;
              },
              label: ''),
        ].toColumn();
      });
}
