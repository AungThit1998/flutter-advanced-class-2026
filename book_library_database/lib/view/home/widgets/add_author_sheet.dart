import 'dart:typed_data';
import 'package:book_library_database/const/theme/app_theme_token.dart';
import 'package:book_library_database/provider/author_provider.dart';
import 'package:book_library_database/view/home/widgets/input_filed_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddAuthorSheet extends StatefulWidget {
  final int? id;
  final String? name;
  final String? description;
  const AddAuthorSheet({super.key, this.id, this.name, this.description});

  @override
  State<AddAuthorSheet> createState() => _AddAuthorSheetState();
}

class _AddAuthorSheetState extends State<AddAuthorSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  Uint8List? _photo;
  @override
  void initState() {
    if (widget.name != null && widget.description != null) {
      _nameController.text = widget.name!;
      _descController.text = widget.description!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppThemeTokens themeTokens = Theme.of(context).extension<AppThemeTokens>()!;
    AuthorProvider authorProvider = Provider.of<AuthorProvider>(
      context,
      listen: false,
    );
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: themeTokens.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        border: Border(top: BorderSide(color: themeTokens.border)),
      ),
      padding: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (widget.name != null && widget.description != null)
                    ? "Update Author Record"
                    : "Insert Author Record",
                style: TextStyle(
                  fontSize: 20,
                  color: themeTokens.onBackground,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
              ),
            ],
          ),
          InputFieldWidget(
            title: "Author Name",
            hintName: "Enter Author Name",
            maxLines: 1,
            controller: _nameController,
          ),
          SizedBox(height: 8),
          InputFieldWidget(
            title: "Author Description",
            hintName: "Enter Description",
            maxLines: 5,
            controller: _descController,
          ),
          SizedBox(height: 8),
          if (widget.name == null && widget.description == null)
            Text(
              "Author Photo (Optional)",
              style: TextStyle(
                color: themeTokens.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (widget.name == null && widget.description == null)
            TextButton(
              onPressed: () async {
                ImagePicker picker = ImagePicker();
                XFile? file = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                _photo = await file?.readAsBytes();
                if (_photo != null) {
                  setState(() {});
                }
              },
              child: Text("Upload Photo"),
            ),
          SizedBox(height: 16),
          if (_photo != null)
            Center(child: Image.memory(_photo!, width: 200, height: 200)),
          if (_photo != null) SizedBox(height: 4),
          InkWell(
            onTap: () async {
              String name = _nameController.text.trim();
              String desc = _descController.text.trim();
              if (widget.name != null && widget.description != null) {
                int result = await authorProvider.updateAuthor(
                  id: widget.id!,
                  name: name,
                  description: desc,
                );
                if (result > 0 && context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Update success")));
                }
              } else if (name.isNotEmpty && desc.isNotEmpty) {
                int result = await authorProvider.saveAuthor(
                  name: name,
                  description: desc,
                  photo: _photo,
                );
                if (result > 0 && context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Save success")));
                }
              } else {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text("Data not complete"),
                      content: Text("Please enter name and desc correctly"),
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
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  colors: [themeTokens.primary, themeTokens.secondary],
                ),
              ),
              child: Text(
                "Save Author",
                style: TextStyle(
                  color: themeTokens.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
