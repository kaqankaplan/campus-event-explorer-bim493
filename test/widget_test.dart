import 'package:campus_event_explorer/main.dart';
import 'package:campus_event_explorer/screens/image_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('search and category filters combine across tabs', (
    tester,
  ) async {
    await tester.pumpWidget(const CampusEventApp());
    expect(find.text('6 matching'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '  APP  ');
    await tester.pumpAndSettle();
    expect(find.text('1 matching'), findsOneWidget);

    await tester.tap(find.text('Arts').first);
    await tester.pumpAndSettle();
    expect(find.text('0 matching'), findsOneWidget);
    expect(find.textContaining('No events match'), findsOneWidget);

    await tester.tap(find.text('Favorites').last);
    await tester.pumpAndSettle();
    expect(find.text('0 matching'), findsOneWidget);
    expect(find.text('  APP  '), findsOneWidget);
  });

  testWidgets('favorites update immediately across views', (tester) async {
    await tester.pumpWidget(const CampusEventApp());
    await tester.tap(find.byTooltip('Add favorite').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Favorites').last);
    await tester.pumpAndSettle();
    expect(find.text('1 matching'), findsOneWidget);
    expect(find.text('Robotics Lab Open Day'), findsOneWidget);

    await tester.tap(find.byTooltip('Remove favorite').first);
    await tester.pumpAndSettle();
    expect(find.text('0 matching'), findsOneWidget);
    expect(find.textContaining('No favorites yet'), findsOneWidget);
  });

  testWidgets('last place can be joined and cancelled', (tester) async {
    await tester.pumpWidget(const CampusEventApp());
    await tester.tap(find.text('Arts').first);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Watercolor Studio'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Watercolor Studio'));
    await tester.pumpAndSettle();

    expect(find.text('1 place left'), findsOneWidget);
    await tester.tap(find.text('Join event'));
    await tester.pumpAndSettle();
    expect(find.text('Watercolor Studio'), findsWidgets);
    expect(find.text('Fine Arts Studio, Room 204'), findsWidgets);
    await tester.tap(find.text('No'));
    await tester.pumpAndSettle();
    expect(find.text('1 place left'), findsOneWidget);

    await tester.tap(find.text('Join event'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();
    expect(find.text('Full'), findsOneWidget);
    expect(find.text('Cancel participation'), findsOneWidget);

    await tester.tap(find.text('Cancel participation'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yes, cancel'));
    await tester.pumpAndSettle();
    expect(find.text('1 place left'), findsOneWidget);
    expect(find.text('Join event'), findsOneWidget);
  });

  testWidgets('double tap opens a separate image screen with back navigation', (
    tester,
  ) async {
    await tester.pumpWidget(const CampusEventApp());
    await tester.tap(
      find.image(const AssetImage('assets/images/technology.png')).first,
    );
    await tester.pumpAndSettle();

    final image = find.image(const AssetImage('assets/images/technology.png'));
    await tester.tap(image);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(image);
    await tester.pumpAndSettle();
    expect(find.byType(ImageViewerScreen), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(ImageViewerScreen), findsNothing);
    expect(find.text('Event details'), findsOneWidget);
  });
}
