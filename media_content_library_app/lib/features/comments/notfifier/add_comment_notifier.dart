import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/add_comment_response.dart';
import '../data/service/comment_services.dart';
import 'add_comment_state_model.dart';

typedef AddCommentProvider = NotifierProvider<AddCommentNotifier,AddCommentStateModel>;

class AddCommentNotifier extends Notifier<AddCommentStateModel> {
  final CommentServices _services = CommentServices();

  @override
  AddCommentStateModel build() {
    return AddCommentStateModel();
  }

  void addComment({
    required String text,
    required String type,
    required String id,
  }) async {
    try {
      state = state.copyWith(
        isLoading: true,
        isSuccess: false,
        isFailed: false,
        isFormState: false,
        addCommentResponse: null,
      );
      AddCommentResponse addCommentResponse = await _services.addComment(
        text: text,
        type: type,
        id: id,
      );
      state = state.copyWith(
        isLoading: false,
        addCommentResponse: addCommentResponse,
        isSuccess: true,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, isFailed: true);
    }
  }
}
