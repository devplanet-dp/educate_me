import 'package:educate_me/core/utils/app_utils.dart';
import 'package:educate_me/data/question.dart';
// import 'package:flutter_tts/flutter_tts.dart';
import 'package:stacked/stacked.dart';

enum SpeechStat{
  stopped,
  playing,
  pause
}
class SpeechViewModel extends BaseViewModel{
  // FlutterTts flutterTts = FlutterTts();

  SpeechStat speechStat = SpeechStat.stopped;

  Future initSpeechEngine()async{
    await _setAwaitOptions();
    // flutterTts.setStartHandler(() {
    //     speechStat = SpeechStat.playing;
    // });
    //
    // flutterTts.setCompletionHandler(() {
    //     speechStat =SpeechStat.stopped;
    // });
    // flutterTts.setErrorHandler((message) {
    //   lg(message);
    // });

  }

  Future speak(QuestionModel? question) async{
    // await flutterTts.setVolume(1);
    // await flutterTts.setSpeechRate(0.4);
    // await flutterTts.setPitch(1);
    // var result = await flutterTts.speak(question?.question??'');
    // if (result == 1){
    //   speechStat = SpeechStat.playing;
    //   notifyListeners();
    // }

  }
  Future _setAwaitOptions() async {
    // await flutterTts.awaitSpeakCompletion(true);
  }

  Future stop() async{
    // var result = await flutterTts.stop();
    // if (result == 1) {
    //   speechStat = SpeechStat.stopped;
    //   notifyListeners();
    // }
  }
}