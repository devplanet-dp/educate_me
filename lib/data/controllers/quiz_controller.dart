import 'package:educate_me/data/level.dart';
import 'package:get/get.dart';

import '../lesson.dart';

class QuizController extends GetxController {
  LevelModel? currentLevel;

  String? currentTopicName;

  var currentExamIndex = 0.obs;

  List<LessonModel> lessonModel = [];


}
