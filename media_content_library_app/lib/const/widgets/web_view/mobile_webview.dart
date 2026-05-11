import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  const MyWebView({super.key, required this.htmlString});

  final String htmlString;

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  final WebViewController _controller = WebViewController();

  @override
  void initState() {
    super.initState();
    _controller.loadHtmlString(widget.htmlString);
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
