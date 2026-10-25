import 'package:flutter/material.dart';

import '../data/events.dart';
import '../models/event.dart';
import '../theme/app_palette.dart';
import '../widgets/event_card.dart';
import 'event_details_screen.dart';

class EventHomeScreen extends StatefulWidget {
  const EventHomeScreen({super.key});

  @override
  State<EventHomeScreen> createState() => _EventHomeScreenState();
}

class _EventHomeScreenState extends State<EventHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Set<String> _favoriteIds = <String>{};
  final Set<String> _joinedIds = <String>{};
  final Map<String, int> _availablePlaces = {
    for (final event in sampleEvents) event.id: event.initialAvailablePlaces,
  };

  int _selectedTab = 0;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool _isFavorite(Event event) => _favoriteIds.contains(event.id);
  bool _isJoined(Event event) => _joinedIds.contains(event.id);
  int _available(Event event) => _availablePlaces[event.id]!;

  void _toggleFavorite(Event event) {
    setState(() {
      if (!_favoriteIds.add(event.id)) _favoriteIds.remove(event.id);
    });
  }

  bool _join(Event event) {
    if (_isJoined(event) || _available(event) == 0) return false;
    setState(() {
      _joinedIds.add(event.id);
      _availablePlaces[event.id] = _available(event) - 1;
    });
    return true;
  }

  bool _cancel(Event event) {
    if (!_isJoined(event)) return false;
    setState(() {
      _joinedIds.remove(event.id);
      _availablePlaces[event.id] = _available(event) + 1;
    });
    return true;
  }

  List<Event> get _visibleEvents {
    final query = _searchQuery.trim().toLowerCase();
    return sampleEvents.where((event) {
      final inTab = switch (_selectedTab) {
        1 => _isFavorite(event),
        2 => _isJoined(event),
        _ => true,
      };
      final inCategory =
          _selectedCategory == 'All' || event.category == _selectedCategory;
      return inTab && inCategory && event.title.toLowerCase().contains(query);
    }).toList();
  }

  void _openDetails(Event event) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => EventDetailsScreen(
          event: event,
          isFavorite: () => _isFavorite(event),
          isJoined: () => _isJoined(event),
          availablePlaces: () => _available(event),
          onToggleFavorite: () => _toggleFavorite(event),
          onJoin: () => _join(event),
          onCancel: () => _cancel(event),
        ),
      ),
    );
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _searchQuery = '');
  }

  void _selectTab(int index) {
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
    setState(() => _selectedTab = index);
  }

  @override
  Widget build(BuildContext context) {
    final events = _visibleEvents;
    const headings = ['Explore', 'Favorites', 'My Events'];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Campus Event Explorer',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Search event titles',
                      hintStyle: const TextStyle(color: AppPalette.muted),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppPalette.forest,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              tooltip: 'Clear search',
                              onPressed: _clearSearch,
                              icon: const Icon(Icons.close),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 17),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'Technology', 'Arts', 'Sports'].map((
                        category,
                      ) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: _selectedCategory == category,
                            showCheckmark: false,
                            backgroundColor: AppPalette.surface,
                            selectedColor: AppPalette.forest,
                            side: BorderSide(
                              color: _selectedCategory == category
                                  ? AppPalette.forest
                                  : AppPalette.border,
                            ),
                            labelStyle: TextStyle(
                              color: _selectedCategory == category
                                  ? Colors.white
                                  : AppPalette.ink,
                              fontWeight: FontWeight.w700,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            onSelected: (_) =>
                                setState(() => _selectedCategory = category),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 19),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          headings[_selectedTab],
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: AppPalette.ink,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppPalette.sage,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${events.length} matching',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppPalette.forest,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Joined events: ${_joinedIds.length}',
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: AppPalette.muted),
                  ),
                ],
              ),
            ),
          ),
          if (events.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyEventsView(
                tab: _selectedTab,
                hasFilter:
                    _searchQuery.trim().isNotEmpty ||
                    _selectedCategory != 'All',
                onClearSearch: _clearSearch,
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              sliver: SliverList.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return EventCard(
                    event: event,
                    availablePlaces: _available(event),
                    isFavorite: _isFavorite(event),
                    isJoined: _isJoined(event),
                    onTap: () => _openDetails(event),
                    onToggleFavorite: () => _toggleFavorite(event),
                  );
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppPalette.border)),
        ),
        child: NavigationBar(
          backgroundColor: AppPalette.surface,
          indicatorColor: AppPalette.sage,
          elevation: 0,
          selectedIndex: _selectedTab,
          onDestinationSelected: _selectTab,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore, color: AppPalette.forest),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border),
              selectedIcon: Icon(Icons.favorite, color: AppPalette.forest),
              label: 'Favorites',
            ),
            NavigationDestination(
              icon: Icon(Icons.event_available_outlined),
              selectedIcon: Icon(
                Icons.event_available,
                color: AppPalette.forest,
              ),
              label: 'My Events',
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyEventsView extends StatelessWidget {
  const _EmptyEventsView({
    required this.tab,
    required this.hasFilter,
    required this.onClearSearch,
  });

  final int tab;
  final bool hasFilter;
  final VoidCallback onClearSearch;

  @override
  Widget build(BuildContext context) {
    final message = hasFilter
        ? 'No events match your search and category. Try another title or category.'
        : switch (tab) {
            1 => 'No favorites yet. Tap a heart on any event to save it here.',
            2 => 'You have not joined an event yet. Explore events to get started.',
            _ => 'No events are available right now.',
          };
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 26),
          decoration: BoxDecoration(
            color: AppPalette.surface,
            border: Border.all(color: AppPalette.border),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppPalette.sage,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  hasFilter ? Icons.search_off : Icons.event_note,
                  size: 30,
                  color: AppPalette.forest,
                ),
              ),
              const SizedBox(height: 17),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: AppPalette.ink, height: 1.45),
              ),
              if (hasFilter) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: onClearSearch,
                  child: const Text('Clear search'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
