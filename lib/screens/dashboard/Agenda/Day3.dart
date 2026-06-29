import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../displays/AgendaGrid.dart';
import '../../displays/AgendaList.dart';

class Day3 extends StatefulWidget {
  const Day3({super.key});

  @override
  State<Day3> createState() => _Day3State();
}

class _Day3State extends State<Day3> {
  int selectedIndex = 0;

  final List<IconData> tabs = [Icons.list_rounded, Icons.grid_view_rounded];
  final List<String> tabText = ["List", "Grid"];
  final tabPages = [AgendaList(dayIndex: 2), AgendaGrid(dayIndex: 2)];

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
