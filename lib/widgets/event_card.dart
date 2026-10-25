import 'package:flutter/material.dart';

import '../models/event.dart';
import '../theme/app_palette.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.availablePlaces,
    required this.isFavorite,
    required this.isJoined,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final Event event;
  final int availablePlaces;
  final bool isFavorite;
  final bool isJoined;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final availability = availablePlaces == 0
        ? 'Full'
        : availablePlaces == 1
        ? '1 place left'
        : '$availablePlaces places left';

    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      elevation: 2,
      shadowColor: AppPalette.ink.withValues(alpha: 0.08),
      color: AppPalette.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppPalette.border),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  event.imageAsset,
                  height: 204,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 14,
                  right: 14,
                  child: Material(
                    color: AppPalette.surface,
                    elevation: 2,
                    shadowColor: Colors.black26,
                    shape: const CircleBorder(),
                    child: IconButton(
                      tooltip: isFavorite ? 'Remove favorite' : 'Add favorite',
                      onPressed: onToggleFavorite,
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: AppPalette.forest,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 17, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          event.category.toUpperCase(),
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppPalette.forest,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                      _AvailabilityPill(
                        label: isJoined
                            ? 'Joined · $availability'
                            : availability,
                        isFull: availablePlaces == 0,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppPalette.ink,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 13),
                  _InfoLine(
                    icon: Icons.calendar_month_outlined,
                    text: formatEventDate(event.dateTime),
                  ),
                  const SizedBox(height: 6),
                  _InfoLine(icon: Icons.place_outlined, text: event.venue),
                  const SizedBox(height: 18),
                  const Divider(height: 1, color: AppPalette.border),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Text(
                        'View details',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppPalette.forest,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 19,
                        color: AppPalette.forest,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvailabilityPill extends StatelessWidget {
  const _AvailabilityPill({required this.label, required this.isFull});

  final String label;
  final bool isFull;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: isFull ? AppPalette.full : AppPalette.sage,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: Theme.of(context).textTheme.labelSmall
          ?.copyWith(color: AppPalette.ink, fontWeight: FontWeight.w700),
    ),
  );
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 17, color: AppPalette.accent),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: AppPalette.muted),
        ),
      ),
    ],
  );
}
