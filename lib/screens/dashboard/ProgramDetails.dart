import 'package:cbfapp/models/ongoing_model.dart';
import 'package:cbfapp/theme/colors.dart';
import 'package:cbfapp/widgets/MainText.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ProgramDetails extends StatefulWidget {
  const ProgramDetails({super.key});

  @override
  State<ProgramDetails> createState() => _ProgramDetailsState();
}

class _ProgramDetailsState extends State<ProgramDetails>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation =
        Tween<double>(begin: 0.5, end: 1.0).animate(_pulseController);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessions =
        ModalRoute.of(context)!.settings.arguments as List<SessionData>;
    final firstSession = sessions.first;

    return Scaffold(
      appBar: AppBar(
        title: MainText(text: firstSession.name, color: Colors.white),
        centerTitle: true,
        backgroundColor: AppColors.primaryDeepBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: AppColors.primaryBackground,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final session = sessions[index];
            return _buildSessionCard(session, index);
          },
        ),
      ),
    );
  }

  Widget _buildSessionCard(SessionData session, int index) {
    final speakerNames =
        session.speakers.map((s) => "${s.fname} ${s.lname}").join(", ");

    bool isLive = false;
    bool isEnded = false;

    {
      final now = DateTime.now();
      final sessionDate = DateTime.parse(session.session.date.toString());
      final startParts = session.starttime.split(":").map(int.parse).toList();
      final endParts = session.endtime.split(":").map(int.parse).toList();

      final startDateTime = DateTime(sessionDate.year, sessionDate.month,
          sessionDate.day, startParts[0], startParts[1]);
      final endDateTime = DateTime(sessionDate.year, sessionDate.month,
          sessionDate.day, endParts[0], endParts[1]);

      isLive = now.isAfter(startDateTime) && now.isBefore(endDateTime);
      isEnded = now.isAfter(endDateTime);
    }

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _fadeController,
          curve: Interval(
            (index * 0.15).clamp(0.0, 1.0),
            ((index * 0.15) + 0.5).clamp(0.0, 1.0),
            curve: Curves.easeOut,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDeepBlue.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with gradient background
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryDeepBlue,
                    AppColors.primaryDeepBlue.withOpacity(0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Topic with better hierarchy
                  MainText(
                    text: session.topic,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // Session name
                  MainText(
                    text: session.name == "Parallel Session"
                        ? _cleanSessionName(session.session.name)
                        : session.name,
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 12),
                  // Status badge
                  Row(
                    children: [
                      _buildStatusBadge(isLive, isEnded),
                    ],
                  ),
                ],
              ),
            ),
            // Content section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time with icon
                  _buildInfoRow(
                    Icons.schedule_rounded,
                    "${_formatTime(session.starttime)} - ${_formatTime(session.endtime)}",
                    AppColors.primaryColor,
                  ),
                  const SizedBox(height: 14),
                  // Speakers
                  if (speakerNames.isNotEmpty) ...[
                    _buildInfoRow(
                      Icons.person_rounded,
                      speakerNames,
                      AppColors.primaryColor,
                    ),
                    const SizedBox(height: 14),
                  ],
                  // Location
                  if (session.hall != null && session.hall!.isNotEmpty) ...[
                    _buildInfoRow(
                      Icons.location_on_rounded,
                      session.hall!,
                      AppColors.primaryDeepBlue,
                    ),
                    const SizedBox(height: 14),
                  ],
                  // Chair info
                  if (session.sessionchair != null &&
                      session.sessionchair!.isNotEmpty) ...[
                    _buildInfoRow(
                      Icons.info_rounded,
                      "Chair: ${session.sessionchair}",
                      AppColors.primaryDeepBlue,
                    ),
                    const SizedBox(height: 14),
                  ],
                  // Zoom button
                  if (isLive &&
                      session.zoomlink != null &&
                      session.zoomlink!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    SizedBox(
                      width: double.infinity,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => launchUrlIfPossible(session.zoomlink!),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primaryColor,
                                  AppColors.primaryColor.withOpacity(0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.video_call_rounded,
                                    color: Colors.white, size: 22),
                                const SizedBox(width: 10),
                                MainText(
                                  text: "Join Zoom",
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isLive, bool isEnded) {
    if (isLive) {
      return FadeTransition(
        opacity: _pulseAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.green, width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.live_tv_rounded, color: Colors.green, size: 14),
              SizedBox(width: 6),
              Text(
                'LIVE NOW',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (isEnded) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.check_circle_rounded, color: Colors.grey, size: 14),
            SizedBox(width: 6),
            Text(
              'COMPLETED',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primaryColor, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.schedule_rounded,
                color: AppColors.primaryColor, size: 14),
            SizedBox(width: 6),
            Text(
              'UPCOMING',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildInfoRow(IconData icon, String text, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: MainText(
            text: text,
            fontSize: 14,
            color: Colors.grey.shade800,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatTime(String? time) {
    if (time == null) return '';
    try {
      final parsedTime = DateFormat("HH:mm").parse(time);
      return DateFormat("hh:mm a").format(parsedTime);
    } catch (e) {
      return time;
    }
  }

  String _cleanSessionName(String name) {
    final cleaned =
        name.replaceAll(RegExp(r'\bDay\s*\d+\b', caseSensitive: false), '');
    return cleaned.replaceAll(RegExp(r'\s{2,}'), ' ').trim();
  }

  Future<void> launchUrlIfPossible(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }
}
