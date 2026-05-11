import 'package:flutter/material.dart';
import 'dart:js_interop';
import 'dart:ui_web' as ui_web;
import 'package:web/web.dart' as web;

class MyWebView extends StatefulWidget {
  const MyWebView({super.key, required this.htmlString});
  final String htmlString;

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'html-string-view-${DateTime.now().microsecondsSinceEpoch}';
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final div = web.HTMLDivElement();
      div.style.width = '100%';
      div.style.height = '100%';
      div.style.overflow = 'auto';
      div.setHTMLUnsafe(widget.htmlString.toJS);
      return div;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: HtmlElementView(viewType: _viewType),
    );
  }
}
