import 'package:flutter/material.dart';
import 'package:manage_x/core/widgets/custom_design.dart';

class WebBackground extends StatelessWidget {
  const WebBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(top: 0, left: 65, child: CustomDottedBackground()),
        Positioned(bottom: 0, right: 65, child: CustomDottedBackground()),
        Positioned(top: 0, right: 0, child: CustomTopRightDesign()),
        Positioned(bottom: 0, left: 0, child: CustomBottomLeftDesign()),
      ],
    );
  }
}
