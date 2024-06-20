import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final class PlayerStatus extends StatelessWidget {
  final bool? isConfirmed;

  const PlayerStatus({
    this.isConfirmed,
    super.key
  });

  Color getColor() => switch (isConfirmed) {
    true => Colors.teal,
    false => Colors.pink,
    null => Colors.blueGrey
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: getColor()
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
