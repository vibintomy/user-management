import 'package:flutter/material.dart';
import 'package:manage_x/core/widgets/typography/app_text.dart';

class AppButtonText extends StatelessWidget {
  final String text;

  const AppButtonText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppText(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelLarge,
    );
  }
}
