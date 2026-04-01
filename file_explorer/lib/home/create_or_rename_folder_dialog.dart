import 'package:flutter/material.dart';

import '../file_services/file_services.dart';

class CreateOrRenameFolderDialog extends StatefulWidget {
  const CreateOrRenameFolderDialog({
    super.key,
    required this.currentLocation,
    this.oldName,
  });

  final String currentLocation;
  final String? oldName;

  @override
  State<CreateOrRenameFolderDialog> createState() =>
      _CreateOrRenameFolderDialogState();
}

class _CreateOrRenameFolderDialogState
    extends State<CreateOrRenameFolderDialog> {
  final FileServices _fileServices = FileServices();
  TextEditingController newFolder = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.oldName != null) {
      newFolder.text = widget.oldName!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.oldName == null ? "Create New Folder" : "Rename Folder",
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Enter new folder name"),
          SizedBox(height: 8),
          TextField(
            onChanged: (String str) {
              setState(() {});
            },
            controller: newFolder,
            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
              labelText: "Folder Name",
            ),
          ),
        ],
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        FilledButton(
          onPressed: newFolder.text.trim().isEmpty
              ? null
              : () async {
                  if (widget.oldName == null) {
                    await _fileServices.createFolder(
                      "${widget.currentLocation}${newFolder.text}",
                      status: (String status) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(status)));
                      },
                    );
                  } else {
                    try {
                      String oldPath =
                          "${widget.currentLocation}${widget.oldName}";
                      String newPath =
                          "${widget.currentLocation}${newFolder.text}";
                      await _fileServices.renameFolder(oldPath, newPath);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Text("Successfully rename"),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("Failed to rename folder"),
                          ),
                        );
                      }
                    }
                  }
                  if (context.mounted) {
                    Navigator.pop(context, true);
                  }
                },
          child: Text('OK'),
        ),
      ],
    );
  }
}
