import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final class PlayerPosition extends StatelessWidget {
  final String? position;

  const PlayerPosition({
    this.position,
    super.key
  });

  String buildPositionLabel() => switch (position) {
    'goalkeeper' => 'Goleiro',
    'defender' => 'Zagueiro',
    'midfielder' => 'Meia',
    _ => 'Gandula'
  };

  @override
  Widget build(BuildContext context) {
    return Text(buildPositionLabel());
  }
}

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

  testWidgets('should handle positionless', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PlayerPosition(position: null)));
    expect(find.text('Gandula'), findsOneWidget);
  });
}
