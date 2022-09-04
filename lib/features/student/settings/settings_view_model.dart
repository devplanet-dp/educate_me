import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../data/services/auth_service.dart';
import '../../../locator.dart';

class SettingViewModel extends BaseViewModel{
  final _authService = locator<AuthenticationService>();
  final _dialogService = locator<DialogService>();

  void signOut()async{
    var result = await _dialogService.showConfirmationDialog(title: 'Are you sure?',description: 'Sign out');
    if(result?.confirmed??false){
      _authService.signOut();
    }
  }
}