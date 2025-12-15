import 'package:flutter/material.dart';
import 'package:manage_x/core/widgets/typography/app_text.dart';


class AppHelperText extends StatelessWidget {
  final String text;
  final Color? color;

  const AppHelperText(
    this.text, {
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppText(
      text,
      style: Theme.of(context)
          .textTheme
          .bodySmall
          ?.copyWith(color: color ?? Colors.grey),
    );
  }
}
