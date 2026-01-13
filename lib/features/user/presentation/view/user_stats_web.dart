import 'package:flutter/material.dart';
import 'package:manage_x/core/constants/app_colors.dart';
import 'package:manage_x/core/widgets/custom_design.dart';
import 'package:manage_x/core/widgets/spacing.dart';
import 'package:manage_x/features/user/presentation/widgets/syncfusion_chart.dart';

class UserStatsWeb extends StatelessWidget {
  const UserStatsWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(

        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 400,
                  width: 400,
                  child: SyncfusionBarChart(),
                  
                ),
                kwidth10,
                SizedBox(
                  height: 400,
                  width: 600,
                  child: Stack(
                  children: [
                  
                    Container(
                      height: 400,
                      width: 600,
                      
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                         gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                           Colors.pinkAccent ,
                                          const Color(0xFFE91E63)
                    
                    
                                      ])
                      ),
                    
                    ),
                    Container(
                     height: 100,
                      width: 600,                 
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color: const Color(0xFFFF8FB4),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                            blurRadius: 8,
                            color: Colors.pink
                          )
                        ]
                      ),
                    ),
                     Positioned(
                      top: 15,
                      left: 15,
                       child: Container(
                       height: 70,
                        width: 70,                 
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color:  const Color(0xFFFFC2E0),
                  
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                              blurRadius: 8,
                              color: const Color.fromARGB(255, 252, 143, 190)
                            )
                          ]
                        ),
                        child: Icon(Icons.schedule,color: AppColors.white,size: 50,),
                                       ),
                     ),
                       Positioned(
                      bottom: 0,
                               
                  
                      child: SizedBox(
                        height: 150,
                        width: 600,
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(30),
                          child: CustomWaveBackground()))),
                  ],
                              ),
                )
        
           
              ],
            ),
            kheight10,
            Stack(
              children: [
             
                Container(
                  height: 220,
                  width: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: AppColors.green,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        color: AppColors.lightGreyBackground
                      )
                    ]
                  ),
                ),
                   Positioned(
                  top: 30,
                  left: 160,
                  child: 
               CustomDotted()
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
