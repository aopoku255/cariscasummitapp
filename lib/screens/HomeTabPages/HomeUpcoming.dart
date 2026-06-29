import 'package:cbfapp/models/ongoing_model.dart';
import 'package:cbfapp/services/ongoing_service.dart';
import 'package:cbfapp/theme/colors.dart';
import 'package:cbfapp/widgets/MainText.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeUpcoming extends StatefulWidget {
  const HomeUpcoming({super.key});

  @override
  State<HomeUpcoming> createState() => _HomeUpcomingState();
}

class _HomeUpcomingState extends State<HomeUpcoming>
    with TickerProviderStateMixin {
  late Future<ParallelSessionsResponse> _sessionsFuture;
  late AnimationController _animationController;
  final ParallelSessionsService _service = ParallelSessionsService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _sessionsFuture = _service.fetchUpcomingSessions();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formatDate(String isoDateString) {
      final date = DateTime.parse(isoDateString);
      return DateFormat("MMM d").format(date);
    }

    return FutureBuilder<ParallelSessionsResponse>(
      future: _sessionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
          return const Center(
            child: MainText(
              text:
                  'No upcoming sessions for today. You can view agenda for full sessions',
              textAlign: TextAlign.center,
            ),
          );
        }

        final sessions = snapshot.data!.data;
        final Map<String, List<SessionData>> groupedSessions = {};
        for (var session in sessions) {
          final sessionId = session.session.id.toString();
          if (!groupedSessions.containsKey(sessionId)) {
            groupedSessions[sessionId] = [];
          }
          groupedSessions[sessionId]!.add(session);
        }

        final groupedList = groupedSessions.entries.toList();

        return SizedBox(
          height: 240,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(groupedList.length, (index) {
                return FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(index * 0.1, 1.0, curve: Curves.easeOut),
                  ),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.2, 0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(index * 0.1, 1.0, curve: Curves.easeOut),
                    )),
                    child: _buildSessionCard(groupedList[index], formatDate),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSessionCard(
      MapEntry<String, List<SessionData>> entry, Function(String) formatDate) {
    final sessionGroup = entry.value;
    final firstSession = sessionGroup[0];
    final sessionCount = sessionGroup.length;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/program-details",
          arguments: entry.value,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16, left: 4),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDeepBlue.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Gradient background with enhanced depth
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryDeepBlue.withValues(alpha: 0.9),
                    AppColors.primaryColor.withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),
            // Overlay for premium feel
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.white.withValues(alpha: 0.08),
                    Colors.black.withValues(alpha: 0.05),
                  ],
                ),
              ),
            ),
            // Coming soon badge
            Positioned(
              bottom: 12,
              right: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: MainText(
                  text: 'UPCOMING',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDeepBlue,
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time and date badges
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        child: MainText(
                          text:
                              formatDate(firstSession.session.date.toString()),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        child: MainText(
                          text:
                              "${_formatTime(firstSession.starttime)} - ${_formatTime(firstSession.endtime)}",
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Session type label
                  MainText(
                    text: firstSession.name,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  const SizedBox(height: 8),
                  // Topic/Title
                  Expanded(
                    child: MainText(
                      text: firstSession.topic,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Speaker avatars
                  if (firstSession.speakers.isNotEmpty)
                    SizedBox(
                      height: 32,
                      child: Stack(
                        children: List.generate(
                          firstSession.speakers.length > 2
                              ? 3
                              : firstSession.speakers.length,
                          (index) {
                            final showMore =
                                firstSession.speakers.length > 2 && index == 2;
                            return Positioned(
                              left: index * 20,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: showMore
                                    ? Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primaryColor,
                                        ),
                                        child: Center(
                                          child: MainText(
                                            text:
                                                '+${firstSession.speakers.length - 2}',
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : CircleAvatar(
                                        backgroundImage: AssetImage(
                                            firstSession.speakers[index].image),
                                        backgroundColor: Colors.grey[300],
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  // Sessions count if multiple
                  if (sessionCount > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                        ),
                      ),
                      child: MainText(
                        text: '$sessionCount Presentations',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
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
}
