import 'package:educate_me/data/level.dart';
import 'package:educate_me/data/services/firestore_service.dart';
import 'package:educate_me/locator.dart';
import 'package:stacked/stacked.dart';

class TeacherViewModel extends BaseViewModel {
  final _service = locator<FirestoreService>();

  List<LevelModel> _levels = [];

  List<LevelModel> get levels => _levels;

  listenToLevels() {
    _service.streamLevels().listen((d) {
      _levels = d;
      sortByOrder();
      notifyListeners();
    });
  }
  sortByOrder()=>_levels.sort((a,b)=>a.order!.compareTo(b.order!));
}
