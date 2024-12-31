import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';

import '../../../widgets/glowing_dot_indicator.dart';

class TimeLineView extends StatelessWidget {
  final List<CalendarEventData> events;
  TimeLineView({super.key, required this.events});

  final List<GlobalKey> eventKeys = [];
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  final RxBool isScrolledAwayFromCurrent = false.obs;
  final RxInt highlightedEventIndex = (-1).obs; // Track highlighted event
  final RxList<int> searchResultIndices = <int>[].obs; // Track search results
  final RxInt currentSearchResultIndex = 0.obs; // Current index in results
  final RxString scrollDirection =
      ''.obs; // '' for no direction, 'up' or 'down'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        shadowColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(25.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search events...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onSubmitted: (query) {
                      _searchEvent(query);
                    },
                  ),
                ),
                Obx(() {
                  if (searchResultIndices.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_upward),
                        onPressed: _highlightPreviousResult,
                      ),
                      Obx(() => Text(
                          "${currentSearchResultIndex.value + 1} / ${searchResultIndices.length}")),
                      IconButton(
                        icon: const Icon(Icons.arrow_downward),
                        onPressed: _highlightNextResult,
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (events.isEmpty) {
          return const Center(child: Text('No events available.'));
        }

        while (eventKeys.length < events.length) {
          eventKeys.add(GlobalKey());
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToRelevantEvent();
          _checkIfCurrentDayOffscreen();
        });

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            _checkIfCurrentDayOffscreen();
            return true;
          },
          child: SingleChildScrollView(
            controller: scrollController,
            child: FixedTimeline.tileBuilder(
              builder: TimelineTileBuilder.connected(
                contentsAlign: ContentsAlign.alternating,
                contentsBuilder: (context, index) {
                  final event = events[index];
                  return Obx(() {
                    final isHighlighted = index == highlightedEventIndex.value;
                    return AnimatedContainer(
                      key: eventKeys[index],
                      duration: const Duration(milliseconds: 500),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: isHighlighted
                            ? Colors.lightBlueAccent.withOpacity(0.3)
                            : null,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        children: [
                          Text(
                            event.title,
                            style: TextStyle(
                                color: _shouldGlow(event)
                                    ? const Color(0xFF4B39EF)
                                    : null,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Text(
                                DateFormat.yMMMd().format(event.date),
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 11),
                              ),
                              if (!event.endDate.isAtSameMomentAs(event.date))
                                Text(
                                    ' - ${DateFormat.yMMMd().format(event.endDate)}',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
                },
                indicatorBuilder: (context, index) {
                  final event = events[index];
                  return Obx(() {
                    final isHighlighted = index == highlightedEventIndex.value;
                    return _shouldGlow(event)
                        ? const GlowingDotIndicator(
                            color: Color(0xFF4B39EF),
                            size: 24.0,
                            glowColor: Color(0xFF4B39EF),
                          )
                        : DotIndicator(
                            color: _getEventColor(event.date),
                            border: Border.all(
                                color: isHighlighted
                                    ? _getEventColor(event.date) ==
                                            const Color(0xFF4B39EF)
                                        ? Colors.red
                                        : Colors.lightBlueAccent
                                    : Colors.transparent,
                                width: 2.5),
                            size: 24.0,
                          );
                  });
                },
                connectorBuilder: (context, index, connectorType) {
                  final event = events[index];
                  return SolidLineConnector(
                    color: _shouldGlow(event)
                        ? const Color(0xFF4B39EF)
                        : Colors.grey,
                  );
                },
                itemCount: events.length,
              ),
            ),
          ),
        );
      }),
      floatingActionButton: Obx(() {
        if (isScrolledAwayFromCurrent.value) {
          return FloatingActionButton(
            onPressed: () {
              scrollToRelevantEvent();
            },
            child: Icon(
              scrollDirection.value != 'up'
                  ? Icons.arrow_drop_up_rounded
                  : Icons.arrow_drop_down_rounded,
              size: 50,
            ),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  Color _getEventColor(DateTime eventDate) {
    final today = DateTime.now();
    if (eventDate.isBefore(today)) return Colors.grey; // Past events
    if (eventDate.isAfter(today)) {
      return const Color(0xFF4B39EF); // Future events
    }
    return Colors.transparent; // Current event handled with glow
  }

  bool _shouldGlow(CalendarEventData event) {
    final today = DateTime.now();
    return event.date.year == today.year &&
        event.date.month == today.month &&
        event.date.day == today.day;
  }

  void scrollToRelevantEvent() {
    final today = DateTime.now();
    int? index = events.indexWhere((event) =>
        event.date.year == today.year &&
        event.date.month == today.month &&
        event.date.day == today.day);

    if (index == -1) {
      index = _findNearestEventIndex();
    }

    if (index != null && eventKeys[index].currentContext != null) {
      Scrollable.ensureVisible(
        eventKeys[index].currentContext!,
        duration: const Duration(milliseconds: 300),
        alignment: 0.5,
      );
    }
  }

  void _searchEvent(String query) {
    final results = events
        .asMap()
        .entries
        .where((entry) =>
            entry.value.title.toLowerCase().contains(query.toLowerCase()))
        .map((entry) => entry.key)
        .toList();

    if (results.isNotEmpty) {
      searchResultIndices.value = results;
      currentSearchResultIndex.value = 0;
      _highlightSearchResult();
    } else {
      Get.snackbar('Not Found', 'No matching event found.',
          snackPosition: SnackPosition.BOTTOM);
      searchResultIndices.clear();
    }
  }

  void _highlightSearchResult() {
    final index = searchResultIndices[currentSearchResultIndex.value];
    if (eventKeys[index].currentContext != null) {
      Scrollable.ensureVisible(
        eventKeys[index].currentContext!,
        duration: const Duration(milliseconds: 300),
        alignment: 0.5,
      );
      highlightedEventIndex.value = index;
    }
  }

  void _highlightNextResult() {
    if (searchResultIndices.isNotEmpty) {
      currentSearchResultIndex.value =
          (currentSearchResultIndex.value + 1) % searchResultIndices.length;
      _highlightSearchResult();
    }
  }

  void _highlightPreviousResult() {
    if (searchResultIndices.isNotEmpty) {
      currentSearchResultIndex.value =
          (currentSearchResultIndex.value - 1 + searchResultIndices.length) %
              searchResultIndices.length;
      _highlightSearchResult();
    }
  }

  int? _findNearestEventIndex() {
    final today = DateTime.now();
    final nearestIndex = events
        .asMap()
        .entries
        .map((entry) => MapEntry(
            entry.key, (entry.value.date.difference(today).inDays).abs()))
        .reduce((minEntry, currentEntry) =>
            currentEntry.value < minEntry.value ? currentEntry : minEntry)
        .key;
    return nearestIndex;
  }

  void _checkIfCurrentDayOffscreen() {
    final todayIndex = events.indexWhere((event) => _shouldGlow(event));

    if (todayIndex != -1 && eventKeys[todayIndex].currentContext != null) {
      final renderObject =
          eventKeys[todayIndex].currentContext!.findRenderObject();
      if (renderObject is RenderBox) {
        final position = renderObject.localToGlobal(Offset.zero);
        final screenHeight =
            MediaQueryData.fromView(WidgetsBinding.instance.window).size.height;

        final isAboveScreen = position.dy < 0;
        final isBelowScreen = position.dy > screenHeight;

        if (isAboveScreen) {
          scrollDirection.value = 'down'; // Scrolled upwards
        } else if (isBelowScreen) {
          scrollDirection.value = 'up'; // Scrolled downwards
        } else {
          scrollDirection.value = ''; // Current day is visible
        }

        isScrolledAwayFromCurrent.value = isAboveScreen || isBelowScreen;
      }
    }
  }
}
