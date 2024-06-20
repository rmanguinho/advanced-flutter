import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final class PlayerStatus extends StatelessWidget {
  final bool isConfirmed;

  const PlayerStatus({
    required this.isConfirmed,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.teal
      )
    );
  }
}

void main() {
  testWidgets('should present green status', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PlayerStatus(isConfirmed: true)));
    final decoration = tester.firstWidget<Container>(find.byType(Container)).decoration as BoxDecoration;
    expect(decoration.color, Colors.teal);
  });
}
