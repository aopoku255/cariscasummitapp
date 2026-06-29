import 'package:cbfapp/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HowToLogin extends StatelessWidget {
  const HowToLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        backgroundColor: AppColors.primaryDeepBlue,
        titleTextStyle: const TextStyle(color: Colors.white),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: Center(
                child: Text(
                  "How to Log In",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Welcome to CARISCA BUSINESS FORUM 2026 Mobile App! Use our app, updated live, to plan and organize your conference experience and to connect with the CARISCA community",
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Be sure to Log In to access All features of the app             ",
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "1. Select the three dashes on the top right, tap the Login option",
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "2. Under \"EMAIL ADDRESS,\" enter the email address you used when registering.",
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "3. Under \"PASSWORD,\" enter your last name, with proper capitalization as this field is case sensitive. Examples include: Andrews, O'Connor, Benjamin Boven, etc. Type the apostrophe. Type the space. Capitalize the letters as appropriate.",
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Congratulations, you're logged in and set to use the CBF app to its fullest!",
              textAlign: TextAlign.left,
            ),

            // SizedBox(child: Text("Be sure to Log In to access All features of the app"),)
          ],
        ),
      ),
    );
  }
}
