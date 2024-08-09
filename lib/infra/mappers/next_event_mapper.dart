import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/domain/entities/next_event_player.dart';
import 'package:advanced_flutter/infra/mappers/mapper.dart';
import 'package:advanced_flutter/infra/types/json.dart';

final class NextEventMapper implements Mapper<NextEvent> {
  final ListMapper<NextEventPlayer> playerMapper;

  const NextEventMapper({
    required this.playerMapper
  });

  @override
  NextEvent toDto(Json json) => NextEvent(
    groupName: json['groupName'],
    date: DateTime.parse(json['date']),
    players: playerMapper.toDtoList(json['players'])
  );

  @override
  Json toJson(NextEvent dto) => {
    'groupName': dto.groupName,
    'date': dto.date.toIso8601String(),
    'players': playerMapper.toJsonArr(dto.players)
  };
}
