import 'package:educate_me/core/utils/constants/app_assets.dart';
import 'package:educate_me/core/widgets/app_dialog.dart';
import 'package:educate_me/data/controllers/quiz_controller.dart';
import 'package:educate_me/features/student/quiz/quiz_view.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class LessonViewModel extends BaseViewModel {

  final QuizController quizController = Get.find<QuizController>();

  void onStartQuizTapped(
      {required levelId,
      required topicId,
      required subTopicId,
      required lesson}) {
    Get.dialog(AppDialog(
      title: 'text045'.tr,
      image: kIcQuiz,
      onPositiveTap: () {
        Get.back();
        Get.to(() => QuizView(
            levelId: levelId,
            topicId: topicId,
            subTopicId: subTopicId,
            lesson: lesson));
      },
    ));
  }
}
