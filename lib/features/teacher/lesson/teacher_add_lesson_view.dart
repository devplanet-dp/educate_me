import 'package:educate_me/data/lesson.dart';
import 'package:educate_me/features/teacher/lesson/components/lesson_html_content.dart';
import 'package:educate_me/features/teacher/lesson/teacher_lesson_view_model.dart';
import 'package:educate_me/features/teacher/question/import_qns_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/shared/shared_styles.dart';
import '../../../core/shared/ui_helpers.dart';
import '../../../core/widgets/image_upload_card.dart';
import '../../../core/widgets/input_sheet.dart';
import '../../../core/widgets/text_field_widget.dart';

class TeacherAddLessonView extends StatelessWidget {
  const TeacherAddLessonView(
      {Key? key,
      required this.levelId,
      required this.topicId,
      required this.subTopicId,
      this.lesson,  this.isFromStatsView=false})
      : super(key: key);
  final String levelId;
  final String topicId;
  final String subTopicId;
  final LessonModel? lesson;
  final bool isFromStatsView;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TeacherLessonViewModel>.reactive(
      onModelReady: (model) {
        model.setInitDate(lesson);
      },
      builder: (context, vm, child) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text( lesson==null?'Add lesson':'Edit lesson'),
        ),
        body: InputSheetWidget(
          isBusy: vm.isBusy,
          onCancel: () {},
          onDone: () => vm.addLesson(
              levelId: levelId,
              topicId: topicId,
              subTopicId: subTopicId,
              l: lesson),
          title:'',
          child: Form(
            key: vm.formKey,
            child: [
              AppTextField(
                controller: vm.orderTEC,
                hintText: 'Lesson order',
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
                controller: vm.maxQnsTEC,
                hintText: 'Lesson questions limit',
                label: 'Limit',
                maxLength: 3,
                isNumber: true,
                onChanged: (value) {
                  vm.calculatePassQuizLimit();
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the limit';
                  }
                  return null;
                },
              ),
              vSpaceSmall,
              AppTextField(
                controller: vm.correctPassTEC,
                hintText: 'No questions to pass the quiz',
                label: 'No correct quiz',
                isNumber: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the number';
                  }
                  return null;
                },
              ),
              vSpaceSmall,
              AppTextField(
                controller: vm.nameTEC,
                hintText: 'Lesson name',
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
                hintText: 'Lesson description',
                label: 'Description',
                minLine: 2,
                maxLength: 31,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
              ),
              vSpaceSmall,
              InkWell(
                onTap: () async {
                  final content =
                      await Get.to(() => const LessonContentAddView());
                  vm.setBarrierContent(content);
                },
                child: AppTextField(
                  controller: vm.contentTEC,
                  hintText: 'Lesson content',
                  label: 'Content',
                  isEnabled: false,
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Iconsax.arrow_circle_right,
                      color: Colors.black,
                    ),
                    onPressed: () async {},
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the content';
                    }
                    return null;
                  },
                ),
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
                uploadImage: vm.uploadedImages,
              ),
              vSpaceSmall,
            ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
          ),
        ),
      ),
      viewModelBuilder: () => TeacherLessonViewModel(),
    );
  }
}
