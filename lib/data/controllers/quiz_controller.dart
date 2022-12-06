import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:educate_me/data/level.dart';
import 'package:get/get.dart';

import '../lesson.dart';

class QuizController extends GetxController {

  final assetsAudioPlayer = AssetsAudioPlayer();

  LevelModel? currentLevel;

  String? currentTopicName;

  var currentExamIndex = 0.obs;

  List<LessonModel> lessonModel = [];

  playSuccessSound(){
    assetsAudioPlayer.open(Audio('assets/audio/audio_correct.mp3'));
  }


}
