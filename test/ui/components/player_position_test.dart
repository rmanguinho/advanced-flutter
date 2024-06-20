import 'package:advanced_flutter/ui/components/player_position.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('should handle goalkeeper position', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PlayerPosition(position: 'goalkeeper')));
    expect(find.text('Goleiro'), findsOneWidget);
  });

  testWidgets('should handle defender position', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PlayerPosition(position: 'defender')));
    expect(find.text('Zagueiro'), findsOneWidget);
  });

  testWidgets('should handle midfielder position', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PlayerPosition(position: 'midfielder')));
    expect(find.text('Meia'), findsOneWidget);
  });

  testWidgets('should handle forward position', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PlayerPosition(position: 'forward')));
    expect(find.text('Atacante'), findsOneWidget);
  });

  testWidgets('should handle positionless', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PlayerPosition(position: null)));
    expect(find.text('Gandula'), findsOneWidget);
  });
}
