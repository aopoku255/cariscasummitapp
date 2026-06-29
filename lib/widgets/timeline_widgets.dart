import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'MainText.dart';

/// Status badge for timeline events
enum EventStatus { upcoming, ongoing, completed }

/// Timeline Date Header Widget
class TimelineDateHeader extends StatelessWidget {
  final String date;
  final int eventCount;

  const TimelineDateHeader({
    super.key,
    required this.date,
    this.eventCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryDeepBlue,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDeepBlue.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                MainText(
                  text: date,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (eventCount > 0)
            MainText(
              text: '$eventCount event${eventCount > 1 ? 's' : ''}',
              fontSize: 12,
              color: AppColors.primaryGray,
            ),
        ],
      ),
    );
  }
}

/// Timeline Event Card Widget
class TimelineEventCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String startTime;
  final String endTime;
  final EventStatus status;
  final int activityCount;
  final int speakerCount;
  final String? location;
  final String? chair;
  final VoidCallback onTap;
  final bool isLast;

  const TimelineEventCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.activityCount = 0,
    this.speakerCount = 0,
    this.location,
    this.chair,
    required this.onTap,
    this.isLast = false,
  });

  Color get statusColor {
    switch (status) {
      case EventStatus.completed:
        return Colors.green;
      case EventStatus.ongoing:
        return Colors.orange;
      case EventStatus.upcoming:
        return AppColors.primaryColor;
    }
  }

  String get statusLabel {
    switch (status) {
      case EventStatus.completed:
        return 'Completed';
      case EventStatus.ongoing:
        return 'Ongoing';
      case EventStatus.upcoming:
        return 'Upcoming';
    }
  }

  IconData get statusIcon {
    switch (status) {
      case EventStatus.completed:
        return Icons.check_circle;
      case EventStatus.ongoing:
        return Icons.play_circle;
      case EventStatus.upcoming:
        return Icons.schedule;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 12, bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline dot with connecting line
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(statusIcon, color: Colors.white, size: 20),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 80,
                  color: AppColors.primaryColor.withOpacity(0.3),
                  margin: const EdgeInsets.only(top: 8),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Event Card Content
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryDeepBlue.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: MainText(
                        text: statusLabel,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Title
                    MainText(
                      text: title,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      MainText(
                        text: subtitle!,
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 10),
                    // Time
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 14, color: AppColors.primaryGray),
                        const SizedBox(width: 6),
                        MainText(
                          text: '$startTime - $endTime',
                          fontSize: 13,
                          color: AppColors.primaryGray,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Metadata chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (activityCount > 1) ...[
                            _buildChip('$activityCount activities'),
                            const SizedBox(width: 6),
                          ],
                          if (speakerCount > 0) ...[
                            _buildChip('$speakerCount speakers'),
                            const SizedBox(width: 6),
                          ],
                          if (location != null && location!.isNotEmpty) ...[
                            _buildChip(location!),
                            const SizedBox(width: 6),
                          ],
                          if (chair != null && chair!.isNotEmpty)
                            _buildChip('Chair: $chair'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryDeepBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: MainText(
        text: label,
        fontSize: 10,
        color: AppColors.primaryDeepBlue,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

/// Main Timeline Widget
class EventTimeline extends StatelessWidget {
  final List<Map<String, dynamic>> groupedEvents;
  final Function(int, dynamic) onEventTap;
  final ScrollController? scrollController;

  const EventTimeline({
    super.key,
    required this.groupedEvents,
    required this.onEventTap,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (groupedEvents.isEmpty) {
      return const Center(
        child: MainText(text: 'No events scheduled'),
      );
    }

    return Stack(
      children: [
        // Vertical timeline line
        Positioned(
          left: 24 + 20 - 1, // Center of the dot minus half line width
          top: 0,
          bottom: 0,
          child: Container(
            width: 2,
            color: AppColors.primaryColor.withOpacity(0.2),
          ),
        ),
        // Events list
        ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: groupedEvents.length,
          itemBuilder: (context, index) {
            final dateGroup = groupedEvents[index];
            final date = dateGroup['date'] as String;
            final events = dateGroup['events'] as List<dynamic>;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TimelineDateHeader(
                  date: date,
                  eventCount: events.length,
                ),
                ...List.generate(
                  events.length,
                  (eventIndex) {
                    final event = events[eventIndex];
                    final isLast = eventIndex == events.length - 1 &&
                        index == groupedEvents.length - 1;

                    return TimelineEventCard(
                      title: event['title'] ?? 'Untitled Event',
                      subtitle: event['subtitle'],
                      startTime: event['startTime'] ?? '--:--',
                      endTime: event['endTime'] ?? '--:--',
                      status: event['status'] ?? EventStatus.upcoming,
                      activityCount: event['activityCount'] ?? 0,
                      speakerCount: event['speakerCount'] ?? 0,
                      location: event['location'],
                      chair: event['chair'],
                      isLast: isLast,
                      onTap: () => onEventTap(index, event),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
