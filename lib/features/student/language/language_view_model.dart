import 'package:educate_me/data/services/local_storage_service.dart';
import 'package:educate_me/locator.dart';
import 'package:stacked/stacked.dart';

class LangViewModel extends BaseViewModel {
  final localStorage = locator<LocalStorageService>();

  final _list = [
    {'code': 'en', 'name': 'English'},
    {'code': 'fr', 'name': 'French'},
    {'code': 'ga', 'name': 'Irish'},
  ];

  List<Map> get languages => _list;

  void onLanguageSelected(String code) {
    localStorage.appLocale = code;
    notifyListeners();
  }

  String? get languageName =>
      _list.firstWhere((e) => e['code'] == localStorage.appLocale)['name'];
}
