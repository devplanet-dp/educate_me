import 'package:educate_me/data/sub_topic.dart';
import 'package:educate_me/features/teacher/sub-topic/teacher_sub_topic_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/shared/shared_styles.dart';
import '../../../core/shared/ui_helpers.dart';
import '../../../core/widgets/image_upload_card.dart';
import '../../../core/widgets/input_sheet.dart';
import '../../../core/widgets/text_field_widget.dart';

class TeacherAddSubTopicView extends StatelessWidget {
  const TeacherAddSubTopicView(
      {Key? key, required this.levelId, required this.topicId, this.topic})
      : super(key: key);
  final String levelId;
  final String topicId;
  final SubTopicModel? topic;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TeacherSubTopicViewModel>.reactive(
      onModelReady: (model){
        if(topic!=null){
          model.setInitDate(topic!);
        }
      },
      builder: (context, vm, child) => InputSheetWidget(
        isBusy: vm.isBusy,
        onCancel: () {},
        onDone: () => vm.addSubTopic(levelId: levelId, topicId: topicId,t: topic),
        title: 'Add sub-topic',
        child: Form(
          key: vm.formKey,
          child: [
            vSpaceMedium,
            AppTextField(
              controller: vm.orderTEC,
              hintText: 'Sub Topic order',
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
              hintText: 'Sub Topic name',
              label: 'Name',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the name';
                }
                return null;
              },
            ),
            vSpaceSmall,
            AppTextField(
              controller: vm.descTEC,
              hintText: 'Sub Topic description',
              label: 'Description',
              minLine: 3,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the description';
                }
                return null;
              },
            ),
            vSpaceSmall,
            Text(
              'Add cover image',
              style: kBodyStyle.copyWith(fontWeight: FontWeight.w700),
            ),
            vSpaceSmall,
            ImageUploadCard(
              onBrowseTap: () => vm.selectImage(),
              onClearTap: () => vm.clearImage(),
              images: vm.fileImages,
            ),
            vSpaceSmall,
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
        ),
      ),
      viewModelBuilder: () => TeacherSubTopicViewModel(),
    );
  }
}
