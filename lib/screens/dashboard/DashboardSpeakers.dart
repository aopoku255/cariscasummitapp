import 'package:cbfapp/screens/dashboard/KeynoteSpeakers.dart';
import 'package:cbfapp/screens/dashboard/PanelJudges.dart';
import 'package:cbfapp/screens/dashboard/SessionPanelist.dart';
import 'package:cbfapp/theme/colors.dart';
import 'package:cbfapp/widgets/MainText.dart';
import 'package:flutter/material.dart';

class DashboardSpeakers extends StatefulWidget {
  const DashboardSpeakers({super.key});

  @override
  State<DashboardSpeakers> createState() => _DashboardSpeakersState();
}

class _DashboardSpeakersState extends State<DashboardSpeakers> {
  int selectedIndex = 0;

  final List<String> tabs = ["Speakers", "Panelist","Chairs"];
  final List<String> tabNames = ["Speakers", "Session Panelists","Session Chairs"];
  final  tabPages = [KeynoteSpeakers(), SessionPanelist(), PanelJudges()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
      centerTitle: true, title: MainText(text: tabNames[selectedIndex],),),
      body: SafeArea(
        child: KeynoteSpeakers(),
      ),
    );
  }
}
