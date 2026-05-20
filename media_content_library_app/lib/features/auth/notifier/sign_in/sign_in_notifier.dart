import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../const/di/locator.dart';
import '../../../../const/storage/user_session.dart';
import '../../data/models/sign_in/sign_in_model.dart';
import '../../data/services/auth_api_services.dart';
import 'sign_in_state_model.dart';

typedef SignInProvider = NotifierProvider<SignInNotifier,SignInStateModel>;

class SignInNotifier extends Notifier<SignInStateModel> {
  final AuthApiServices _services = AuthApiServices();
  final UserSession _userSession = getIt.get();

  @override
  SignInStateModel build() {
    return SignInStateModel();
  }

  void signIn({required String email, required String password}) async {
    try {
      state = state.copyWith(
        isLoading: true,
        isSuccess: false,
        isFailed: false,
        initialState: false,
      );
      SignInModel signInModel = await _services.signIn(
        email: email,
        password: password,
      );
      _saveUserCredentials(signInModel);
      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        signInModel: signInModel,
      );
    } catch (e) {
      String? errorMessage = "Something Wrong";
      if(e is DioException){
      final error =   e.response?.data;
        if(error is Map?){
          errorMessage = error?["message"] ?? errorMessage;
        }
      }
      state = state.copyWith(isLoading: false, isFailed: true,
      errorMessage: errorMessage);
    }
  }
  void tryAgain(){
    state = SignInStateModel(initialState: true);
  }
  Future<void> _saveUserCredentials(SignInModel signInModel) async {
    await _userSession.saveToken(signInModel.token ?? "");
    await _userSession.saveEmail(signInModel.user?.email ?? "");
    await _userSession.saveId(signInModel.user?.id?.toString() ?? "");
    await _userSession.saveName(signInModel.user?.name?.toString() ?? "");
  }
}
