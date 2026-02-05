import 'package:flutter/material.dart';
import 'package:manage_x/core/constants/app_colors.dart';
import 'package:manage_x/core/widgets/custom_design.dart';
import 'package:manage_x/core/widgets/spacing.dart';
import 'package:manage_x/core/widgets/typography/page_title.dart';

class AdminOverviewChartMobile extends StatelessWidget {
  const   AdminOverviewChartMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmallScreen = screenWidth < 360;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Main chart card (was the large left container)
          Container(
            height: 340, // reduced from 400
            decoration: BoxDecoration(
              color: const Color(0xFF5F52A6),
              borderRadius: BorderRadius.circular(24),
              
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Bottom section
                  Positioned.fill(
                    top: 240, // adjusted proportionally
                    child: Container(
                      color: const Color(0xFF5F52A6),
                     
                    ),
                  ),

                  // Top section
                  Container(
                    height: 160, // scaled down
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8078C9),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 6,
                          spreadRadius: 0,
                          color: Color.fromARGB(100, 21, 8, 117),
                        ),
                      ],
                    ),
                  ),

                  // Overlapping centered card
                  Positioned(
                    top: 130, // moved down a bit for mobile proportions
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        height: 180, // slightly smaller
                        width: isVerySmallScreen ? 180 : 220,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8078C9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0, 8),
                              blurRadius: 14,
                              spreadRadius: -6,
                              color: Color.fromARGB(120, 21, 8, 117),
                            ),
                          ],
                        ),
                         child: Center(child: Align(
                          alignment: AlignmentGeometry.center,
                          child: Text('Admin\n Dashboard',style: TextStyle(color: AppColors.white,fontSize: 27),))),
                        // You can put real chart content here later
                        // child: const Center(child: Text("Chart", style: TextStyle(color: Colors.white))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          kheight20,

          // 2. Date card
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF5F52A6),
                      Color(0xFF8078C9),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AppPageTitle(
                      "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                      AppColors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20, // pops out a bit
                left: 30,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8078C9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 8,
                        spreadRadius: 0,
                        color: Color.fromARGB(100, 21, 8, 117),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.calendar_month,
                    color: AppColors.white,
                    size: 44,
                  ),
                ),
              ),
            ],
          ),

          kheight20,

          // 3. Schedule / Wave card
      
        ],
      ),
    );
  }
}