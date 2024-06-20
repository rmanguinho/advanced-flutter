import 'package:advanced_flutter/ui/components/player_status.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('should present green status', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PlayerStatus(isConfirmed: true)));
    final decoration = tester.firstWidget<Container>(find.byType(Container)).decoration as BoxDecoration;
    expect(decoration.color, Colors.teal);
  });

  testWidgets('should present red status', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PlayerStatus(isConfirmed: false)));
    final decoration = tester.firstWidget<Container>(find.byType(Container)).decoration as BoxDecoration;
    expect(decoration.color, Colors.pink);
  });

  testWidgets('should present grey status', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PlayerStatus(isConfirmed: null)));
    final decoration = tester.firstWidget<Container>(find.byType(Container)).decoration as BoxDecoration;
    expect(decoration.color, Colors.blueGrey);
  });
}
