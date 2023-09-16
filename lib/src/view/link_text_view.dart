import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LinkTextView extends StatelessWidget {
  final String text;

  const LinkTextView(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        launchUrlString(text);
      },
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
