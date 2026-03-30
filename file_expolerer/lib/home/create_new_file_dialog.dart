import 'package:file_expolerer/file_services/file_services.dart';
import 'package:flutter/material.dart';

class CreateNewFileDialog extends StatefulWidget {
  const CreateNewFileDialog({super.key,required this.currentLocation,});
  final String currentLocation;

  @override
  State<CreateNewFileDialog> createState() => _CreateNewFileDialogState();
}

class _CreateNewFileDialogState extends State<CreateNewFileDialog> {
  final FileServices _fileServices = FileServices();
  TextEditingController newFile = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Create New File"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Enter new file name"),
          SizedBox(height: 8),
          TextField(
            onChanged: (String str){
              setState(() {
              });
            },
            controller: newFile,
            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
              labelText: "File Name",
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
          onPressed: newFile.text.trim().isEmpty
              ? null
              : () async{
           await _fileServices.writeFile(
              '${widget.currentLocation}/${newFile.text}',
              "",
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
