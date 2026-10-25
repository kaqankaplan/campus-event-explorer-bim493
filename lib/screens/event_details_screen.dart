import 'package:flutter/material.dart';

import '../models/event.dart';
import '../theme/app_palette.dart';
import 'image_viewer_screen.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({
    super.key,
    required this.event,
    required this.isFavorite,
    required this.isJoined,
    required this.availablePlaces,
    required this.onToggleFavorite,
    required this.onJoin,
    required this.onCancel,
  });

  final Event event;
  final bool Function() isFavorite;
  final bool Function() isJoined;
  final int Function() availablePlaces;
  final VoidCallback onToggleFavorite;
  final bool Function() onJoin;
  final bool Function() onCancel;

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  Future<void> _join() async {
    final event = widget.event;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Join this event?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Text(formatEventDate(event.dateTime)),
            const SizedBox(height: 4),
            Text(event.venue),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    var joined = false;
    setState(() => joined = widget.onJoin());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          joined ? 'You joined ${event.title}.' : 'No places are available.',
        ),
      ),
    );
  }

  Future<void> _cancel() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel participation?'),
        content: Text(
          'Leave ${widget.event.title}? Your place will become available again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Yes, cancel'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    var cancelled = false;
    setState(() => cancelled = widget.onCancel());
    if (cancelled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Participation in ${widget.event.title} cancelled.'),
        ),
      );
    }
  }

  void _openImage() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ImageViewerScreen(event: widget.event),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final joined = widget.isJoined();
    final available = widget.availablePlaces();
    final full = available == 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event details'),
        actions: [
          IconButton(
            tooltip: widget.isFavorite() ? 'Remove favorite' : 'Add favorite',
            onPressed: () => setState(widget.onToggleFavorite),
            icon: Icon(
              widget.isFavorite() ? Icons.favorite : Icons.favorite_border,
              color: AppPalette.forest,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: GestureDetector(
                  onDoubleTap: _openImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Image.asset(
                        event.imageAsset,
                        width: double.infinity,
                        height: 275,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        margin: const EdgeInsets.all(14),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppPalette.ink.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Double-tap to enlarge',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.category.toUpperCase(),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppPalette.accent,
                      letterSpacing: 1.6,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppPalette.ink,
                      fontWeight: FontWeight.w800,
                      height: 1.18,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppPalette.surface,
                      border: Border.all(color: AppPalette.border),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _DetailLine(
                          icon: Icons.calendar_month_outlined,
                          label: 'When',
                          value: formatEventDate(event.dateTime),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Divider(height: 1, color: AppPalette.border),
                        ),
                        _DetailLine(
                          icon: Icons.place_outlined,
                          label: 'Where',
                          value: event.venue,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        backgroundColor: full
                            ? AppPalette.full
                            : AppPalette.sage,
                        side: BorderSide.none,
                        label: Text(
                          full
                              ? 'Full'
                              : available == 1
                              ? '1 place left'
                              : '$available places left',
                        ),
                      ),
                      Chip(
                        backgroundColor: AppPalette.surface,
                        side: const BorderSide(color: AppPalette.border),
                        label: Text('Capacity: ${event.totalCapacity}'),
                      ),
                      if (joined)
                        const Chip(
                          backgroundColor: AppPalette.sage,
                          side: BorderSide.none,
                          label: Text('You are joined'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'About this event',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    event.description,
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(color: AppPalette.muted, height: 1.55),
                  ),
                  const SizedBox(height: 30),
                  const Divider(color: AppPalette.border),
                  const SizedBox(height: 12),
                  Text(
                    'Event ID: ${event.id}',
                    style: const TextStyle(color: AppPalette.muted),
                  ),
                  Text(
                    'Initial available places: ${event.initialAvailablePlaces}',
                    style: const TextStyle(color: AppPalette.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppPalette.surface,
          border: Border(top: BorderSide(color: AppPalette.border)),
        ),
        child: SafeArea(
          minimum: const EdgeInsets.fromLTRB(20, 12, 20, 14),
          child: joined
              ? OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    foregroundColor: AppPalette.forest,
                    side: const BorderSide(color: AppPalette.forest),
                  ),
                  onPressed: _cancel,
                  icon: const Icon(Icons.event_busy_outlined),
                  label: const Text('Cancel participation'),
                )
              : FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                  ),
                  onPressed: full ? null : _join,
                  icon: Icon(full ? Icons.block : Icons.event_available),
                  label: Text(full ? 'Full' : 'Join event'),
                ),
        ),
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: AppPalette.accent),
      const SizedBox(width: 14),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppPalette.muted,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppPalette.ink,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
