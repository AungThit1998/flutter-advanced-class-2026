import 'package:media_content_library_app/features/auth/data/models/sign_up/sign_up_model.dart';

import '../../data/models/sign_up/sign_up_otp_model.dart';

class SignUpStateModel {
  final bool isInitialState;
  final bool isLoading;
  final bool isSuccess;
  final bool isFailed;
  final SignUpModel? signUpModel;
  final String? errorMessage;

  SignUpStateModel({
    this.isInitialState = true,
    this.isLoading = false,
    this.isSuccess = false,
    this.isFailed = false,
    this.signUpModel,
    this.errorMessage,
  });

  SignUpStateModel copWith({
    bool? isInitialState,
    bool? isLoading,
    bool? isSuccess,
    bool? isFailed,
    SignUpModel? signUpModel,
    String? errorMessage,
  }) {
    return SignUpStateModel(
      isInitialState: isInitialState ?? this.isInitialState,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailed: isFailed ?? this.isFailed,
      signUpModel: signUpModel ?? this.signUpModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
