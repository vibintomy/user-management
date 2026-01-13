import 'package:flutter/material.dart';
import 'package:manage_x/core/responsive/responsive.dart';

class CustomButton extends StatelessWidget {
  final String? label;
  final Widget? child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final double height;
  final double width;
  final double borderRadius;
  final Color? labelColor;

  const CustomButton({
    super.key,
    this.label,
    this.child,
    required this.onPressed,
    this.backgroundColor,
    this.height = 50,
    this.width = 150,
    this.borderRadius = 30,
    this.labelColor
  }) : assert(label != null || child != null, 'Either label or child must be provided');
  
  @override
  Widget build(BuildContext context) {
     final bool isWeb = Responsive.isWeb(context);

    final double buttonHeight = isWeb ? height + 10 : height;
    final double buttonWidth = isWeb ? width + 15 : width;
    return SizedBox(
      height: buttonHeight,
      width: buttonWidth,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
        child: child ?? Text(label!, style: TextStyle(color: labelColor)),
      ),
    );
  }
}