import 'package:book_library_database/provider/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<BookProvider>(context,listen: false).getAllBook();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}