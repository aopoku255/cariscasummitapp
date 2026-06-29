import 'package:cbfapp/widgets/Button.dart';
import 'package:cbfapp/widgets/MainText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;

  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: PageView.builder(
        itemCount: _pages.length,
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
        itemBuilder: (context, index) => OnboardingContent(
          image: _pages[index].image,
          title: _pages[index].title,
          description: _pages[index].description,
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        height: 410,
        child: Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(
                    _pages.length,
                    (index) => Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: DotIndicator(isActive: index == _pageIndex),
                        )),
                // MainText(text: "Skip")
              ],
            ),
            SizedBox(
              height: 20,
            ),
            MainText(
              text: _pages[_pageIndex].title,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColors.primaryColor,
            ),
            SizedBox(
              height: 20,
            ),
            MainText(text: _pages[_pageIndex].description),
            _pageIndex == 2
                ? Button(
                    label: "Proceed",
                    backgroundColor: AppColors.primaryColor,
                    onTap: () {
                      Navigator.pushNamed(context, "/login");
                    },
                  )
                : Button(
                    label: "Continue",
                    backgroundColor: AppColors.primaryGold,
                    hasIcon: true,
                    onTap: () {
                      _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                  ),
            SizedBox(
              height: 10,
            ),
            _pageIndex == 2
                ? Container()
                : TextButton(
                    onPressed: () {
                      _pageController.jumpToPage(_pages.length);
                    },
                    child: MainText(
                      text: "Skip",
                      color: AppColors.primaryColor,
                    ))
          ],
        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    this.isActive = false,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      width: isActive ? 30 : 10,
      decoration: BoxDecoration(
        color: AppColors.primaryGold,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }
}

class Onboard {
  final String image, title, description;
  Onboard(
      {required this.image, required this.title, required this.description});
}

final List<Onboard> _pages = [
  Onboard(
    image: "assets/images/onboarding1.jpg",
    title: "CARISCA'S 2026 Supply Chain Research Summit!",
    description:
        "Dive into groundbreaking research, connect with global scholars, and explore Africa’s academic pulse, right here in Nigeria. Let’s show you around.",
  ),
  Onboard(
    image: "assets/images/onboarding2.jpg",
    title: "Reimagining Africa's Supply Chains for a Sustainable Future",
    description:
        "Empowering local innovation, connecting communities, and driving green growth through smarter logistics and sustainable trade.",
  ),
  Onboard(
      image: "assets/images/onboarding3.jpg",
      title: "In-Person or Virtual, Connect with Supply Chain experts",
      description:
          "Seamlessly engage with industry leaders anytime, anywhere to exchange insights, solve challenges, and shape Africa’s supply chain future."),
];

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  final String image, title, description;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
    );
  }
}
