import 'package:flutter/material.dart';

import '../file_services/file_services.dart';

class CreateNewFolderDialog extends StatefulWidget {
  const CreateNewFolderDialog({super.key,required this.currentLocation,});
  final String currentLocation;

  @override
  State<CreateNewFolderDialog> createState() => _CreateNewFolderDialogState();
}

class _CreateNewFolderDialogState extends State<CreateNewFolderDialog> {
  final FileServices _fileServices = FileServices();
  TextEditingController newFolder = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Create New Folder"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Enter new folder name"),
          SizedBox(height: 8),
          TextField(
            onChanged: (String str){
              setState(() {
              });
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
              : () async{
                 await _fileServices.createFolder(
                    "${widget.currentLocation}${newFolder.text}",
                    status: (String status) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(status)));
                    },
                  );
                 if(context.mounted) {
                   Navigator.pop(context,true);
                 }
                },
          child: Text('OK'),
        ),
      ],
    );
  }
}
