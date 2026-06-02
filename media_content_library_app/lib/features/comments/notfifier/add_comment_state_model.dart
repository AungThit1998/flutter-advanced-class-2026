
import '../data/models/add_comment_response.dart';

class AddCommentStateModel {
  final bool isLoading;
  final bool isSuccess;
  final bool isFailed;
  final bool isFormState;
  final AddCommentResponse? addCommentResponse;

  AddCommentStateModel({
     this.isLoading = false,
     this.isSuccess = false,
     this.isFailed = false,
     this.isFormState = true,
     this.addCommentResponse,
  });

  AddCommentStateModel copyWith({
     bool? isLoading,
     bool? isSuccess,
     bool? isFailed,
     bool? isFormState,
    AddCommentResponse? addCommentResponse,
}){
    return AddCommentStateModel(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isFormState: isFormState ?? this.isFormState,
      isFailed: isFailed ?? this.isFailed,
      addCommentResponse: addCommentResponse,
    );
  }

}
