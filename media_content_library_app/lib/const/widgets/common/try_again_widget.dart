import 'package:flutter/material.dart';

class TryAgainWidget extends StatelessWidget {
  const TryAgainWidget({
    super.key,
    required this.onTryAgain,
    this.errorMessage,
  });

  final Function() onTryAgain;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(errorMessage ?? "Something wrong"),
        SizedBox(height: 8),
        OutlinedButton(onPressed: onTryAgain, child: Text("Try Again")),
      ],
    );
  }
}
