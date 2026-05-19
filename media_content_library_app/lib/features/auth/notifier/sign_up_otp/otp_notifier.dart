import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/sign_up/sign_up_otp_model.dart';
import '../../data/services/auth_api_services.dart';
import 'otp_state_model.dart';

typedef OTPProvider = NotifierProvider<OtpNotifier,OtpStateModel>;

class OtpNotifier extends Notifier<OtpStateModel> {
  final AuthApiServices _services = AuthApiServices();

  @override
  OtpStateModel build() {
    return OtpStateModel();
  }

  void requestOTP({required String email}) async {
    try {
      state = state.copWith(
        isLoading: true,
        isInitialState: false,
        isFailed: false,
        isSuccess: false,
      );
      SignUpOtpModel otpModel = await _services.getOTP(email: email);
      state = state.copWith(
        isLoading: false,
        isSuccess: true,
        signUpOtpModel: otpModel,
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
