import 'dart:async';
import 'package:cbfapp/models/ongoing_model.dart';
import 'package:cbfapp/models/user_model.dart';
import 'package:cbfapp/screens/HomeTabPages/HomeOngoing.dart';
import 'package:cbfapp/screens/HomeTabPages/HomeUpcoming.dart';
import 'package:cbfapp/services/ongoing_service.dart';
import 'package:cbfapp/services/speaker_service.dart';
import 'package:cbfapp/theme/colors.dart';
import 'package:cbfapp/widgets/MainText.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardHome extends StatefulWidget {
  final Future<UserInfoModel>? userDetailsFuture;
  const DashboardHome({super.key, this.userDetailsFuture});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardSummaryData {
  final int agendaCount;
  final int speakerCount;

  const _DashboardSummaryData({
    required this.agendaCount,
    required this.speakerCount,
  });
}

class _DashboardHomeState extends State<DashboardHome> {
  int selectedIndex = 0;
  final List<String> tabs = ["Ongoing", "Upcoming"];
  late Future<_DashboardSummaryData> _summaryFuture;
  late Future<ParallelSessionsResponse> _upcomingFuture;

  Widget _homeStatCard(
      String title, String subtitle, IconData icon, Color accent) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDeepBlue.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainText(
                  text: title,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDeepBlue,
                  fontSize: 14,
                ),
                const SizedBox(height: 4),
                MainText(
                  text: subtitle,
                  fontSize: 12,
                  color: AppColors.primaryGray,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final tabPages = [HomeOngoing(), HomeUpcoming()];

  // Banner carousel
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> bannerImages = [
    "assets/images/thankyou.jpg",
    "assets/images/sponsors.jpg",
    "assets/images/partners.jpg",
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    _summaryFuture = _loadDashboardSummary();
    _upcomingFuture = ParallelSessionsService().fetchUpcomingSessions();
  }

  Future<_DashboardSummaryData> _loadDashboardSummary() async {
    final agendaResponse = await ParallelSessionsService().fetchParallelSessions();
    final speakerResponse = await SpeakerService().fetchSpeakers();

    return _DashboardSummaryData(
      agendaCount: agendaResponse.data.length,
      speakerCount: speakerResponse.data.length,
    );
  }

  String _formatTime(String time) {
    try {
      final parsedTime = DateFormat("HH:mm").parse(time);
      return DateFormat("hh:mm a").format(parsedTime);
    } catch (e) {
      return time;
    }
  }

  void _startAutoScroll() {
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % bannerImages.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserInfoModel>(
      future: widget.userDetailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(
            body: Center(child: Text('No user data found.')),
          );
        }

        final userDetails = snapshot.data!.data;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/profile",
                    arguments: userDetails);
              },
              child: Container(
                margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  backgroundImage: const AssetImage("assets/images/user.jpg"),
                ),
              ),
            ),
            centerTitle: true,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MainText(
                  text: "Welcome back",
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryGray,
                  fontSize: 12,
                ),
                const SizedBox(height: 2),
                MainText(
                  text: userDetails.firstName,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDeepBlue,
                  fontSize: 18,
                ),
              ],
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/announcement");
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 14),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      Image.asset("assets/images/megaphone.png", scale: 1.15),
                ),
              )
            ],
          ),
          backgroundColor: AppColors.primaryBackground,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background.png"),
                    alignment: Alignment.bottomCenter,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
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
                            color: AppColors.primaryDeepBlue
                                .withValues(alpha: 0.18),
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MainText(
                                  text: "Make the most of your forum day",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 8),
                                MainText(
                                  text:
                                      "Stay on top of sessions, announcements, and the latest updates in one place.",
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.calendar_today_rounded,
                                color: Colors.white, size: 22),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    FutureBuilder<_DashboardSummaryData>(
                      future: _summaryFuture,
                      builder: (context, summarySnapshot) {
                        final agendaCount = summarySnapshot.data?.agendaCount ?? 0;
                        final speakerCount = summarySnapshot.data?.speakerCount ?? 0;
                        final agendaLabel = summarySnapshot.connectionState ==
                                ConnectionState.waiting
                            ? 'Loading...'
                            : summarySnapshot.hasError
                                ? 'Unavailable'
                                : '$agendaCount ${agendaCount == 1 ? 'session' : 'sessions'}';
                        final speakerLabel = summarySnapshot.connectionState ==
                                ConnectionState.waiting
                            ? 'Loading...'
                            : summarySnapshot.hasError
                                ? 'Unavailable'
                                : '$speakerCount ${speakerCount == 1 ? 'expert' : 'experts'}';

                        return Row(
                          children: [
                            Expanded(
                              child: _homeStatCard(
                                "Agenda",
                                agendaLabel,
                                Icons.schedule_rounded,
                                AppColors.primaryGold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _homeStatCard(
                                "Speakers",
                                speakerLabel,
                                Icons.people_alt_rounded,
                                AppColors.primaryColor,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryDeepBlue
                                .withValues(alpha: 0.08),
                            blurRadius: 14,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              MainText(
                                text: "Featured highlights",
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: AppColors.primaryDeepBlue,
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: MainText(
                                  text: "Live",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 180,
                            width: double.infinity,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: bannerImages.length,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentPage = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryDeepBlue
                                            .withValues(alpha: 0.08),
                                        blurRadius: 10,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Image.asset(
                                      bannerImages[index],
                                      fit: BoxFit.contain,
                                      width: double.infinity,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                List.generate(bannerImages.length, (index) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: _currentPage == index ? 18 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(99),
                                  color: _currentPage == index
                                      ? AppColors.primaryColor
                                      : AppColors.primaryGray
                                          .withValues(alpha: 0.35),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    FutureBuilder<ParallelSessionsResponse>(
                      future: _upcomingFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryDeepBlue
                                      .withValues(alpha: 0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (snapshot.hasError || !snapshot.hasData ||
                            snapshot.data!.data.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryDeepBlue
                                      .withValues(alpha: 0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    MainText(
                                      text: "Your upcoming activity",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: AppColors.primaryDeepBlue,
                                    ),
                                    const Spacer(),
                                    Icon(Icons.arrow_forward_ios_rounded,
                                        size: 14, color: AppColors.primaryColor),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                MainText(
                                  text: "No upcoming sessions",
                                  fontSize: 12,
                                  color: AppColors.primaryGray,
                                ),
                              ],
                            ),
                          );
                        }

                        final firstSession = snapshot.data!.data[0];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryDeepBlue
                                    .withValues(alpha: 0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  MainText(
                                    text: "Your upcoming activity",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: AppColors.primaryDeepBlue,
                                  ),
                                  const Spacer(),
                                  Icon(Icons.arrow_forward_ios_rounded,
                                      size: 14, color: AppColors.primaryColor),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBackground,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: AppColors.primaryColor
                                          .withValues(alpha: 0.18)),
                                ),
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor
                                            .withValues(alpha: 0.13),
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                      child: const Icon(
                                          Icons.emoji_events_rounded,
                                          color: AppColors.primaryColor),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MainText(
                                            text: firstSession.topic,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primaryDeepBlue,
                                          ),
                                          const SizedBox(height: 4),
                                          MainText(
                                            text:
                                                "${firstSession.name} • ${_formatTime(firstSession.starttime)}",
                                            fontSize: 12,
                                            color: AppColors.primaryGray,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                            color:
                                AppColors.primaryColor.withValues(alpha: 0.18)),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryDeepBlue
                                .withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: List.generate(tabs.length, (index) {
                          final bool isSelected = selectedIndex == index;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Center(
                                  child: MainText(
                                    text: tabs[index],
                                    fontWeight: FontWeight.w700,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.primaryDeepBlue,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 18),
                    tabPages[selectedIndex],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
