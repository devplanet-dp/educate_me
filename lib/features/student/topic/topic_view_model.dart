import 'package:educate_me/data/lesson.dart';
import 'package:educate_me/data/sub_topic.dart';
import 'package:educate_me/data/topic.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../../../core/utils/app_controller.dart';
import '../../../data/level.dart';
import '../../../data/services/firestore_service.dart';
import '../../../locator.dart';

class TopicViewModel extends BaseViewModel {
  final _service = locator<FirestoreService>();
  final AppController controller = Get.find<AppController>();

  List<LevelModel> _levels = [];

  List<LevelModel> get levels => _levels;

  listenToLevels() {
    _service.streamLevels().listen((d) {
      _levels = d;
      if (levels.isNotEmpty) {
        _levels.removeAt(0);
      }
      notifyListeners();
    });
  }

  onTopicSelected(String topicName){
    controller.topicName = topicName;
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
}
