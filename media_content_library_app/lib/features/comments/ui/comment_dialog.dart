import 'package:flutter/material.dart';
import 'package:media_content_library_app/features/comments/data/models/comment_model.dart';

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
      TextEditingController commentController = TextEditingController();
      return AlertDialog(
        title: Text(title ?? "..."),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              width: 500,
              child: ListView.builder(
                itemCount: comments?.length ?? 0,
                itemBuilder: (context, index) {
                  CommentModel comment = comments![index];
                  return ListTile(
                    leading: Icon(Icons.person),
                    title: Text(comment.user ?? ""),
                    subtitle: Text(comment.text ?? ""),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: commentController,
                decoration: InputDecoration(
                  labelText: "Write your comment",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.send_sharp),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
