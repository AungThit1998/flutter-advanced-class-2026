import 'package:book_library_database/const/theme/app_theme_token.dart';
import 'package:book_library_database/view/home/widgets/input_filed_widget.dart';
import 'package:flutter/material.dart';

class AddAuthorSheet extends StatefulWidget {
  const AddAuthorSheet({super.key});

  @override
  State<AddAuthorSheet> createState() => _AddAuthorSheetState();
}

class _AddAuthorSheetState extends State<AddAuthorSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppThemeTokens themeTokens = Theme.of(context).extension<AppThemeTokens>()!;
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
                "Insert Book Record",
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
          Text(
            "Author Photo (Optional)",
            style: TextStyle(
              color: themeTokens.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextButton(onPressed: () {}, child: Text("Upload Photo")),
        ],
      ),
    );
  }
}
