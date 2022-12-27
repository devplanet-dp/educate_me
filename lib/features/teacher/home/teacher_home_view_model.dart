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

  bool _isMultiselect = false;

  bool get multiSelect => _isMultiselect;

  toggleMultiSelect() {
    _isMultiselect = !_isMultiselect;
    selectedQnsIds.clear();
    notifyListeners();
  }

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

  List<String> selectedQnsIds = [];

  bool isLessonSelected(String qns) =>
      selectedQnsIds.contains(qns) && multiSelect;

  void onQnsSelectedForDelete(String qns) {
    if (selectedQnsIds.contains(qns)) {
      selectedQnsIds.remove(qns);
    } else {
      selectedQnsIds.add(qns);
    }
    notifyListeners();
  }

  Future removeLevels() async {
    var response = await _dialogService.showConfirmationDialog(
        title: 'Are you sure?',
        description: 'Delete ${selectedQnsIds.length} levels?');
    if (response?.confirmed ?? false) {
      for (var e in selectedQnsIds) {
        await _service.removeLevel(e);
      }
      selectedQnsIds.clear();
      notifyListeners();
    }
  }

  signOut() async {
    Get.back();
    _authService.signOut();
  }
}
