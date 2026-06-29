import 'package:cbfapp/screens/dashboard/Agenda/Day2.dart';
import 'package:cbfapp/screens/dashboard/Agenda/Day3.dart';
import 'package:cbfapp/theme/colors.dart';
import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../widgets/MainText.dart';
import 'Agenda/Day1.dart';

class DashboardAgenda extends StatefulWidget {
  final Future<UserInfoModel>? userDetailsFuture;
  const DashboardAgenda({super.key, this.userDetailsFuture});

  @override
  State<DashboardAgenda> createState() => _DashboardAgendaState();
}

class _DashboardAgendaState extends State<DashboardAgenda> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: MainText(
              text: "Agenda",
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: AppColors.primaryDeepBlue),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(160),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.primaryDeepBlue,
                          AppColors.primaryColor
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 8))
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MainText(
                                  text: "Schedule your day",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.white),
                              const SizedBox(height: 6),
                              MainText(
                                  text:
                                      "Explore keynotes, sessions, and networking moments",
                                  fontSize: 12,
                                  color: Colors.white70),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.16),
                              borderRadius: BorderRadius.circular(14)),
                          child: const Icon(Icons.event_outlined,
                              color: Colors.white, size: 22),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 14),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.primaryDeepBlue.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 6))
                      ],
                    ),
                    child: TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: AppColors.primaryDeepBlue,
                      indicator: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14),
                      tabs: const [
                        Tab(text: "Day 1"),
                        Tab(text: "Day 2"),
                        Tab(text: "Day 3"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [Day1(), Day2(), Day3()],
        ),
      ),
    );
  }
}
