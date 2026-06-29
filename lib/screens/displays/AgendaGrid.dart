import 'package:cbfapp/models/ongoing_model.dart';
import 'package:cbfapp/services/ongoing_service.dart';
import 'package:cbfapp/theme/colors.dart';
import 'package:cbfapp/widgets/MainText.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AgendaGrid extends StatefulWidget {
  final int dayIndex;
  const AgendaGrid({super.key, this.dayIndex = 0});

  @override
  State<AgendaGrid> createState() => _AgendaGridState();
}

class _AgendaGridState extends State<AgendaGrid> with TickerProviderStateMixin {
  late Future<ParallelSessionsResponse> _sessionsFuture;
  AnimationController? _animationController;
  Animation<double>? _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _sessionsFuture = ParallelSessionsService().fetchParallelSessions();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation =
        Tween<double>(begin: 0.6, end: 1.0).animate(_animationController!);
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ParallelSessionsResponse>(
      future: _sessionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: MainText(text: "Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
          return const Center(child: MainText(text: "No agenda found."));
        }

        final sessions = snapshot.data!.data;
        final uniqueDates = sessions
            .map((s) => _formatDate(s.session.date))
            .toSet()
            .toList()
          ..sort();

        final currentDate = uniqueDates.isNotEmpty
            ? uniqueDates[widget.dayIndex < 0
                ? 0
                : widget.dayIndex >= uniqueDates.length
                    ? uniqueDates.length - 1
                    : widget.dayIndex]
            : null;

        final filteredSessions = sessions.where((s) {
          if (currentDate == null) return true;
          final date = _formatDate(s.session.date);
          return date == currentDate;
        }).toList()
          ..sort((a, b) {
            final aDateTime = _getDateTime(a);
            final bDateTime = _getDateTime(b);
            return aDateTime.compareTo(bDateTime);
          });

        final Map<String, List<SessionData>> groupedSessions = {};
        for (var session in filteredSessions) {
          final id = session.session.id.toString();
          final date = _formatDate(session.session.date);
          final start = session.starttime;
          final end = session.endtime;
          final key = '$id|$date|$start-$end';
          groupedSessions.putIfAbsent(key, () => []).add(session);
        }

        if (groupedSessions.isEmpty) {
          return const Center(
              child: MainText(text: "No sessions found for this date."));
        }

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
          itemCount: groupedSessions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final entry = groupedSessions.entries.elementAt(index);
            final sessionGroup = entry.value;
            final first = sessionGroup.first;
            final title = first.name == "Parallel Session"
                ? first.session.name
                : first.name;
            final date = _formatDate(first.session.date);
            final timeRange =
                '${_formatTime(first.starttime)} - ${_formatTime(first.endtime)}';
            final speakerCount = first.speakers.length;
            final cardSubtitle =
                first.topic.isNotEmpty ? first.topic : first.session.name;
            final chips = <String>[];
            if (first.hall?.isNotEmpty == true) chips.add(first.hall!);
            if (first.sessionchair?.isNotEmpty == true)
              chips.add('Chair: ${first.sessionchair}');

            // Check if session is live or ended
            bool isLive = false;
            bool isEnded = false;
            {
              final now = DateTime.now();
              final startParts =
                  first.starttime.split(":").map(int.parse).toList();
              final endParts = first.endtime.split(":").map(int.parse).toList();
              final startDateTime = DateTime(
                first.session.date.year,
                first.session.date.month,
                first.session.date.day,
                startParts[0],
                startParts[1],
              );
              final endDateTime = DateTime(
                first.session.date.year,
                first.session.date.month,
                first.session.date.day,
                endParts[0],
                endParts[1],
              );
              isLive = now.isAfter(startDateTime) && now.isBefore(endDateTime);
              isEnded = now.isAfter(endDateTime);
            }

            return InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  "/program-details",
                  arguments: sessionGroup,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.08),
                      width: 1),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.primaryDeepBlue.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 6))
                  ],
                ),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: MainText(
                                text: date,
                                fontSize: 12,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (isLive && _pulseAnimation != null)
                          FadeTransition(
                            opacity: _pulseAnimation!,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.circle,
                                      color: Colors.white, size: 8),
                                  SizedBox(width: 4),
                                  Text(
                                    'LIVE',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (!isLive && isEnded)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.check_circle,
                                    color: Colors.white, size: 8),
                                SizedBox(width: 4),
                                Text(
                                  'ENDED',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _cleanSessionName(title),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cardSubtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded,
                            size: 14, color: AppColors.primaryGray),
                        const SizedBox(width: 6),
                        Expanded(
                          child: MainText(
                            text: timeRange,
                            fontSize: 12,
                            color: AppColors.primaryGray,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (sessionGroup.length > 1)
                            _buildPill('${sessionGroup.length} activities'),
                          if (speakerCount > 0) ...[
                            const SizedBox(width: 12),
                            _buildPill('$speakerCount speakers'),
                          ],
                          if (chips.isNotEmpty) ...[
                            const SizedBox(width: 12),
                            for (var chip in chips) ...[
                              _buildPill(chip),
                              const SizedBox(width: 6),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryDeepBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child:
          MainText(text: label, fontSize: 11, color: AppColors.primaryDeepBlue),
    );
  }

  DateTime _getDateTime(SessionData data) {
    final start = data.starttime.split(':');
    final hour = int.tryParse(start[0]) ?? 0;
    final minute = int.tryParse(start[1]) ?? 0;
    return DateTime(data.session.date.year, data.session.date.month,
        data.session.date.day, hour, minute);
  }

  String _formatDate(DateTime date) {
    return "${_getMonth(date.month)} ${date.day}";
  }

  String _getMonth(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month - 1];
  }

  String _formatTime(String time) {
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
}
