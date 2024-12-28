import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/calendar_data_controller.dart';

class TableView extends StatelessWidget {
  TableView({super.key});

  final CalendarDataController controller = Get.find();
  final ScrollController scrollController = ScrollController();
  final List<GlobalKey> eventKeys = [];
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxList<CalendarEventData> filteredEvents = <CalendarEventData>[].obs;
  final RxBool isScrolledAwayFromCurrent = false.obs;
  final RxInt highlightedEventIndex = (-1).obs; // Highlighted event index
  final RxList<int> searchResultIndices = <int>[].obs; // Search result indices
  final RxInt currentSearchResultIndex = 0.obs; // Current search result index
  final RxString scrollDirection =
      ''.obs; // '' for no direction, 'up' or 'down'

  @override
  Widget build(BuildContext context) {
    // Initialize filtered events with the original list
    filteredEvents.assignAll(controller.events);

    void filterByPastEvent() {
      filteredEvents.assignAll(controller.events.where((event) {
        return event.date.isBefore(DateTime.now());
      }));
    }

    void filterByFutureEvent() {
      filteredEvents.assignAll(controller.events.where((event) {
        return event.date.isAfter(DateTime.now());
      }));
    }

    void filterByExam() {
      filteredEvents.assignAll(controller.events.where((event) {
        return event.title.toLowerCase().contains('exam');
      }));
    }

    void clearFilters() {
      filteredEvents.assignAll(controller.events);
      searchController.clear();
      searchQuery.value = '';
    }

    void highlightSearchResult() {
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

    void applySearch(String query) {
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
        highlightSearchResult();
      } else {
        Get.snackbar('Not Found', 'No matching event found.',
            snackPosition: SnackPosition.BOTTOM);
        searchResultIndices.clear();
      }
    }

    void highlightNextResult() {
      if (searchResultIndices.isNotEmpty) {
        currentSearchResultIndex.value =
            (currentSearchResultIndex.value + 1) % searchResultIndices.length;
        highlightSearchResult();
      }
    }

    void highlightPreviousResult() {
      if (searchResultIndices.isNotEmpty) {
        currentSearchResultIndex.value =
            (currentSearchResultIndex.value - 1 + searchResultIndices.length) %
                searchResultIndices.length;
        highlightSearchResult();
      }
    }

    int? findNearestEventIndex() {
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

    void scrollToRelevantEvent() {
      final today = DateTime.now();
      int? index = controller.events.indexWhere((event) =>
          event.date.year == today.year &&
          event.date.month == today.month &&
          event.date.day == today.day);

      if (index == -1) {
        index = findNearestEventIndex();
      }

      if (index != null && eventKeys[index].currentContext != null) {
        Scrollable.ensureVisible(
          eventKeys[index].currentContext!,
          duration: const Duration(milliseconds: 300),
          alignment: 0.5,
        );
      }
    }

    bool shouldGlow(CalendarEventData event) {
      final today = DateTime.now();
      return event.date.year == today.year &&
          event.date.month == today.month &&
          event.date.day == today.day;
    }

    void checkIfCurrentDayOffscreen() {
      final todayIndex =
          controller.events.indexWhere((event) => shouldGlow(event));

      if (todayIndex != -1 && eventKeys[todayIndex].currentContext != null) {
        final renderObject =
            eventKeys[todayIndex].currentContext!.findRenderObject();
        if (renderObject is RenderBox) {
          final position = renderObject.localToGlobal(Offset.zero);
          final screenHeight =
              MediaQueryData.fromView(View.of(context)).size.height;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToRelevantEvent();
      checkIfCurrentDayOffscreen();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        shadowColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
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
                    onSubmitted: applySearch,
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
                        onPressed: highlightPreviousResult,
                      ),
                      Obx(() => Text(
                          "${currentSearchResultIndex.value + 1} / ${searchResultIndices.length}")),
                      IconButton(
                        icon: const Icon(Icons.arrow_downward),
                        onPressed: highlightNextResult,
                      ),
                    ],
                  );
                }),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'Past Events') {
                      filterByPastEvent();
                    } else if (value == 'Future Events') {
                      filterByFutureEvent();
                    } else if (value == 'Exams') {
                      filterByExam();
                    } else if (value == 'Clear Filters') {
                      clearFilters();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'Past Events',
                      child: Text('Past Events'),
                    ),
                    const PopupMenuItem(
                      value: 'Future Events',
                      child: Text('Future Events'),
                    ),
                    const PopupMenuItem(
                      value: 'Exams',
                      child: Text('Exams'),
                    ),
                    const PopupMenuItem(
                      value: 'Clear Filters',
                      child: Text('Clear Filters'),
                    ),
                  ],
                  icon: const Icon(Icons.filter_list),
                ),
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

        while (eventKeys.length < filteredEvents.length) {
          eventKeys.add(GlobalKey());
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            checkIfCurrentDayOffscreen();
            return true;
          },
          child: SingleChildScrollView(
            controller: scrollController,
            child: DataTable(
              dataRowMaxHeight: double.infinity,
              columns: const [
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Event')),
              ],
              rows: filteredEvents.asMap().entries.map((entry) {
                final index = entry.key;
                final event = entry.value;
                final isHighlighted = index == highlightedEventIndex.value;
                return DataRow(cells: [
                  DataCell(Text(DateFormat.yMMMMd().format(event.date),
                      style: TextStyle(
                          color: event.title.contains('Current Day')
                              ? Colors.blue
                              : null))),
                  DataCell(
                    AnimatedContainer(
                      key: eventKeys[index],
                      duration: const Duration(milliseconds: 500),
                      decoration: BoxDecoration(
                        color: isHighlighted
                            ? Colors.lightBlueAccent.withOpacity(0.3)
                            : null,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(event.title,
                            style: TextStyle(
                                color: event.title.contains('Current Day')
                                    ? Colors.blue
                                    : null)),
                      ),
                    ),
                  ),
                ]);
              }).toList(),
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
}
