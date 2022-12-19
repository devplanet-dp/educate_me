import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:educate_me/data/level.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';

import '../lesson.dart';

class QuizController extends GetxController {

  final assetsAudioPlayer = AssetsAudioPlayer();

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;


  LevelModel? currentLevel;

  String? currentTopicName;

  var currentExamIndex = 0.obs;

  List<LessonModel> lessonModel = [];

  playSuccessSound(){
    assetsAudioPlayer.open(Audio('assets/audio/audio_correct.mp3'));
  }
  Future<void> sendDrawToolAnalytics()async{
    await analytics.logEvent(name: 'drawing_used',parameters: {
      'lesson':'My Lesson',
      'user':'Ishara Kasun',
    });
  }
  bool isQuizCompleted=false;

}
