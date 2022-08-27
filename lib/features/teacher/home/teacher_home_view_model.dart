import 'package:educate_me/data/level.dart';
import 'package:educate_me/data/services/auth_service.dart';
import 'package:educate_me/data/services/firestore_service.dart';
import 'package:educate_me/locator.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TeacherViewModel extends BaseViewModel {
  final _service = locator<FirestoreService>();
  final _authService = locator<AuthenticationService>();
  final _dialogService = locator<DialogService>();

  List<LevelModel> _levels = [];

  List<LevelModel> get levels => _levels;

  listenToLevels() {
    _service.streamLevels().listen((d) {
      _levels = d;
      sortByOrder();
      notifyListeners();
    });
  }

  sortByOrder() => _levels.sort((a, b) => a.order!.compareTo(b.order!));

  signOut() async {
    Get.back();
    _authService.signOut();
  }
}
