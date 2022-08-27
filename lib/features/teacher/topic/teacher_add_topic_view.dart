import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/widgets/image_upload_card.dart';
import 'package:educate_me/features/teacher/topic/teacher_topic_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/shared/ui_helpers.dart';
import '../../../core/widgets/input_sheet.dart';
import '../../../core/widgets/text_field_widget.dart';
import '../../../data/topic.dart';

class TeacherAddTopicView extends StatelessWidget {
  const TeacherAddTopicView({Key? key, required this.levelId, this.topic})
      : super(key: key);
  final String levelId;
  final TopicModel? topic;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TeacherTopicViewModel>.reactive(
      onModelReady: (model){
        if(topic!=null){
          model.setInitDate(topic!);
        }
      },
      builder: (context, vm, child) => InputSheetWidget(
        isBusy: vm.isBusy,
        onCancel: () {},
        onDone: () => vm.addTopic(levelId: levelId,t: topic),
        title: 'Add level',
        child: Form(
          key: vm.formKey,
          child: [
            vSpaceMedium,
            AppTextField(
              controller: vm.orderTEC,
              hintText: 'Topic order',
              label: 'Order',
              maxLength: 3,
              isNumber: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the order';
                }
                return null;
              },
            ),
            vSpaceSmall,
            AppTextField(
              controller: vm.nameTEC,
              hintText: 'Topic name',
              label: 'Name',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the name';
                }
                return null;
              },
            ),
            vSpaceSmall,
            Text('Add cover image',style: kBodyStyle.copyWith(fontWeight: FontWeight.w700),),
            vSpaceSmall,
            ImageUploadCard(
              onBrowseTap: () => vm.selectImage(),
              onClearTap: () => vm.clearImage(),
              images: vm.fileImages,
              uploadImage: vm.uploadedImages,
            ),
            vSpaceSmall,
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
        ),
      ),
      viewModelBuilder: () => TeacherTopicViewModel(),
    );
  }
}
