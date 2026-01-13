import 'package:flutter/material.dart';
import 'package:manage_x/core/constants/app_colors.dart';
import 'package:manage_x/core/widgets/spacing.dart';

class LeadHomescreenWeb extends StatefulWidget {
  const LeadHomescreenWeb({super.key});

  @override
  State<LeadHomescreenWeb> createState() => _LeadHomescreenWebState();
}

class _LeadHomescreenWebState extends State<LeadHomescreenWeb> {
  String selectFilter = 'today';
  bool showFilter = false;

  @override
  Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(60),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hi 👋\nvibin',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    wordSpacing: 10,
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                    kwidth15,
                    ClipOval(
                      child: Container(
                        color: Colors.grey,
                        height: 50,
                        width: 50,
                        child: Center(
                          child: Text(
                            'V',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            kheight10,

            SizedBox(
              height: 60,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  /// 🔹 Centered Choice Chips
                  if (showFilter)
                    Center(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          chipTheme: Theme.of(
                            context,
                          ).chipTheme.copyWith(checkmarkColor: AppColors.white),
                        ),
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildChip('all', 'All'),
                            _buildChip('today', 'Today'),
                            _buildChip('current_month', 'Current Month'),
                            _buildChip('last_month', 'Last Month'),
                          ],
                        ),
                      ),
                    ),

                  /// 🔹 Filter Icon on Right
                  Positioned(
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          showFilter = !showFilter;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.darkBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.filter_list,
                          color: AppColors.darkBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            kheight15,
            Stack(
              children: [
                Container(
                  height: 157,
                  width: 700,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                Positioned(
                  top: 1,
                  left: 1,
                  child: Container(
                    height: 155,
                    width: 695,
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Todo App Development',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: AppColors.black,
                                    wordSpacing: 15,
                                  ),
                                ),
                              ),
                              Icon(Icons.more_vert),
                            ],
                          ),
                          kheight15,
                          Container(
                            height: 30,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              color: Colors.redAccent,
                            ),
                            child: Center(
                              child: Text(
                                'High',
                                style: TextStyle(color: AppColors.white),
                              ),
                            ),
                          ),
                          kheight10,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.calendar_month),
                                  Text(DateTime.now().toString()),
                                ],
                              ),
                              SizedBox(
                                width: 100,
                                child: Stack(
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        color: AppColors.gold,
                                        child: Center(
                                          child: Text(
                                            'A',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                              color: AppColors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      left: 25,
                                      child: ClipOval(
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          color: AppColors.blue,
                                          child: Center(
                                            child: Text(
                                              'A',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                                color: AppColors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      left: 50,
                                      child: ClipOval(
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          color: AppColors.dottedGrey,
                                          child: Center(
                                            child: Text(
                                              '+1',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                                color: AppColors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
     ChoiceChip _buildChip(String value, String label) {
      final isSelected = selectFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: selectFilter == value,

      selectedColor: AppColors.darkBlue,
        labelStyle: TextStyle(
      color: isSelected ? AppColors.white : AppColors.black,
      fontWeight: FontWeight.w500,
    ),
      onSelected: (_) {
        setState(() {
          selectFilter = value;
        });
      },
    );
  }
  }
   

