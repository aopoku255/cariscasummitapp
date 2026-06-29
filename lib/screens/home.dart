import 'package:cbfapp/widgets/HeaderText.dart';
import 'package:cbfapp/widgets/MainText.dart';
import 'package:cbfapp/widgets/OvalIcon.dart';
import 'package:cbfapp/widgets/SessionCards.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedChipIndex = 0; // Track selected chip index
  final String name = "Andrews";
  final String title =
      "Reimagining Africa’s Supply Chains for a Sustainable Future";
  final List<String> _chipLabels = [
    "Today",
    "Keynote",
    "Speakers",
    "Sponsors",
    "Exhibitors"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: OvalIcon(icon: Icons.notifications_outlined),
        ),
        actions: [
          const OvalIcon(icon: Icons.more_vert),
          const SizedBox(width: 10),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey.withOpacity(0.75), // First color
              Colors.grey.withOpacity(0.5) // First color
              // AppColors.primaryRed, // Second color
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MainText(text: "Good day! ${name}"),
                  const SizedBox(height: 20),
                  HeaderText(text: title),

                  // Chips Row
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(_chipLabels.length, (index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedChipIndex =
                                      index; // Update selected index
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 20),
                                width: 120,
                                height: 34,
                                decoration: BoxDecoration(
                                    color: index == _selectedChipIndex
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Center(
                                    child: MainText(
                                  text: _chipLabels[index],
                                  color: index == _selectedChipIndex
                                      ? Colors.black
                                      : Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                )),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  _selectedChipIndex >= 1
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MainText(
                              text: "Keynote Speakers",
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            SessionCard(
                                image: "assets/images/rogers.png",
                                sessionTitle: "Dale Rogers",
                                startTime: "",
                                description:
                                    "Dale S. Rogers is the ON Semiconductor Professor of Business at the Supply Chain Management department at Arizona State University. He is also the director of the Frontier Economies Logistics Lab and the co-director of the Internet Edge Supply Chain Lab at ASU."),
                            SessionCard(
                                image: "assets/images/thomas.jpg",
                                sessionTitle: "Thomas Choi",
                                startTime: "",
                                description:
                                    "Thomas Choi is a Professor of Supply Chain Management at the W. P. Carey School of Business at Arizona State University. He leads the study of the upstream side of supply chains, where a buying company interfaces with many suppliers organized in various forms of networks.")
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const MainText(
                                text: "Ongoing Session",
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                            SessionCard(
                              image: "assets/images/registration.jpg",
                              sessionTitle: "Registration",
                              startTime: "8:30am",
                              description:
                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                            ),
                            const SizedBox(height: 40),
                            MainText(
                                text: "Upcoming Sessions",
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                            SessionCard(
                              image: "assets/images/ongoing.jpg",
                              sessionTitle: "Panel Discussion",
                              startTime: "10:30am",
                              description:
                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                            ),
                            SessionCard(
                              image: "assets/images/dancing.jpg",
                              sessionTitle: "Cultural Dance",
                              startTime: "12:30pm",
                              description:
                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                            ),
                          ],
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
