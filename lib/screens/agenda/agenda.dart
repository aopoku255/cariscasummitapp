import 'package:cbfapp/theme/colors.dart';
import 'package:flutter/material.dart';

class Agenda extends StatefulWidget {
  const Agenda({super.key});

  @override
  _AgendaState createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  // Function to launch a URL
  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agenda"),
        backgroundColor: AppColors.primaryDeepBlue,
        titleTextStyle: const TextStyle(color: Colors.white),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: const Center(
        // child: Text("Opening URL..."),
      ),
    );
  }
}
