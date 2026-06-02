import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:media_content_library_app/const/storage/user_session.dart';
import '../data/models/add_comment_response.dart';
import '../data/models/comment_model.dart';
import '../notfifier/add_comment_notifier.dart';
import '../notfifier/add_comment_state_model.dart';

void showCommentDialog({
  required BuildContext context,
  required String? type,
  required String? id,
  required String? title,
  required List<CommentModel>? comments,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return _CommentDialogWidget(
        type: type,
        id: id,
        title: title,
        comments: comments,
      );
    },
  );
}

class _CommentDialogWidget extends ConsumerStatefulWidget {
  const _CommentDialogWidget({
    super.key,
    required this.type,
    required this.id,
    required this.title,
    required this.comments,
  });

  final String? type;
  final String? id;
  final String? title;
  final List<CommentModel>? comments;

  @override
  ConsumerState<_CommentDialogWidget> createState() =>
      _CommentDialogWidgetState();
}

class _CommentDialogWidgetState extends ConsumerState<_CommentDialogWidget> {
  final UserSession _userSession = UserSession();
  bool _isLoggedIn = false;
  List<CommentModel> _comments = [];
  TextEditingController commentController = TextEditingController();
  AddCommentProvider provider = AddCommentProvider(() {
    return AddCommentNotifier();
  });

  @override
  void initState() {
    super.initState();
    _comments = widget.comments ?? [];
    _userSession.getToken().then((token) {
      setState(() {
        _isLoggedIn = token?.isNotEmpty == true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    AddCommentStateModel addCommentStateModel = ref.watch(provider);

    ref.listen(provider, (oldState, newState) {
      if (oldState?.isLoading == true && newState.isFailed) {
        commentController.clear();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Error"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [Text("Comment Error"), SizedBox(height: 8)],
              ),
              actions: [
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
      if (oldState?.isLoading == true &&
          newState.isSuccess &&
          newState.addCommentResponse != null) {
        AddCommentResponse model = newState.addCommentResponse!;
        setState(() {
          commentController.clear();
          _comments.add(
            CommentModel(
              id: model.id,
              user: model.user,
              userId: model.userId,
              createdAt: model.createdAt,
              text: model.text,
            ),
          );
        });
      }
    });

    return AlertDialog(
      title: Text(widget.title ?? "..."),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_comments.isNotEmpty != true)
            Center(
              child: Column(
                children: [
                  Icon(Icons.comment, size: 50),
                  SizedBox(height: 12),
                  Text(
                    "Empty Comment!\nPlease write first comment",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          if (_comments.isNotEmpty == true)
            SizedBox(
              height: 300,
              width: 500,
              child: ListView.builder(
                itemCount: _comments.length ?? 0,
                itemBuilder: (context, index) {
                  CommentModel comment = _comments[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text(comment.user ?? ""),
                      subtitle: Text(comment.text ?? ""),
                    ),
                  );
                },
              ),
            ),
          if (_isLoggedIn)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: commentController,
                decoration: InputDecoration(
                  labelText: "Write your comment",
                  border: OutlineInputBorder(),
                  suffixIcon: addCommentStateModel.isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            if (commentController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Please enter comment")),
                              );
                            } else {
                              ref
                                  .read(provider.notifier)
                                  .addComment(
                                    text: commentController.text,
                                    type: widget.type!,
                                    id: widget.id!,
                                  );
                            }
                          },
                          icon: Icon(Icons.send_sharp),
                        ),
                ),
              ),
            ),
          if (!_isLoggedIn)
            FilledButton(
              onPressed: () {
                context.push("/sign-in");
              },
              child: Text("Login"),
            ),
        ],
      ),
    );
  }
}
