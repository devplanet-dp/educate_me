import 'package:educate_me/core/widgets/busy_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:responsive_builder/responsive_builder.dart';
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
            child: ResponsiveBuilder(
              builder: (context,_) {
                return BoxButtonWidget(
                  onPressed: () => vm.onLessonContentSubmitClicked(),
                  buttonText: 'Submit',
                  radius: 8,
                ).paddingSymmetric(horizontal: _.isDesktop?90.w:16,vertical: 16);
              }
            ),
          ),
          body: HtmlEditor(
            controller: vm.htmlController,

            htmlEditorOptions: const HtmlEditorOptions(
              hint: 'Add your content here...',

            ),
            callbacks: Callbacks(onInit: () {
              vm.initHtmlEditor();
            }),
            otherOptions: OtherOptions(
                height: Get.height,
               ),
          )),
      viewModelBuilder: () => TeacherLessonViewModel(),
    );
  }
}
