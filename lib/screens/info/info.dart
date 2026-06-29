import 'package:cbfapp/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Info"),
        backgroundColor: AppColors.primaryDeepBlue,
        titleTextStyle: const TextStyle(color: Colors.white),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Description",
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                  "CARISCA's Supply Chain Business Forum & Exhibition brings together the finest minds in supply chain to deliver 100+ quality,educational and specialty sessions with unbiased content and intelligence gathering opportunities spanning the end-to-end supply chain. At the Business Forum you'll curate your own unique agenda and return home with practical strategies and concept to invigorate and establish your profession and organization in the marketplace."),
              SizedBox(
                height: 20,
              ),
              Text(
                  "From the opening keynote to the closing session, and everything in-between,world-renowned and experts, industry leaders, and visionary thinkers will inspire and entertain with new ideas and insights on topics that influence today's supply chain."),
              SizedBox(
                height: 20,
              ),
              Text(
                  "Experince supply chain's premier event and make conections to accelerate your success alongside your global network this April at Accra, Fiesta Royale Hotel."),
              SizedBox(
                height: 40,
              ),
              Text(
                "Calendar",
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              ListTile(
                title: Text("Add To Calendar"),
                trailing: Icon(Icons.calendar_month, color: Colors.blueAccent,),
              ),
              Text(
                "Contact",
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              ListTile(
                title: Text("www.cariscabusinessforum.com"),
                trailing: Icon(Icons.wifi, color: Colors.blueAccent,),
              ),
              Divider(),
              ListTile(
                title: Text("info@cariscabusinessforum.com"),
                trailing: Icon(Icons.email, color: Colors.blueAccent,),
              ),

              Text(
                "Travel Info",
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              ListTile(
                title: Text("Navigate"),
                trailing: Icon(Icons.navigation_sharp, color: Colors.blueAccent,),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
