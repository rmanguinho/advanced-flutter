import 'package:flutter/material.dart';

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
    'forward' => 'Atacante',
    _ => 'Gandula'
  };

  @override
  Widget build(BuildContext context) {
    return Text(buildPositionLabel());
  }
}
