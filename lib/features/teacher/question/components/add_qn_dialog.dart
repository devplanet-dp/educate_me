import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/core/utils/app_utils.dart';
import 'package:educate_me/core/utils/device_utils.dart';
import 'package:educate_me/core/widgets/busy_button.dart';
import 'package:educate_me/core/widgets/text_field_widget.dart';
import 'package:educate_me/data/question.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

class AddQnDialog extends StatefulWidget {
  final Question question;
  final Function(Question) onQuestionAdded;

  const AddQnDialog(
      {Key? key, required this.question, required this.onQuestionAdded})
      : super(key: key);

  @override
  State<AddQnDialog> createState() => _AddQnDialogState();
}

class _AddQnDialogState extends State<AddQnDialog> {
  bool _isCorrect = false;
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.question.qns.isNotEmpty) {
      controller.text = widget.question.qns;
      _isCorrect = widget.question.isCorrect;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>DeviceUtils.hideKeyboard(context),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: [
            vSpaceSmall,
            Text(
              'Add answer for ${getIndexName(widget.question.index)}',
              style: kBodyStyle.copyWith(
                  color: kcPrimaryColor, fontWeight: FontWeight.bold),
            ),
            vSpaceSmall,
            Divider(
              color: kcPrimaryColor.withOpacity(.2),
            ),
            vSpaceSmall,
            AppTextField(
              controller: controller,
              hintText: 'Type here...',
              label: '',
              minLine: 3,
              borderRadius: kRadiusSmall,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Answer is mandatory';
                }
                return null;
              },
            ),
            vSpaceMedium,
            SwitchListTile(
                title: const Text('Correct answer'),
                value: _isCorrect,
                onChanged: (value) {
                  setState(() {
                    _isCorrect = value;
                  });
                }),
            vSpaceMedium,
            [
              Expanded(
                child: BoxButtonWidget(
                  buttonText: 'Cancel',
                  onPressed: () => Get.back(),
                  buttonColor: kcTextSecondary.withOpacity(.3),
                ),
              ),
              hSpaceSmall,
              Expanded(
                child: BoxButtonWidget(
                    buttonText: 'Done',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        widget.onQuestionAdded(Question(
                            index: widget.question.index,
                            qns: controller.text,
                            isCorrect: _isCorrect));
                        Get.back();
                      }
                    }),
              ),
            ].toRow(),
            vSpaceMedium,
          ]
              .toColumn(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min)
              .paddingAll(16)
              .card(
                  shape: RoundedRectangleBorder(borderRadius: kBorderSmall),
                  color: kAltWhite,
                  elevation: 2),
        ),
      ),
    );
  }
}
