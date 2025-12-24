import 'package:flutter/material.dart';
import 'package:manage_x/core/constants/app_colors.dart';
import 'package:manage_x/core/widgets/custom_button.dart';
import 'package:manage_x/core/widgets/custom_design.dart';
import 'package:manage_x/core/widgets/spacing.dart';
import 'package:manage_x/core/widgets/typography/body_text.dart';
import 'package:manage_x/core/widgets/typography/page_title.dart';
import 'package:manage_x/features/auth/presentation/widgets/web_background.dart';

class PendingApprovalWeb extends StatelessWidget {
  const PendingApprovalWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body:   Stack(
        children: [
          const WebBackground(),  
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 550,
                maxWidth: 550,
                minHeight: 600,
                maxHeight: 600,
              ),
              child: Card(
                color: AppColors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 50, 32, 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                         AppPageTitle('Pending Request...'),
                       Icon(Icons.alarm, size: 300, color: AppColors.dottedGrey),

                                  AppBodyText("Admin Approval Is Pending...."),
                                  kheight10,
                                   Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.blue.shade200),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                                      kheight10,
                                      Expanded(
                                        child: Text(
                                         'Once Admin Approved your request you will be notified!...',
                                          style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                  kheight15,
                                  CustomButton(
                                    backgroundColor: AppColors.darkBlue,
                                    labelColor: AppColors.white,
                                    label: "Continue", 
                                    onPressed: () => Navigator.pop(context),
                                  ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
