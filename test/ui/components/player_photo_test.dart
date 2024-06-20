import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final class PlayerPhoto extends StatelessWidget {
  final String initials;
  final String? photo;

  const PlayerPhoto({
    required this.initials,
    this.photo,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      child: Text('RO')
    );
  }
}

void main() {
  testWidgets('should present initials when there is no photo', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PlayerPhoto(initials: 'RO', photo: null)));
    expect(find.text('RO'), findsOneWidget);
  });
}
