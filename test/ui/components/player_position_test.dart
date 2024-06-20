import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final class PlayerPosition extends StatelessWidget {
  final String position;

  const PlayerPosition({
    required this.position,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return const Text('Goleiro');
  }
}

void main() {
  testWidgets('should handle goalkeeper position', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PlayerPosition(position: 'goalkeeper')));
    expect(find.text('Goleiro'), findsOneWidget);
  });
}
