import 'package:cbfapp/widgets/MainText.dart';
import 'package:flutter/material.dart';

class SessionPanelist extends StatefulWidget {
  const SessionPanelist({super.key});

  @override
  State<SessionPanelist> createState() => _SessionPanelistState();
}

class _SessionPanelistState extends State<SessionPanelist> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _keynoteSpeakers = [
    {
      "name": "Kwame Mensah",
      "topic": "Innovating logistics in West Africa",
      "image": "assets/images/thomas.jpg",
      "work": "Lecturer, UG"
    },
    {
      "name": "Linda Zhang",
      "topic": "Digital transformation in procurement",
      "image": "assets/images/rogers.png",
      "work": "Supply Chain Expert"
    },
    {
      "name": "Dale Rogers",
      "topic": "The impact of supply chain on businesses",
      "image": "assets/images/rogers.png",
      "work": "Prof, ASU"
    },

    {
      "name": "Victor Owusu",
      "topic": "The role of policy in logistics development",
      "image": "assets/images/rogers.png",
      "work": "Policy Analyst, MoT"
    },
    {
      "name": "Emilia Kusi",
      "topic": "Post-COVID logistics resilience",
      "image": "assets/images/thomas.jpg",
      "work": "Researcher, CILT"
    },
    {
      "name": "Richard Agyapong",
      "topic": "Green logistics in Ghana",
      "image": "assets/images/rogers.png",
      "work": "Lecturer, KTU"
    },
    {
      "name": "Thomas Choi",
      "topic": "Global trade post-pandemic",
      "image": "assets/images/thomas.jpg",
      "work": "Prof, KNUST"
    },

    {
      "name": "Mohammed Alhassan",
      "topic": "Cross-border e-commerce trends",
      "image": "assets/images/rogers.png",
      "work": "CEO, TradeLink"
    },
    {
      "name": "Janet Addo",
      "topic": "Women in global logistics leadership",
      "image": "assets/images/thomas.jpg",
      "work": "Founder, SheShips"
    },
    {
      "name": "Ernest Boateng",
      "topic": "Blockchain in supply chain tracking",
      "image": "assets/images/thomas.jpg",
      "work": "CTO, FreightChain"
    },
    {
      "name": "Carla Mensimah",
      "topic": "Urban logistics and sustainable cities",
      "image": "assets/images/rogers.png",
      "work": "Planner, UrbanMove"
    },

    {
      "name": "Akosua Frempong",
      "topic": "AI's role in freight automation",
      "image": "assets/images/thomas.jpg",
      "work": "AI Strategist"
    },
    {
      "name": "Daniel Koranteng",
      "topic": "Last-mile delivery challenges",
      "image": "assets/images/rogers.png",
      "work": "CEO, SpeedX"
    },
    {
      "name": "Nana Serwaa",
      "topic": "Supply chain education for youth",
      "image": "assets/images/thomas.jpg",
      "work": "Education Advocate"
    },
    {
      "name": "Felix Osei",
      "topic": "Inventory control and cost savings",
      "image": "assets/images/rogers.png",
      "work": "Operations Manager, GLOM"
    },
  ];

  List<Map<String, String>> get _filteredSpeakers {
    if (_searchQuery.isEmpty) return _keynoteSpeakers;
    return _keynoteSpeakers
        .where((speaker) =>
    speaker["name"]!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        speaker["topic"]!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/background.png"), alignment: Alignment.topRight, opacity: 0.3, repeat: ImageRepeat.repeatY)),

      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search panelist speakers...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide.none),
              ),
            ),
          ),

          // Speaker list
          Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(_filteredSpeakers.length, (index) {
              final speaker = _filteredSpeakers[index];
              final name = speaker["name"]!;
              final topic = speaker["topic"]!;
              return InkWell(
                onTap: (){
                  Navigator.pushNamed(context, "/speaker-details", arguments: speaker);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(speaker["image"]!),
                  ),
                  title: MainText(text: name),
                  subtitle: MainText(text: topic),
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
