import '../data/models/edit_delete_comment_response.dart';

class EditDeleteCommentStateModel {
  final bool isLoading;
  final bool isSuccess;
  final bool isFailed;
  final EditDeleteCommentResponse? response;

  EditDeleteCommentStateModel({
    this.isLoading = false,
    this.isSuccess = false,
    this.isFailed = false,
    this.response,
  });

  EditDeleteCommentStateModel copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isFailed,
    EditDeleteCommentResponse? response,
  }) {
    return EditDeleteCommentStateModel(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailed: isFailed ?? this.isFailed,
      response: response,
    );
  }
}
