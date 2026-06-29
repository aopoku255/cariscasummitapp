import 'package:flutter/material.dart';

import '../../../models/user_model.dart';
import '../../../theme/colors.dart';
import '../../displays/AgendaGrid.dart';
import '../../displays/AgendaList.dart';

class Day1 extends StatefulWidget {
  final Future<UserInfoModel>? userDetailsFuture;
  const Day1({super.key, this.userDetailsFuture});

  @override
  State<Day1> createState() => _Day1State();
}

class _Day1State extends State<Day1> {
  int selectedIndex = 0;

  final List<IconData> tabs = [Icons.list_rounded, Icons.grid_view_rounded];
  final List<String> tabText = ["List", "Grid"];
  final tabPages = [AgendaList(dayIndex: 0), AgendaGrid(dayIndex: 0)];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: AppColors.primaryDeepBlue.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Row(
                  children: List.generate(tabs.length, (index) {
                    final bool isSelected = selectedIndex == index;
                    return InkWell(
                      onTap: () => setState(() => selectedIndex = index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(tabs[index], color: isSelected ? Colors.white : AppColors.primaryGray, size: 18),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        Expanded(child: tabPages[selectedIndex]),
      ],
    );
  }
}
