import 'package:flutter/material.dart';
import 'package:manage_x/features/admin/presentation/widgets/admin_overview_chart.dart';

class AdminHomeScreenWeb extends StatelessWidget {
  const AdminHomeScreenWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(45.0),
      child: Column(children: [
      AdminOverviewChart()
      
      ]),
    );
  }
}
