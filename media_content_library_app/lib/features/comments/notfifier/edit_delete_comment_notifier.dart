import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/edit_delete_comment_response.dart';
import '../data/service/comment_services.dart';
import 'edit_delete_comment_state_notifier.dart';

final editDeleteCommentProvider =
    NotifierProvider<EditDeleteCommentNotifier, EditDeleteCommentStateModel>(
  EditDeleteCommentNotifier.new,
);

class EditDeleteCommentNotifier extends Notifier<EditDeleteCommentStateModel> {
  final CommentServices _services = CommentServices();

  @override
  EditDeleteCommentStateModel build() {
    return EditDeleteCommentStateModel();
  }

  void editComment({
    required String text,
    required String type,
    required String id,
    required String commentId,
  }) async {
    try {
      state = state.copyWith(
        isLoading: true,
        isSuccess: false,
        isFailed: false,
        response: null,
      );
      EditDeleteCommentResponse response = await _services.editComment(
        text: text,
        type: type,
        id: id,
        commentId: commentId,
      );
      state = state.copyWith(
        isLoading: false,
        response: response,
        isSuccess: true,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, isFailed: true);
    }
  }

  void deleteComment({
    required String type,
    required String id,
    required String commentId,
  }) async {
    try {
      state = state.copyWith(
        isLoading: true,
        isSuccess: false,
        isFailed: false,
        response: null,
      );
      EditDeleteCommentResponse response = await _services.deleteComment(
        type: type,
        id: id,
        commentId: commentId,
      );
      state = state.copyWith(
        isLoading: false,
        response: response,
        isSuccess: true,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, isFailed: true);
    }
  }
}
