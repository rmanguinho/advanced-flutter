import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/infra/mappers/mapper.dart';
import 'package:advanced_flutter/infra/mappers/next_event_player_mapper.dart';
import 'package:advanced_flutter/infra/types/json.dart';

final class NextEventMapper implements Mapper<NextEvent> {
  @override
  NextEvent toDto(Json json) => NextEvent(
    groupName: json['groupName'],
    date: DateTime.parse(json['date']),
    players: NextEventPlayerMapper().toDtoList(json['players'])
  );

  @override
  Json toJson(NextEvent dto) => {
    'groupName': dto.groupName,
    'date': dto.date.toIso8601String(),
    'players': NextEventPlayerMapper().toJsonArr(dto.players)
  };
}
