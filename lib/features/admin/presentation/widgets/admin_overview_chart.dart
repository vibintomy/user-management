import 'package:flutter/material.dart';
import 'package:manage_x/core/constants/app_colors.dart';
import 'package:manage_x/core/widgets/custom_design.dart';
import 'package:manage_x/core/widgets/spacing.dart';
import 'package:manage_x/core/widgets/typography/page_title.dart';

class AdminOverviewChart extends StatelessWidget {
  const AdminOverviewChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
         
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
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
                     boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 5,
                                spreadRadius: 0,
                                color: Color.fromARGB(255, 21, 8, 117),
                                
                              )
                              
                            ]
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
                      boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 8),
                                blurRadius: 12,
                                spreadRadius: -10,
                                color: Color.fromARGB(255, 21, 8, 117),
                                
                              )
                              
                            ]
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        kwidth20,
        Column(
          children: [
            Stack(
              children: [
                Container(
                   width: 400,
                  height: 150,
                   decoration:  BoxDecoration(
                            color: Color(0xFF5F52A6) ,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                  Color(0xFF5F52A6) ,
                                  Color(0xFF8078C9)
                              ])
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child: Align(
                              alignment: AlignmentGeometry.centerRight,
                              child: AppPageTitle("${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}", AppColors.white)),
                          ),
                ),
                Positioned(
                  top: 40,
                  left: 40,
                  child: Container(
                    height: 70,
                    width: 70,
                
                      decoration:  BoxDecoration(
                             color:  Color(0xFF8078C9),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 5,
                                spreadRadius: 0,
                                color: Color.fromARGB(255, 21, 8, 117),
                                
                              )
                              
                            ]
                          ),
                          child: Icon(Icons.calendar_month,color: AppColors.white,size: 50,),
                          
                  ))
              ],
            ),
            kheight20,
            Stack(
              children: [
              
                Container(
                  height: 228,
                  width: 400,
                  
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
                  width: 400,                 
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
                    width: 400,
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(30),
                      child: CustomWaveBackground()))),
              ],
            )
          ],
          
        )
      ],
    );
  }
}
