import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

//Buttons
// Filled Button
// Elevated Button
// Outlined Button
// Text Button
// Icon Button
//print('\x1B[31mHello\x1B[0m'); //ansi color
//Firebase Codemagic
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text("Portfolio"),
          backgroundColor: Colors.indigo,
        ),
        body: ProfilePage(),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            "Wai Phyo Aung",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4),
          Image.network(
            "https://avatars.githubusercontent.com/u/62864134?v=4",
            width: 80,
            height: 80,
          ),
          SizedBox(height: 4),
          Text(
            "Mobile Developer, Flutter Enthusiast",
            style: TextStyle(fontSize: 20),
          ),
          FilledButton(
            onPressed: () {
              _launchUrl("https://github.com/rubywai");
            },
            child: Text("Github Profile"),
          ),
          FilledButton(
            onPressed: () {
              _launchUrl("https://facebook.com");
            },
            child: Text("Facebook"),
          ),
          FilledButton(
            onPressed: () {
              _launchUrl("https://x.com");
            },
            child: Text("X(Twitter)"),
          ),
          FilledButton(
            onPressed: () {
              _launchUrl("https://linkedin.com");
            },
            child: Text("Linkin"),
          ),
        ],
      ),
    );
  }

  void _launchUrl(String link) {
    launchUrl(Uri.parse(link));
  }
}

class Logger {
  static const rest = "\x1B[0m";

  static void info(String message) {
    print("\x1B[30m[INFO] - $message$rest");
  }

  static void success(String message) {
    print("\x1B[32m[SUCCESS] - $message$rest");
  }

  static void warning(String message) {
    print("\x1B[33m[WARNING] - $message$rest");
  }

  static void error(String message) {
    print("\x1B[31m[ERROR] - $message$rest");
  }
}
