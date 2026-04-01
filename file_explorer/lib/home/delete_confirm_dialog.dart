import 'package:flutter/material.dart';

class DeleteConfirmDialog extends StatefulWidget {
  const DeleteConfirmDialog({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  State<DeleteConfirmDialog> createState() => _DeleteConfirmDialogState();
}

class _DeleteConfirmDialogState extends State<DeleteConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Text(widget.content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text("Cancel"),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text("OK"),
        ),
      ],
    );
  }
}
