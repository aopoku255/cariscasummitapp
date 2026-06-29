import 'package:cbfapp/models/ongoing_model.dart';
import 'package:cbfapp/services/ongoing_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../widgets/MainText.dart';
import '../../widgets/timeline_widgets.dart';

class AgendaList extends StatefulWidget {
  final int dayIndex;
  const AgendaList({super.key, this.dayIndex = 0});

  @override
  State<AgendaList> createState() => _AgendaListState();
}

class _AgendaListState extends State<AgendaList> with TickerProviderStateMixin {
  late Future<ParallelSessionsResponse> _sessionsFuture;

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _sessionsFuture = ParallelSessionsService().fetchParallelSessions();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
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
            .map((s) => _formatDate(DateTime.parse(s.session.date.toString())))
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
          if (currentDate == null) {
            return true;
          }
          final date = _formatDate(DateTime.parse(s.session.date.toString()));
          return date == currentDate;
        }).toList()
          ..sort((a, b) {
            final aDate = DateTime.parse(a.session.date.toString());
            final bDate = DateTime.parse(b.session.date.toString());

            final aTime = TimeOfDay(
              hour: int.parse(a.starttime.split(':')[0]),
              minute: int.parse(a.starttime.split(':')[1]),
            );

            final bTime = TimeOfDay(
              hour: int.parse(b.starttime.split(':')[0]),
              minute: int.parse(b.starttime.split(':')[1]),
            );

            final aDateTime = DateTime(
                aDate.year, aDate.month, aDate.day, aTime.hour, aTime.minute);

            final bDateTime = DateTime(
                bDate.year, bDate.month, bDate.day, bTime.hour, bTime.minute);

            return aDateTime.compareTo(bDateTime);
          });

        final Map<String, List<SessionData>> groupedSessions = {};
        for (var session in filteredSessions) {
          final id = session.session.id.toString();
          final date =
              _formatDate(DateTime.parse(session.session.date.toString()));
          final start = session.starttime;
          final end = session.endtime;

          // Composite key: ID + Date + Time
          final key = '$id|$date|$start-$end';

          groupedSessions.putIfAbsent(key, () => []).add(session);
        }

        // Organize sessions by date for timeline
        final Map<String, List<dynamic>> timelineByDate = {};
        for (var entry in groupedSessions.entries) {
          final sessionGroup = entry.value;
          final first = sessionGroup.first;
          final date = DateTime.parse(first.session.date.toString());
          {
            final dateKey = _formatDate(date);
            final startTime = first.starttime;
            final endTime = first.endtime;

            EventStatus status = EventStatus.upcoming;
            {
              final now = DateTime.now();
              final startParts = startTime.split(":").map(int.parse).toList();
              final endParts = endTime.split(":").map(int.parse).toList();

              final startDateTime = DateTime(
                date.year,
                date.month,
                date.day,
                startParts[0],
                startParts[1],
              );
              final endDateTime = DateTime(
                date.year,
                date.month,
                date.day,
                endParts[0],
                endParts[1],
              );

              if (now.isAfter(startDateTime) && now.isBefore(endDateTime)) {
                status = EventStatus.ongoing;
              } else if (now.isAfter(endDateTime)) {
                status = EventStatus.completed;
              }
            }

            final title = first.name == "Parallel Session"
                ? first.session.name
                : first.name;
            final subtitle =
                first.topic.isNotEmpty ? first.topic : first.session.name;

            timelineByDate.putIfAbsent(dateKey, () => []).add({
              'title': _cleanSessionName(title),
              'subtitle': subtitle,
              'startTime': _formatTime(startTime),
              'endTime': _formatTime(endTime),
              'status': status,
              'activityCount': sessionGroup.length,
              'speakerCount': first.speakers.length,
              'location': first.hall,
              'chair': first.sessionchair,
              'sessionGroup': sessionGroup,
            });
          }
        }

        // Convert to list for timeline widget
        final List<Map<String, dynamic>> timelineEvents = [];
        final sortedDates = timelineByDate.keys.toList();
        for (var dateKey in sortedDates) {
          timelineEvents.add({
            'date': dateKey,
            'events': timelineByDate[dateKey],
          });
        }

        return EventTimeline(
          groupedEvents: timelineEvents,
          onEventTap: (dateIndex, event) {
            Navigator.pushNamed(
              context,
              "/program-details",
              arguments: event['sessionGroup'],
            );
          },
        );
      },
    );
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
    // Removes 'Day <number>' at the end or surrounded by spaces
    final cleaned =
        name.replaceAll(RegExp(r'\bDay\s*\d+\b', caseSensitive: false), '');
    return cleaned
        .replaceAll(RegExp(r'\s{2,}'), ' ')
        .trim(); // clean up extra spaces
  }
}
