import 'package:flutter/material.dart';
import 'package:manage_x/core/widgets/typography/app_text.dart';

class AppPageTitle extends StatelessWidget {
  final String text;
  final Color? color;

  const AppPageTitle(this.text,this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppText(text, style: Theme.of(context).textTheme.displaySmall?.copyWith(color: color));
  }
}
