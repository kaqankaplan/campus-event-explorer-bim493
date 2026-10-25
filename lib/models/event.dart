class Event {
  const Event({
    required this.id,
    required this.title,
    required this.category,
    required this.dateTime,
    required this.venue,
    required this.description,
    required this.imageAsset,
    required this.totalCapacity,
    required this.initialAvailablePlaces,
  });

  final String id;
  final String title;
  final String category;
  final DateTime dateTime;
  final String venue;
  final String description;
  final String imageAsset;
  final int totalCapacity;
  final int initialAvailablePlaces;
}

String formatEventDate(DateTime value) {
  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '${weekdays[value.weekday - 1]}, ${months[value.month - 1]} '
      '${value.day}, ${value.year} · $hour:$minute';
}
