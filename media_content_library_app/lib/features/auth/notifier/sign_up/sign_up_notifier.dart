import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/sign_up/sign_up_model.dart';
import '../../data/services/auth_api_services.dart';
import 'sign_up_state_model.dart';

typedef SignupProvider = NotifierProvider<SignUpNotifier,SignUpStateModel>;

class SignUpNotifier extends Notifier<SignUpStateModel> {
  final AuthApiServices _services = AuthApiServices();

  @override
  SignUpStateModel build() {
    return SignUpStateModel();
  }

  void signUp({
    required String email,
    required String name,
    required password,
    required otp,
  }) async {
    try {
      state = state.copWith(
        isLoading: true,
        isInitialState: false,
        isFailed: false,
        isSuccess: false,
      );
      SignUpModel signUpModel = await _services.signup(email: email,
      name: name,
      password: password,
      otp: otp);
      state = state.copWith(
        isLoading: false,
        isSuccess: true,
        signUpModel: signUpModel,
      );
    } catch (e) {
      String errorMessage = "Something Wrong";
      if(e is DioException){
        final data = e.response?.data;
        if(data is Map?) {
          errorMessage = data?['message']  ?? errorMessage;
        }
      }
      state = state.copWith(
        isLoading: false,
        isFailed: true,
        errorMessage: errorMessage,
      );
    }
  }
  void tryAgain(){
    state = state.copWith(
      isFailed: false,
      isInitialState: true,
      isLoading: false,
      isSuccess: false,
    );
  }
}
