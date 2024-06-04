import 'package:advanced_flutter/domain/entities/next_event_player.dart';

final class NextEvent {
  final String groupName;
  final DateTime date;
  final List<NextEventPlayer> players;

  const NextEvent({
    required this.groupName,
    required this.date,
    required this.players
  });
}
