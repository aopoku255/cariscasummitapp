import 'package:cbfapp/models/speakers_model.dart';
import 'package:cbfapp/theme/colors.dart';
import 'package:cbfapp/widgets/MainText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class SpeakerDetails extends StatefulWidget {
  const SpeakerDetails({super.key});

  @override
  State<SpeakerDetails> createState() => _SpeakerDetailsState();
}

class _SpeakerDetailsState extends State<SpeakerDetails>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  // Helper to launch LinkedIn URL
  Future<void> _launchLinkedIn(String linkedinUrl) async {
    final url = Uri.parse(linkedinUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final speaker = ModalRoute.of(context)!.settings.arguments as SpeakerModel;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: MainText(
          text: "${speaker.fname} ${speaker.lname}",
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryDeepBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hero Section with Profile
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryDeepBlue,
                      AppColors.primaryDeepBlue.withOpacity(0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    // Avatar with modern styling
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryDeepBlue.withOpacity(0.4),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: (speaker.image != null &&
                                speaker.image!.isNotEmpty)
                            ? Image.network(
                                "https://summitapi.cariscabusinessforum.com${speaker.image}",
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: AppColors.primaryColor,
                                    child: Center(
                                      child: MainText(
                                        text: speaker.fname.isNotEmpty == true
                                            ? speaker.fname[0]
                                            : "?",
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: AppColors.primaryColor,
                                child: Center(
                                  child: MainText(
                                    text: speaker.fname.isNotEmpty == true
                                        ? speaker.fname[0]
                                        : "?",
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Speaker Name
                    MainText(
                      text: "${speaker.fname} ${speaker.lname}",
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      textAlign: TextAlign.center,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    // Company with icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.business_rounded,
                            color: Colors.white70, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: MainText(
                            text: speaker.company,
                            fontSize: 15,
                            color: Colors.white70,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Content Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // LinkedIn Button
                    if (speaker.linkedin != null &&
                        speaker.linkedin!.isNotEmpty) ...[
                      Material(
                        child: InkWell(
                          onTap: () => _launchLinkedIn(speaker.linkedin!),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF0A66C2),
                                  const Color(0xFF0A66C2).withOpacity(0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF0A66C2).withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.language_rounded,
                                    color: Colors.white, size: 22),
                                const SizedBox(width: 12),
                                MainText(
                                  text: "Connect on LinkedIn",
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    // Bio Card
                    if (speaker.bio.isNotEmpty) ...[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.primaryDeepBlue.withOpacity(0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor
                                        .withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.info_rounded,
                                    color: AppColors.primaryColor,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                MainText(
                                  text: "About Speaker",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryDeepBlue,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              height: 2,
                              width: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primaryColor,
                                    AppColors.primaryColor.withOpacity(0.3),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Html(
                              data: speaker.bio,
                              style: {
                                "body": Style(
                                  fontSize: FontSize(14),
                                  color: Colors.grey.shade700,
                                  lineHeight: LineHeight.number(1.6),
                                ),
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    // Sessions Card
                    if (speaker.parallelSessions.isNotEmpty) ...[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.primaryDeepBlue.withOpacity(0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryDeepBlue
                                        .withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.event_rounded,
                                    color: AppColors.primaryDeepBlue,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                MainText(
                                  text: "Sessions",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryDeepBlue,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              height: 2,
                              width: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primaryDeepBlue,
                                    AppColors.primaryDeepBlue.withOpacity(0.3),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Column(
                              children: List.generate(
                                speaker.parallelSessions.length,
                                (index) {
                                  final session =
                                      speaker.parallelSessions[index];
                                  final isLast = index ==
                                      speaker.parallelSessions.length - 1;
                                  return Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          border: Border.all(
                                            color: AppColors.primaryDeepBlue
                                                .withOpacity(0.1),
                                            width: 1,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            MainText(
                                              text: session.topic,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.primaryDeepBlue,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: AppColors
                                                        .primaryColor
                                                        .withOpacity(
                                                      0.15,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      8,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .access_time_rounded,
                                                        size: 14,
                                                        color: AppColors
                                                            .primaryColor,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      MainText(
                                                        text:
                                                            "${session.startTime} - ${session.endTime}",
                                                        fontSize: 12,
                                                        color: AppColors
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (!isLast)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12.0,
                                          ),
                                          child: Divider(
                                            height: 1,
                                            thickness: 0.8,
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.primaryDeepBlue.withOpacity(0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.event_rounded,
                                color: Colors.grey,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            MainText(
                              text: "No sessions scheduled",
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
