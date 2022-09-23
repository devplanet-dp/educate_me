import 'package:educate_me/core/widgets/busy_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:stacked/stacked.dart';

import '../teacher_lesson_view_model.dart';

class LessonContentAddView extends StatelessWidget {
  const LessonContentAddView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TeacherLessonViewModel>.reactive(
      builder: (context, vm, child) => Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: const Text('Add edit lesson content'),
          ),
          bottomNavigationBar: Container(
            color: Colors.white,
            child: BoxButtonWidget(
              onPressed: () => vm.onLessonContentSubmitClicked(),
              buttonText: 'Submit',
              radius: 8,
            ).paddingAll(16),
          ),
          body: HtmlEditor(
            controller: vm.htmlController,
            hint: 'Add your content here...',
            toolbar: const [
              Style(),
              FontSetting(),
              Font(),
              ColorBar(),
              Paragraph(),
              Insert(),
            ],
            callbacks: Callbacks(onInit: () {
              vm.initHtmlEditor();
            }),
            options: HtmlEditorOptions(
                height: Get.height,
                shouldEnsureVisible: true,
                showBottomToolbar: true),
          )),
      viewModelBuilder: () => TeacherLessonViewModel(),
    );
  }
}
