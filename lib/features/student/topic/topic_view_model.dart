import 'package:educate_me/data/controllers/quiz_controller.dart';
import 'package:educate_me/data/lesson.dart';
import 'package:educate_me/data/sub_topic.dart';
import 'package:educate_me/data/topic.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../../../core/utils/app_controller.dart';
import '../../../data/level.dart';
import '../../../data/question.dart';
import '../../../data/services/firestore_service.dart';
import '../../../locator.dart';
import '../lesson/lesson_view.dart';
import '../sub-topic/sub_topic_view.dart';

class TopicViewModel extends BaseViewModel {
  final _service = locator<FirestoreService>();
  final AppController controller = Get.find<AppController>();
  final QuizController quizController = Get.find<QuizController>();

  String updatingLessonId = '';

  List<LevelModel> _levels = [];
  List<TopicModel> _topics = [];
  List<SubTopicModel> _subTopics = [];
  List<LessonModel> _lessons = [];

  List<LevelModel> get levels => _levels;

  List<TopicModel> get topics => _topics;

  List<SubTopicModel> get subTopics => _subTopics;

  List<LessonModel> get lessons => _lessons;

  listenToLevels() {
    _service.streamLevels().listen((d) {
      _levels = d;
      notifyListeners();
    });
  }

  listenToTopics(levelId) {
    _service.streamLevelTopics(levelId).listen((d) {
      _topics = d;
      notifyListeners();
    });
  }

  listenToSubTopics({required levelId, required topicId}) {
    _service.streamSubTopic(levelId: levelId, topicId: topicId).listen((d) {
      _subTopics = d;
      notifyListeners();
    });
  }

  listenToLessons({required levelId, required topicId, required subTopicId}) {
    _service
        .streamLessons(
            levelId: levelId, topicId: topicId, subTopicId: subTopicId)
        .listen((d) {
      _lessons = d;
      notifyListeners();
    });
  }

  Stream<List<TopicModel>> streamLevelTopics(String levelId) =>
      _service.streamLevelTopics(levelId);

  Stream<List<SubTopicModel>> streamSubTopics(
          {required levelId, required topicId}) =>
      _service.streamSubTopic(levelId: levelId, topicId: topicId);

  Stream<List<LessonModel>> streamLesson(
          {required levelId, required topicId, required subTopicId}) =>
      _service.streamLessons(
          levelId: levelId, topicId: topicId, subTopicId: subTopicId);

  goToSubtopic({required LevelModel level, required TopicModel topic}) {
    quizController.currentLevel = level;
    quizController.currentTopicName = topic.name;
    Get.to(() => SubTopicView(
          topic: topic,
          levelId: level.id ?? '',
        ));
  }

  goToLessonView(
      {required LessonModel currentLesson,
      required levelId,
      required topicId,
      required subTopicId,
      required lessons}) {
    quizController.lessonModel = lessons;
    Get.to(() => LessonView(
        lesson: currentLesson,
        levelId: levelId,
        topicId: topicId,
        subTopicId: subTopicId));
  }

  bool isLessonCompleted(String lessonId) {
    final completedLessons =
        controller.currentChild?.stats?.completedLesson ?? [];
    return completedLessons.where((e) => e.lessonId == lessonId).isNotEmpty;
  }

  bool isLevelLocked(String levelId) {
    return false;
    //todo implementation
    final completedLevels =
        controller.currentChild?.stats?.unlockedLevels ?? [];
    return !completedLevels.contains(levelId);
  }

  Future<int> getQuestions(
      {required levelId,
      required topicId,
      required subTopicId,
      required lessonId}) async {
    var result = await _service.getQuestions(
        levelId: levelId,
        topicId: topicId,
        subTopicId: subTopicId,
        lessonId: lessonId);
    if (!result.hasError) {
      var list = result.data as List<QuestionModel>;
      return list.length;
    }
    return 0;
  }

  Future<void> updateDrawingToolCount(
      {required lesson,
      required levelId,
      required topicId,
      required subTopicId,
      required enable}) async {
    //used to update drawing tool used
    updatingLessonId = lesson;

    setBusyForObject(updatingLessonId, true);
    var result = await _service.updateEnableDisableDraw(
        levelId: levelId,
        topicId: topicId,
        subTopic: subTopicId,
        lessonId: lesson,
        enable: enable);
    setBusyForObject(updatingLessonId, false);
  }
}
