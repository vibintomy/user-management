import 'package:flutter/material.dart';
import 'package:manage_x/core/widgets/typography/app_text.dart';


class AppSectionTitle extends StatelessWidget {
  final String text;

  const AppSectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppText(
      text,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
