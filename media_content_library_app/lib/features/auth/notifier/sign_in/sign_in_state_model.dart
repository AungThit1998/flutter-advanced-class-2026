import '../../data/models/sign_in/sign_in_model.dart';

class SignInStateModel {
  final bool initialState;
  final bool isLoading;
  final bool isSuccess;
  final bool isFailed;
  final SignInModel? signInModel;
  final String? errorMessage;

  SignInStateModel({
    this.initialState = true,
    this.isLoading = false,
    this.isSuccess = false,
    this.isFailed = false,
    this.signInModel,
    this.errorMessage,
  });

  SignInStateModel copyWith({
    bool? initialState,
    bool? isLoading,
    bool? isSuccess,
    bool? isFailed,
    SignInModel? signInModel,
    String? errorMessage,
  }) {
    return SignInStateModel(
      initialState: initialState ?? this.initialState,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailed: isFailed ?? this.isFailed,
      signInModel: signInModel ?? this.signInModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
