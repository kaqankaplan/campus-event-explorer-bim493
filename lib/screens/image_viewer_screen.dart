import 'package:flutter/material.dart';

import '../models/event.dart';

class ImageViewerScreen extends StatelessWidget {
  const ImageViewerScreen({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(event.title)),
    backgroundColor: Colors.black,
    body: Center(
      child: InteractiveViewer(
        minScale: 1,
        maxScale: 4,
        child: Image.asset(event.imageAsset, fit: BoxFit.contain),
      ),
    ),
  );
}
