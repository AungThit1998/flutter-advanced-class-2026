import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:media_content_library_app/const/storage/user_session.dart';
import '../data/models/add_comment_response.dart';
import '../data/models/comment_model.dart';
import '../notfifier/add_comment_notifier.dart';
import '../notfifier/add_comment_state_model.dart';
import '../notfifier/edit_delete_comment_notifier.dart';

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

Future<({bool isDeleted, String? editedText})?> showUpdateDeleteDialog({
  required BuildContext context,
  required String? type,
  required String? id,
  required CommentModel comment,
}) {
  return showDialog<({bool isDeleted, String? editedText})>(
    context: context,
    builder: (context) {
      return _UpdateDeleteDialog(type: type, id: id, comment: comment);
    },
  );
}

class _UpdateDeleteDialog extends ConsumerStatefulWidget {
  final String? type;
  final String? id;
  final CommentModel? comment;
  const _UpdateDeleteDialog({
    required this.type,
    required this.id,
    required this.comment,
  });

  @override
  ConsumerState<_UpdateDeleteDialog> createState() =>
      _UpdateDeleteDialogState();
}

class _UpdateDeleteDialogState extends ConsumerState<_UpdateDeleteDialog> {
  late TextEditingController _editController;
  bool _isEditing = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.comment?.text ?? '');
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  void _editComment() {
    if (_editController.text.trim().isEmpty) return;
    _isDeleting = false;
    ref
        .read(editDeleteCommentProvider.notifier)
        .editComment(
          text: _editController.text.trim(),
          type: widget.type!,
          id: widget.id!,
          commentId: widget.comment?.id.toString() ?? '',
        );
  }

  void _deleteComment() {
    _isDeleting = true;
    ref
        .read(editDeleteCommentProvider.notifier)
        .deleteComment(
          type: widget.type!,
          id: widget.id!,
          commentId: widget.comment?.id.toString() ?? '',
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editDeleteCommentProvider);

    ref.listen(editDeleteCommentProvider, (previous, next) {
      if (previous?.isLoading == true && next.isSuccess) {
        if (_isDeleting) {
          Navigator.pop(context, (isDeleted: true, editedText: null));
        } else {
          Navigator.pop(context, (
            isDeleted: false,
            editedText: _editController.text.trim(),
          ));
        }
      }
      if (previous?.isLoading == true && next.isFailed) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Something went wrong. Please try again.'),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });

    if (_isEditing) {
      return AlertDialog(
        title: const Text('Edit Comment'),
        content: TextField(
          controller: _editController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Update your comment',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => setState(() => _isEditing = false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: state.isLoading ? null : _editComment,
            child: state.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      );
    }

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () => setState(() => _isEditing = true),
            title: const Text('Edit'),
            leading: const Icon(Icons.edit_outlined),
          ),
          const Divider(),
          ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Comment'),
                  content: const Text(
                    'Are you sure you want to delete this comment?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _deleteComment();
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
            title: const Text('Delete'),
            leading: const Icon(Icons.delete_outlined),
          ),
        ],
      ),
    );
  }
}

class _CommentDialogWidget extends ConsumerStatefulWidget {
  const _CommentDialogWidget({
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
              isOwn: true,
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
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  CommentModel comment = _comments[index];
                  return Card(
                    child: ListTile(
                      trailing: (comment.isOwn != null && comment.isOwn == true)
                          ? InkWell(
                              onTap: () async {
                                final result = await showUpdateDeleteDialog(
                                  comment: comment,
                                  type: widget.type,
                                  id: widget.id,
                                  context: context,
                                );
                                if (result != null) {
                                  setState(() {
                                    if (result.isDeleted) {
                                      _comments.removeWhere(
                                        (c) => c.id == comment.id,
                                      );
                                    } else if (result.editedText != null) {
                                      final i = _comments.indexWhere(
                                        (c) => c.id == comment.id,
                                      );
                                      if (i != -1) {
                                        _comments[i] = comment.copyWith(
                                          text: result.editedText,
                                        );
                                      }
                                    }
                                  });
                                }
                              },
                              child: Icon(Icons.menu),
                            )
                          : null,
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
