import 'package:flutter/material.dart';

class AdminOverviewChart extends StatelessWidget {
  const AdminOverviewChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
     
      width: 650,
      height: 400,
       decoration:  BoxDecoration(
                color: Color(0xFF5F52A6) ,
                borderRadius: BorderRadius.all(Radius.circular(30))
              ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Bottom section
            Positioned.fill(
              top: 300,
              child: Container(
                color:  Color(0xFF5F52A6),
              ),
            ),

            // Top section
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                color:  Color(0xFF8078C9)
,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30))
              ),
            ),

            // Overlapping card
            Positioned(
              top: 170,
              child: Container(
                height: 210,
                width: 220,
                decoration: BoxDecoration(
                  color: Color(0xFF8078C9)
,
                  borderRadius: BorderRadius.circular(26),
                 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
