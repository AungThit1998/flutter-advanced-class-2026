import '../../data/models/sign_up/sign_up_otp_model.dart';

class OtpStateModel {
  final bool isInitialState;
  final bool isLoading;
  final bool isSuccess;
  final bool isFailed;
  final SignUpOtpModel? signUpOtpModel;
  final String? errorMessage;

  OtpStateModel({
    this.isInitialState = true,
    this.isLoading = false,
    this.isSuccess = false,
    this.isFailed = false,
    this.signUpOtpModel,
    this.errorMessage,
  });

  OtpStateModel copWith({
    bool? isInitialState,
    bool? isLoading,
    bool? isSuccess,
    bool? isFailed,
    SignUpOtpModel? signUpOtpModel,
    String? errorMessage,
  }) {
    return OtpStateModel(
      isInitialState: isInitialState ?? this.isInitialState,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailed: isFailed ?? this.isFailed,
      signUpOtpModel: signUpOtpModel ?? this.signUpOtpModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
