import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../features/comments/data/models/comment_model.dart';
import '../../../features/comments/ui/comment_dialog.dart';

class CommentFloatingActionButton extends StatelessWidget {
  final String? type;
  final String? id;
  final String title;
  final List<CommentModel>? comments;

  const CommentFloatingActionButton({
    super.key,
    required this.type,
    required this.id,
    required this.title,
    this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showCommentDialog(
          context: context,
          type: type,
          id: id,
          comments: comments,
          title: title,
        );
      },
      child: Icon(Icons.comment_bank_outlined),
    );
  }
}
