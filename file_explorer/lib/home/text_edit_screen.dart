import 'package:flutter/material.dart';

import '../file_services/file_services.dart';

class TextEditScreen extends StatefulWidget {
  const TextEditScreen({super.key, required this.currentFileLocation});

  final String currentFileLocation;

  @override
  State<TextEditScreen> createState() => _TextEditScreenState();
}

class _TextEditScreenState extends State<TextEditScreen> {
  final TextEditingController _controller = TextEditingController();
  final FileServices _fileServices = FileServices();
  bool _hadEdit = false;

  @override
  void initState() {
    super.initState();
    _fileServices.readFile(widget.currentFileLocation).then((str) {
      setState(() {
        _controller.text = str;
      });
    });
    _controller.addListener(() {
      if (!_hadEdit) {
        setState(() {
          _hadEdit = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(widget.currentFileLocation),
        actions: [
          IconButton(
            onPressed: _hadEdit
                ? () async {
                    try {
                      await _fileServices.writeFile(
                        widget.currentFileLocation,
                        _controller.text,
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Text("File Save Successfully"),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("Failed to save file"),
                          ),
                        );
                      }
                    }
                  }
                : null,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _controller,
          maxLines: 30,
          decoration: InputDecoration(border: InputBorder.none),
        ),
      ),
    );
  }
}
