import 'package:file_explorer/file_services/file_services.dart';
import 'package:flutter/material.dart';

class CreateOrRenameFileDialog extends StatefulWidget {
  final String? oldName;
  final String currentLocation;
  const CreateOrRenameFileDialog({
    super.key,
    required this.currentLocation,
    this.oldName,
  });

  @override
  State<CreateOrRenameFileDialog> createState() =>
      _CreateOrRenameFileDialogState();
}

class _CreateOrRenameFileDialogState extends State<CreateOrRenameFileDialog> {
  final TextEditingController fileNameController = TextEditingController();
  final FileServices fileServices = FileServices();

  @override
  initState() {
    super.initState();
    if (widget.oldName != null) {
      fileNameController.text = widget.oldName!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.oldName == null ? 'Create New File' : 'Rename File'),
      content: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Enter new file name'),
          TextField(
            onChanged: (value) {
              setState(() {});
            },
            controller: fileNameController,
            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
              hintText: 'File Name',
            ),
          ),
        ],
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: fileNameController.text.trim().isEmpty
              ? null
              : () async {
                  if (widget.oldName == null) {
                    await fileServices.writeFile(
                      '${widget.currentLocation}/${fileNameController.text}',
                      '',
                      status: (status) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(status),
                            ),
                          );
                        }
                      },
                    );

                    if (context.mounted) {
                      Navigator.pop(context, true);
                    }
                  } else {
                    await fileServices.renameFile(
                      '${widget.currentLocation}/${widget.oldName}',
                      '${widget.currentLocation}/${fileNameController.text}',
                    );
                    if (context.mounted) {
                      Navigator.pop(context, true);
                    }
                  }

                  if (widget.oldName != null) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Successfully renamed file'),
                        ),
                      );
                    }
                  }
                },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
