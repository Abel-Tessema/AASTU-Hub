import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';

import '../controllers/calendar_data_controller.dart';
import '../widgets/glowing_dot_indicator.dart';

class TimeLineView extends StatelessWidget {
  TimeLineView({super.key});
  final CalendarController controller = Get.put(CalendarController());
  final List<GlobalKey> eventKeys = [];
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  final RxBool isScrolledAwayFromCurrent = false.obs;
  final RxInt highlightedEventIndex = (-1).obs; // Track highlighted event
  final RxList<int> searchResultIndices = <int>[].obs; // Track search results
  final RxInt currentSearchResultIndex = 0.obs; // Current index in results

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.events.isEmpty) {
          return const Center(child: Text('No events available.'));
        }

        while (eventKeys.length < controller.events.length) {
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
                  final event = controller.events[index];
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
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text(event.title),
                              content: Text(
                                  event.description ?? 'No details available.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Text(
                              event.title,
                              style: TextStyle(
                                  color:
                                      _shouldGlow(event) ? Colors.blue : null,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              DateFormat.yMMMMd().format(event.date),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                },
                indicatorBuilder: (context, index) {
                  final event = controller.events[index];
                  return Obx(() {
                    final isHighlighted = index == highlightedEventIndex.value;
                    return _shouldGlow(event)
                        ? const GlowingDotIndicator(
                            color: Colors.blue,
                            size: 24.0,
                            glowColor: Colors.blueAccent,
                          )
                        : DotIndicator(
                            color: _getEventColor(event.date),
                            border: Border.all(
                                color: isHighlighted
                                    ? _getEventColor(event.date) == Colors.blue
                                        ? Colors.red
                                        : Colors.lightBlueAccent
                                    : Colors.transparent,
                                width: 2.5),
                            size: 24.0,
                          );
                  });
                },
                connectorBuilder: (context, index, connectorType) =>
                    const SolidLineConnector(),
                itemCount: controller.events.length,
              ),
            ),
          ),
        );
      }),
      floatingActionButton: Obx(() {
        return isScrolledAwayFromCurrent.value
            ? FloatingActionButton(
                onPressed: () {
                  scrollToRelevantEvent();
                },
                child: const Icon(Icons.today),
              )
            : const SizedBox.shrink();
      }),
    );
  }

  Color _getEventColor(DateTime eventDate) {
    final today = DateTime.now();
    if (eventDate.isBefore(today)) return Colors.grey; // Past events
    if (eventDate.isAfter(today)) return Colors.blue; // Future events
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
    int? index = controller.events.indexWhere((event) =>
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
    final results = controller.events
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
    final nearestIndex = controller.events
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
    final todayIndex =
        controller.events.indexWhere((event) => _shouldGlow(event));

    if (todayIndex != -1 && eventKeys[todayIndex].currentContext != null) {
      final renderObject =
          eventKeys[todayIndex].currentContext!.findRenderObject();
      if (renderObject is RenderBox) {
        final position = renderObject.localToGlobal(Offset.zero);
        final screenHeight =
            MediaQueryData.fromView(WidgetsBinding.instance.window).size.height;

        isScrolledAwayFromCurrent.value =
            position.dy < 0 || position.dy > screenHeight;
      }
    }
  }
}
