import 'dart:typed_data';
import '../../../const/theme/app_theme_token.dart';
import '../../../provider/book_provider.dart';
import '../../../view/home/widgets/input_filed_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddBookSheet extends StatefulWidget {
  final int? id;
  final String? title;
  final String? description;
  final String? reference;
  final int? authorId;

  const AddBookSheet({
    super.key,
    this.id,
    this.title,
    this.description,
    this.reference,
    this.authorId,
  });

  @override
  State<AddBookSheet> createState() => _AddBookSheetState();
}

class _AddBookSheetState extends State<AddBookSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  Uint8List? _photo;
  @override
  void initState() {
    if (widget.title != null && widget.description != null) {
      _titleController.text = widget.title!;
      _descController.text = widget.description!;
      _referenceController.text = widget.reference!;
      _tagController.text = widget.authorId.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppThemeTokens themeTokens = Theme.of(context).extension<AppThemeTokens>()!;
    BookProvider bookProvider = Provider.of<BookProvider>(
      context,
      listen: false,
    );
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
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
                (widget.title != null && widget.description != null)
                    ? "Update Book Record"
                    : "Insert Book Record",
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
            title: "Record Name",
            hintName: "Enter Name...",
            maxLines: 1,
            controller: _titleController,
          ),
          SizedBox(height: 8),
          InputFieldWidget(
            title: "Reference / Relation",
            hintName: "Enter sub-details...",
            maxLines: 1,
            controller: _referenceController,
          ),
          SizedBox(height: 8),
          InputFieldWidget(
            title: "Metadata Tags (Comma Separated)",
            hintName: "eg. active, foreign_key",
            maxLines: 1,
            controller: _tagController,
          ),
          SizedBox(height: 8),
          InputFieldWidget(
            title: "Blob / Description",
            hintName: "Enter full payload data here...",
            maxLines: 5,
            controller: _descController,
          ),
          SizedBox(height: 8),
          if (widget.title == null && widget.description == null)
            Text(
              "Cover Photo (Optional)",
              style: TextStyle(
                color: themeTokens.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (widget.title == null && widget.description == null)
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
              child: Text("Upload Cover"),
            ),
          SizedBox(height: 16),
          if (_photo != null)
            Center(child: Image.memory(_photo!, width: 200, height: 200)),
          if (_photo != null) SizedBox(height: 4),
          InkWell(
            onTap: () async {
              String title = _titleController.text.trim();
              String desc = _descController.text.trim();
              String reference = _referenceController.text.trim();
              int tags = int.parse(_tagController.text);
              if (widget.title != null && widget.description != null) {
                int result = await bookProvider.updateBook(
                  id: widget.id!,
                  title: title,
                  description: desc,
                  reference: reference,
                  authorId: tags,
                );
                if (result > 0 && context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Update success")));
                }
              } else if (title.isNotEmpty &&
                  desc.isNotEmpty &&
                  reference.isNotEmpty &&
                  tags != 0) {
                int result = await bookProvider.saveBook(
                  name: title,
                  description: desc,
                  cover: _photo,
                  authorId: tags,
                  reference: reference,
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
                "COMMIT INSERT",
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
