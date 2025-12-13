import 'package:flutter/material.dart';
import 'package:manage_x/features/auth/presentation/widgets/custom_design.dart';
class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main content
          Column(
            children: [
              const SizedBox(height: 120), // space for top design
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(),
                    const SizedBox(height: 10),
                    TextFormField(),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Signup'),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Positioned(
            top: 0,
            right: 0,
            child: CustomTopRightCircles(),
          ),

          // Bottom right design
          Positioned(
            bottom: 0,
            right: 0,
            child: CustomBottomRightDesign(),
          ),
        ],
      ),
    );
  }
}
