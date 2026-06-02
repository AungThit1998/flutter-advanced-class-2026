import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../const/di/locator.dart';
import '../../../const/storage/user_session.dart';
import 'profile_state_model.dart';

typedef ProfileProvider = NotifierProvider<ProfileNotifier,ProfileStateModel>;

class ProfileNotifier extends Notifier<ProfileStateModel>{
  final UserSession _userSession = getIt.get();
  @override
  ProfileStateModel build() {
    return ProfileStateModel();
  }
  void checkAuth() async{
    try{
      state = state.copyWith(
        name: await _userSession.getName(),
        email: await _userSession.getEmail(),
        id: await _userSession.getId(),
        token: await _userSession.getToken(),
      );
    }
    catch(e){
      //
    }
  }
  Future<void> logout() async{
   await _userSession.logout();
   state = ProfileStateModel();
  }

}