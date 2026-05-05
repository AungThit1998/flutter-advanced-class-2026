import 'package:flutter/material.dart';

class TryAgainWidget extends StatelessWidget {
  const TryAgainWidget({super.key,required this.onTryAgain});
  final Function() onTryAgain;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Something wrong"),
        SizedBox(height: 8),
        OutlinedButton(
          onPressed: onTryAgain,
          child: Text("Try Again"),
        ),
      ],
    );
  }
}
