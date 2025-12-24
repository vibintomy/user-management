import 'package:flutter/material.dart';
import 'package:manage_x/core/constants/app_colors.dart';
import 'package:manage_x/core/widgets/custom_button.dart';
import 'package:manage_x/core/widgets/spacing.dart';
import 'package:manage_x/core/widgets/typography/body_text.dart';


class PendingApprovalMobile extends StatelessWidget {
  const PendingApprovalMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Icon(Icons.alarm, size: 300, color: AppColors.dottedGrey)),
            Center(child: AppBodyText("Admin Approval Is Pending....")),
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
    );
  }
}
