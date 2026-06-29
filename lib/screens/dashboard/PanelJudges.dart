import 'package:cbfapp/widgets/MainText.dart';
import 'package:flutter/cupertino.dart';

class PanelJudges extends StatefulWidget {
  const PanelJudges({super.key});

  @override
  State<PanelJudges> createState() => _PanelJudgesState();
}

class _PanelJudgesState extends State<PanelJudges> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: MainText(text: "Panel Judges"),);
  }
}
